WITH credit_data AS
  (SELECT 'credit_'||c.id::varchar AS sales_id,
          c.encrypted_ref_id AS transaction_id,
          c.status AS transaction_status,
          'Redemption' AS transaction_type,
          CASE
              WHEN c.name like 'Groupon%' THEN 'Groupon'
              WHEN c.name like 'Allē%' THEN 'Allē Coupon'
              WHEN c.name like 'Aspire%' THEN 'Aspire Coupon'
              WHEN c.name like 'Brilliant Distinctions%' THEN 'BD Coupon'
              ELSE 'Other Coupon'
          END AS transaction_method,
          CASE
              WHEN c.name like 'Groupon%'
                   AND c.name != 'Groupon Coupon' THEN right(c.name, len(c.name)-8)
              WHEN c.name like 'Allē%'
                   AND c.name != 'Allē Coupon' THEN right(c.name, len(c.name)-5)
              WHEN c.name like 'Aspire%'
                   AND c.name != 'Aspire Coupon' THEN right(c.name, len(c.name)-7)
              WHEN c.name like 'Brilliant Distinctions%'
                   AND c.name != 'Brilliant Distinctions Coupon' THEN right(c.name, len(c.name)-23)
              WHEN c.name like 'Other%'
                   AND c.name != 'Other Coupon' THEN right(c.name, len(c.name)-6)
          END AS transaction_details,
          NULL::text AS transaction_reason,
          c.amount AS amount,
          c.amount AS amount_available_to_refund,
          c.created_at,
          gt.invoice_id,
          gt.gx_invoice_id,
          gt.invoice_status,
          c.plan_id,
          created_by AS team_member_id,
          NULL::text AS device_id,
          NULL::bigint AS gratuity_amount,
          NULL::bigint AS card_id,
          NULL::text AS card_brand,
          NULL::text AS card_last4,
          NULL::bigint AS card_exp_month,
          NULL::bigint AS card_exp_year,
          NULL::text AS card_holder_name,
          NULL::text AS is_voided
   FROM gaia_opul${environment}.credit c
   LEFT JOIN
     (SELECT DISTINCT gt.invoice_id,
                      invoice.encrypted_ref_id AS gx_invoice_id,
                      gt.source_object_id,
                      invoice.status AS invoice_status
      FROM gaia_opul${environment}.gateway_transaction gt
      INNER JOIN gaia_opul${environment}.invoice ON gt.invoice_id = invoice.id
      WHERE source_object_name = 'credit' ) gt ON gt.source_object_id = c.id
   WHERE c.id IS NOT NULL
     AND c.status in (1,
                      -3,
                      -4) ),
                      
refund_amount AS
  (SELECT payment_id,
          amount AS refund_amount
   FROM gaia_opul${environment}.gateway_transaction
   WHERE source_object_name = 'refund'
     AND status = 20
     AND payment_id IS NOT NULL
     AND invoice_id IS NOT NULL ),
     
payment_void AS
  (SELECT DISTINCT gt.payment_id,
                   CASE
                       WHEN gt.is_voided = 't' THEN 't'::varchar
                   END AS is_voided
   FROM gaia_opul${environment}.gateway_transaction gt
   WHERE card_payment_gateway_id IS NOT NULL
     AND card_payment_gateway_id != 0
     AND gt.payment_id IS NOT NULL
     AND is_voided = 't' ),
     
payment_data AS
  (SELECT 'payment_'||p.id::varchar AS sales_id,
          p.encrypted_ref_id AS transaction_id,
          p.status AS transaction_status,
          'Sale' AS transaction_type,
          CASE
              WHEN p.type = 'cash' THEN 'Cash'
              WHEN p.type = 'check' THEN 'Check'
              WHEN p.type = 'credit_card' THEN 'Credit Card'
              WHEN p.type = 'wallet' THEN 'Wallet'
          END AS transaction_method,
          CASE
              WHEN p.type = 'cash' THEN NULL::text
              WHEN p.type = 'check' THEN p.name
              WHEN p.type = 'credit_card' THEN '****'||card.last4
              WHEN p.type = 'wallet' THEN external_id
          END AS transaction_details,
          NULL::text AS transaction_reason,
          p.amount AS amount,
          p.amount - COALESCE(ra.refund_amount, 0) AS amount_available_to_refund,
          p.created_at,
          gt2.invoice_id,
          gt2.gx_invoice_id,
          gt2.invoice_status,
          p.plan_id,
          p.created_by AS team_member_id,
          p.device_id,
          gratuity.amount AS gratuity_amount,
          card.id AS card_id,
          card.brand AS card_brand,
          card.last4 AS card_last4,
          card.exp_month AS card_exp_month,
          card.exp_year AS card_exp_year,
          card.card_holder_name,
          pv.is_voided
   FROM gaia_opul${environment}.payment p
   LEFT JOIN refund_amount ra ON p.id = ra.payment_id
   LEFT JOIN
     (SELECT DISTINCT gt.payment_id,
                      gt.card_payment_gateway_id
      FROM gaia_opul${environment}.gateway_transaction gt
      WHERE card_payment_gateway_id IS NOT NULL
        AND card_payment_gateway_id != 0
        AND gt.payment_id IS NOT NULL) gt ON gt.payment_id = p.id
   LEFT JOIN
     (SELECT DISTINCT gt.invoice_id,
                      invoice.encrypted_ref_id AS gx_invoice_id,
                      gt.source_object_id,
                      invoice.status AS invoice_status
      FROM gaia_opul${environment}.gateway_transaction gt
      INNER JOIN gaia_opul${environment}.invoice ON gt.invoice_id = invoice.id
      WHERE source_object_name = 'payment' ) gt2 ON gt2.source_object_id = p.id
   LEFT JOIN gaia_opul${environment}.gratuity gratuity ON gratuity.id = p.gratuity_id
   LEFT JOIN gaia_opul${environment}.card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
   LEFT JOIN gaia_opul${environment}.card card ON cpg.card_id = card.id
   LEFT JOIN payment_void pv ON p.id = pv.payment_id
   WHERE p.id IS NOT NULL
     AND p.status in (1,
                      -3) ),

refund as
(    SELECT
    'refund1_'||r.id::varchar  AS sales_id,
    r.encrypted_ref_id as transaction_id,
    case when gt.payment_id is not null then payment.status  else r.status end AS transaction_status,
    'Refund' AS transaction_type,
    case when r.type = 'cash' then 'Cash'
         when r.type = 'check' then 'Check'
         when r.type = 'credit_card' then 'Credit Card'
         else 'Wallet'
        end as transaction_method,
    case when r.type = 'credit_card' then '****'||card.last4||' - '||coalesce(card.brand,r.card_brand) end AS transaction_details,  
    r.reason AS transaction_reason,
    r.amount as amount,
    0 as amount_available_to_refund,
    r.created_at,
    r.invoice_id,
    invoice.encrypted_ref_id as gx_invoice_id,
    invoice.status as invoice_status,
    sub.plan_id,
    r.created_by as team_member_id,
    NULL::text AS device_id,
    NULL::bigint as gratuity_amount,
    card.id as card_id,
    card.brand as card_brand,
    card.last4 as card_last4,
    card.exp_month as card_exp_month,
    card.exp_year as card_exp_year,
    card.card_holder_name AS card_holder_name,
    NULL::text AS is_voided
FROM
    gaia_opul${environment}.refund r
LEFT JOIN
    gaia_opul${environment}.gratuity gratuity
        ON gratuity.id = r.gratuity_id
LEFT JOIN
    gaia_opul${environment}.subscription sub
        ON r.subscription_id = sub.id
LEFT JOIN
    gaia_opul${environment}.gateway_transaction gt
        ON r.gateway_transaction_id = gt.id
LEFT JOIN
    gaia_opul${environment}.payment payment
        ON payment.id = gt.payment_id
LEFT JOIN
    gaia_opul${environment}.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul${environment}.card card
        ON cpg.card_id = card.id
LEFT JOIN
    gaia_opul${environment}.invoice invoice
        ON r.invoice_id = invoice.id
WHERE
    r.subscription_id IS NOT NULL
    AND r.status  in (20,-3)
    AND r.is_void = 'f'
),
     
void AS
  (SELECT 'void_'||r.id::varchar AS sales_id,
          r.encrypted_ref_id AS transaction_id,
          r.status AS transaction_status,
          'Void' AS transaction_type,
          CASE
              WHEN r.type = 'cash' THEN 'Cash'
              WHEN r.type = 'check' THEN 'Check'
              WHEN r.type = 'credit_card' THEN 'Credit Card'
              ELSE 'Wallet'
          END AS transaction_method,
          CASE
              WHEN r.type = 'credit_card' THEN '****'||card.last4
          END AS transaction_details,
          r.reason AS transaction_reason,
          r.amount AS amount,
          0 AS amount_available_to_refund,
          r.created_at,
          r.invoice_id,
          invoice.encrypted_ref_id AS gx_invoice_id,
          invoice.status AS invoice_status,
          sub.plan_id,
          r.created_by AS team_member_id,
          NULL::text AS device_id,
          NULL::bigint AS gratuity_amount,
          card.id AS card_id,
          card.brand AS card_brand,
          card.last4 AS card_last4,
          card.exp_month AS card_exp_month,
          card.exp_year AS card_exp_year,
          card.card_holder_name AS card_holder_name,
          CASE
              WHEN r.is_void = 't' THEN 't'::varchar
              WHEN r.is_void = 'f' THEN 'f'::varchar
              ELSE NULL::VARCHAR
          END AS is_voided
   FROM gaia_opul${environment}.refund r
   LEFT JOIN gaia_opul${environment}.gateway_transaction gt ON r.gateway_transaction_id = gt.id
   LEFT JOIN gaia_opul${environment}.payment payment ON payment.id = payment_id
   LEFT JOIN gaia_opul${environment}.card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
   LEFT JOIN gaia_opul${environment}.card ON cpg.card_id = card.id
   LEFT JOIN gaia_opul${environment}.invoice invoice ON r.invoice_id = invoice.id
   LEFT JOIN gaia_opul${environment}.invoice_item ivi ON gt.invoice_item_id = ivi.id
   LEFT JOIN gaia_opul${environment}.subscription sub ON ivi.subscription_id = sub.id
   WHERE r.status in (20,
                      -3)
     AND r.is_void = 't'
     AND gt.payment_id IS NOT NULL ),
     
invoice_data AS
  (SELECT DISTINCT inv.id::varchar AS inv_id2,
                   inv.status AS inv_status2,
                   CASE
                       WHEN gt.source_object_name = 'payment' THEN 'payment_'||gt.source_object_id::varchar
                       WHEN gt.source_object_name = 'credit' THEN 'credit_'||gt.source_object_id::varchar
                       WHEN gt.source_object_name = 'wallet payment' THEN 'payment_'||gt.payment_id::varchar
                       ELSE NULL
                   END AS sale_id
   FROM gaia_opul${environment}.invoice inv
   LEFT JOIN gaia_opul${environment}.gateway_transaction gt ON inv.id = gt.invoice_id
   WHERE inv.status = -3
     AND source_object_name in ('payment',
                                'credit',
                                'wallet payment') ),
                                
invoice_data2 AS
  (SELECT DISTINCT inv.id::varchar AS inv_id2,
                   inv.status AS inv_status2
   FROM gaia_opul${environment}.invoice inv
   LEFT JOIN gaia_opul${environment}.gateway_transaction gt ON inv.id = gt.invoice_id
   WHERE inv.status = -3
     AND source_object_name in ('payment',
                                'credit',
                                'wallet payment') ),
                                
all_data AS
  (SELECT * FROM credit_data
   UNION ALL 
   SELECT * FROM payment_data
   UNION ALL 
   SELECT * FROM refund
   UNION ALL 
   SELECT * FROM void),
   
payment_summary AS
  (SELECT a.sales_id,
          a.transaction_id,
          org.id AS organization_id,
          a.transaction_status,
          a.transaction_type,
          a.transaction_method,
          a.transaction_details,
          a.transaction_reason,
          a.amount,
          a.amount_available_to_refund,
          a.created_at,
          a.invoice_id,
          a.gx_invoice_id,
          a.invoice_status,
          a.team_member_id,
          a.device_id,
          a.card_holder_name,
          a.is_voided,
          a.gratuity_amount,
          a.card_id,
          a.card_brand,
          a.card_last4,
          a.card_exp_month,
          a.card_exp_year,
          inv.inv_id2,
          inv.inv_status2,
          customer.encrypted_ref_id AS gx_customer_id,
          provider.encrypted_ref_id AS gx_provider_id
   FROM all_data a
   LEFT JOIN gaia_opul${environment}.plan PLAN ON a.plan_id = plan.id
   LEFT JOIN gaia_opul${environment}.customer customer ON customer.id = plan.customer_id
   LEFT JOIN gaia_opul${environment}.provider provider ON provider.id = provider_id
   LEFT JOIN kronos_opul${environment}.organization_data org ON provider.encrypted_ref_id = org.gx_provider_id
   LEFT JOIN invoice_data inv ON a.sales_id = inv.sale_id
   WHERE a.sales_id like 'payment%'
     OR a.sales_id like 'credit%'
  
   UNION ALL 
   
   SELECT a.sales_id,
                    a.transaction_id,
                    org.id AS organization_id,
                    a.transaction_status,
                    a.transaction_type,
                    a.transaction_method,
                    a.transaction_details,
                    a.transaction_reason,
                    a.amount,
                    a.amount_available_to_refund,
                    a.created_at,
                    a.invoice_id,
                    a.gx_invoice_id,
                    a.invoice_status,
                    a.team_member_id,
                    a.device_id,
                    a.card_holder_name,
                    a.is_voided,
                    a.gratuity_amount,
                    a.card_id,
                    a.card_brand,
                    a.card_last4,
                    a.card_exp_month,
                    a.card_exp_year,
                    inv2.inv_id2,
                    inv2.inv_status2,
                    customer.encrypted_ref_id AS gx_customer_id,
                    provider.encrypted_ref_id AS gx_provider_id
   FROM all_data a
   LEFT JOIN gaia_opul${environment}.plan PLAN ON a.plan_id = plan.id
   LEFT JOIN gaia_opul${environment}.customer customer ON customer.id = plan.customer_id
   LEFT JOIN gaia_opul${environment}.provider provider ON provider.id = provider_id
   LEFT JOIN kronos_opul${environment}.organization_data org ON provider.encrypted_ref_id = org.gx_provider_id
   LEFT JOIN invoice_data2 inv2 ON a.invoice_id = inv2.inv_id2
   WHERE
     a.sales_id like 'refund%'
     OR a.sales_id like 'void%' ),

sub_cus AS
  (SELECT subscription.name AS subscription_name,
          customer.encrypted_ref_id AS gx_cus_id,
          count(subscription.created_at) OVER (PARTITION BY customer.encrypted_ref_id
                                               ORDER BY subscription.created_at DESC ROWS BETWEEN UNBOUNDED preceding AND UNBOUNDED FOLLOWING) AS sub_created
   FROM gaia_opul${environment}.subscription subscription
   JOIN gaia_opul${environment}.plan PLAN ON plan_id = plan.id
   JOIN gaia_opul${environment}.customer customer ON customer.id = customer_id
   JOIN gaia_opul${environment}.invoice ON subscription.plan_id = invoice.plan_id
   JOIN kronos_opul${environment}.customer_data customer2 ON customer.encrypted_ref_id = customer2.gx_customer_id
   WHERE subscription.status in (-1,
                                 0,
                                 1,
                                 20)
     AND invoice.status = 20
     AND subscription.auto_renewal = 'f'
     AND customer2.type=1 ),
     
TRANSACTION AS
  (SELECT a.sales_id,
          a.transaction_id,
          a.organization_id,
          a.transaction_status,
          a.transaction_type,
          a.transaction_method,
          a.transaction_details,
          a.transaction_reason,
          a.amount,
          a.amount_available_to_refund,
          sc.subscription_name AS description,
          a.created_at,
          a.invoice_id,
          a.gx_invoice_id,
          a.invoice_status,
          a.team_member_id,
          a.device_id,
          substring(a.card_holder_name, 1, OCTETINDEX(' ', card_holder_name)) AS customer_first_name,
          substring(a.card_holder_name, OCTETINDEX(' ', card_holder_name)+1, len(card_holder_name)) AS customer_last_name,
          a.is_voided,
          a.inv_id2,
          a.inv_status2,
          a.gratuity_amount,
          a.card_id,
          CASE
              WHEN a.card_brand = 'V' THEN 'Visa'
              WHEN a.card_brand = 'A' THEN 'Amex'
              WHEN a.card_brand = 'M' THEN 'Master'
              WHEN a.card_brand = 'D' THEN 'Discover'
              ELSE a.card_brand
          END AS card_brand,
          a.card_last4,
          a.card_exp_month,
          a.card_exp_year,
          a.gx_customer_id,
          a.gx_provider_id,
          CASE
              WHEN (a.sales_id like 'void%')
                   AND a.is_voided = 'Yes' THEN 'BAD'
              WHEN a.inv_status2 = -3
                   AND a.transaction_type != 'Credit Card' THEN 'BAD'
              WHEN a.inv_status2 = -3
                   AND a.transaction_type = 'Credit Card'
                   AND a.is_voided = 't' THEN 'BAD'
              WHEN a.transaction_id IS NULL THEN 'BAD'
              WHEN transaction_status = -3 and a.inv_status2 is null THEN 'BAD'
              ELSE 'GOOD'
          END category
   FROM payment_summary a
   LEFT JOIN
     (SELECT *
      FROM sub_cus
      WHERE sub_created = 1) AS sc ON a.gx_customer_id = sc.gx_cus_id) , sub_plan AS
  (SELECT customer_id,
          min(sub.created_at) AS member_on_boarding_date
   FROM subscription${environment}.plan AS PLAN
   LEFT JOIN subscription${environment}.subscription AS sub ON plan.id = sub.plan_id
   WHERE sub.status = 'ACTIVE'
   GROUP BY 1),
   
customer AS
  (SELECT customer_data.id AS k_customer_id,
          customer_data.gx_customer_id,
          CASE
              WHEN member_on_boarding_date IS NOT NULL THEN TRUE
              ELSE FALSE
          END AS customer_active_subscription,
          users.mobile,
          customer_data.type AS user_type,
          customer_data.user_id AS customer_user_id,
          users.firstname,
          users.lastname
   FROM kronos_opul${environment}.users users
   JOIN kronos_opul${environment}.customer_data customer_data ON users.id = customer_data.user_id
   LEFT JOIN gaia_opul${environment}.customer g_customer ON g_customer.encrypted_ref_id = customer_data.gx_customer_id
   LEFT JOIN sub_plan ON sub_plan.customer_id = g_customer.id),

staff AS
  (SELECT users.title,
          users.id AS user_id,
          CASE
              WHEN users.firstname IS NULL
                   OR users.firstname = '' THEN 'N/A'
              ELSE users.firstname
          END AS firstname,
          CASE
              WHEN users.lastname IS NULL
                   OR users.lastname = '' THEN ''
              ELSE users.lastname
          END AS lastname,
          trim((CASE
                    WHEN users.title IS NULL
                         OR users.title = '' THEN ' '
                    ELSE users.title
                END) || ' ' ||(CASE
                                   WHEN users.firstname IS NULL
                                        OR users.firstname = '' THEN 'N/A'
                                   ELSE users.firstname
                               END) || ' ' || (CASE
                                                   WHEN users.lastname IS NULL
                                                        OR users.lastname = '' THEN ' '
                                                   ELSE users.lastname
                                               END)) AS staff_name,
          users.role,
          CASE
              WHEN users.role=10 THEN 'admin'
              WHEN users.role=6 THEN 'staff'
              WHEN users.role=2 THEN 'curator'
              WHEN users.role=1 THEN 'sys_admin'
          END AS role_name
   FROM kronos_opul${environment}.users
   WHERE users.role in (1,
                        2,
                        6,
                        10) ),

device AS
  (SELECT id AS device_id,
          CASE
              WHEN label IS NULL
                   OR trim(label) = '' THEN 'N/A'
              ELSE label
          END AS label,
          status,
          hsn AS device_hsn,
          device_uuid
   FROM p2pe_opul${environment}.p2pe_device),

main AS
  (SELECT a.sales_id,
          a.transaction_id,
          COALESCE(a.organization_id, 0) AS organization_id,
          a.transaction_status,
          a.transaction_type,
          CASE
              WHEN a.transaction_method = 'Credit Card' THEN a.transaction_method||' - '||a.card_brand
              ELSE a.transaction_method
          END AS transaction_method,
          a.transaction_details,
          a.transaction_reason,
          a.amount,
          a.amount_available_to_refund,
          a.description,
          a.created_at,
          a.gx_invoice_id AS invoice_id,
          a.invoice_status,
          COALESCE(customer.k_customer_id, 0) AS customer_id,
          CASE
              WHEN customer.customer_active_subscription IS NOT NULL THEN customer.customer_active_subscription
              ELSE FALSE
          END customer_active_subscription,
          COALESCE(COALESCE(a.customer_first_name, customer.firstname), 'Quick Pay') AS customer_first_name,
          COALESCE(COALESCE(a.customer_last_name, customer.lastname), 'N/A') AS customer_last_name,
          customer.user_type AS customer_type,
          customer.mobile AS customer_mobile,
          a.team_member_id::integer AS team_member_id,
          staff.firstname AS team_member_first_name,
          staff.lastname AS team_member_last_name,
          a.device_id,
          device_hsn,
          device.label AS device_nickname,
          customer.customer_user_id,
          gratuity_amount,
          a.amount + COALESCE(gratuity_amount, 0) AS total,
          card_id,
          card_brand,
          card_last4,
          card_exp_month::integer,
          card_exp_year::integer,
          category
   FROM TRANSACTION a
   LEFT JOIN customer ON a.gx_customer_id = customer.gx_customer_id
   LEFT JOIN device ON a.device_id = device.device_uuid
   LEFT JOIN staff ON a.team_member_id = staff.user_id
   WHERE a.category = 'GOOD'
   )
   
SELECT * FROM main
ORDER BY created_at DESC

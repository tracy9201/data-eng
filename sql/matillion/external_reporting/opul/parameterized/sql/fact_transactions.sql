WITH credit_data as
(   SELECT
    'credit_'||c.id::varchar AS sales_id,
    c.encrypted_ref_id as transaction_id,
    c.status AS transaction_status,
    'payment' AS transaction_type,
    case when c.name like 'Groupon%' then 'Groupon'
        when c.name like 'Allē%' then 'Allē_Coupon'
        when c.name like 'Aspire%' then 'Aspire_Coupon'
        when c.name like 'Brilliant Distinctions%' then 'BD_Coupon'
        else 'Other_Coupon'
        end AS transaction_method,
    case when c.name like 'Groupon%' and c.name != 'Groupon Coupon' then right(c.name, len(c.name)-8)
        when c.name like 'Allē%' and c.name != 'Allē Coupon' then right(c.name, len(c.name)-5)
        when c.name like 'Aspire%' and c.name != 'Aspire Coupon' then right(c.name, len(c.name)-7)
        when c.name like 'Brilliant Distinctions%' and c.name != 'Brilliant Distinctions Coupon' then right(c.name, len(c.name)-23)
        when c.name like 'Other%' and c.name != 'Other Coupon' then right(c.name, len(c.name)-6)
        end as transaction_details,
    NULL::text as transaction_reason,
    coalesce((c.amount)/100,0) as amount,
    coalesce((c.amount)/100,0) as amount_available_for_refund,
    c.created_at,
    gt.invoice_id,
    gt.invoice_status,
    c.plan_id,
    created_by as team_member_id,
    NULL::text AS device_id,
    NULL::text as card_holder_name,
    NULL::text AS is_voided
FROM
    gaia_opul${environment}.credit c
LEFT JOIN
(SELECT distinct 
  gt.invoice_id, 
  gt.source_object_id,
  invoice.status as invoice_status
FROM  gaia_opul${environment}.gateway_transaction gt
inner join 
  gaia_opul${environment}.invoice on gt.invoice_id = invoice.id
WHERE 
  source_object_name = 'credit' 
  ) gt
        ON gt.source_object_id = c.id   
WHERE
    c.id IS NOT NULL
    AND c.status  in (1,-3,-4)
),
payment_void as 
( SELECT 
    distinct 
    gt.payment_id, 
    CASE WHEN gt.is_voided = 't' then 't'::varchar END AS is_voided
  FROM  
    gaia_opul${environment}.gateway_transaction gt
  WHERE 
    card_payment_gateway_id IS NOT NULL 
    and card_payment_gateway_id != 0
    and gt.payment_id is not null 
    and is_voided = 't'
),
payment_data as
(   SELECT 
    'payment_'||p.id::varchar  AS sales_id,
    p.encrypted_ref_id as transaction_id,
    p.status AS transaction_status,
    'payment' AS transaction_type,
    p.type AS transaction_method,
    case when p.type = 'cash' then NULL::text
        when p.type = 'check' then p.name 
        when p.type = 'credit_card' then coalesce(card.brand,p.card_brand)
        when p.type = 'wallet' then external_id
        end as transaction_details,
    NULL::text as transaction_reason,
    coalesce((p.amount)/100,0) as amount,
    coalesce((p.amount)/100,0) as amount_available_for_refund,
    p.created_at,
    gt2.invoice_id,
    gt2.invoice_status,
    p.plan_id,
    p.created_by as team_member_id,
    p.device_id,
    card.card_holder_name,
    pv.is_voided
FROM
    gaia_opul${environment}.payment p
LEFT JOIN
 (SELECT distinct 
  gt.payment_id, 
  gt.card_payment_gateway_id
FROM  gaia_opul${environment}.gateway_transaction gt
WHERE 
  card_payment_gateway_id IS NOT NULL and card_payment_gateway_id != 0
  and gt.payment_id is not null) gt
        ON gt.payment_id = p.id
LEFT JOIN
(SELECT distinct 
  gt.invoice_id, 
  gt.source_object_id,
  invoice.status as invoice_status
FROM  gaia_opul${environment}.gateway_transaction gt
inner join 
  gaia_opul${environment}.invoice on gt.invoice_id = invoice.id
WHERE 
  source_object_name = 'payment' 
  ) gt2
         ON gt2.source_object_id = p.id   
LEFT JOIN
    gaia_opul${environment}.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul${environment}.card card
        ON cpg.card_id = card.id
left join 
    payment_void pv
    on p.id = pv.payment_id
WHERE
    p.id IS NOT NULL
    AND p.status  in (1,-3)
),

refund1 as
(    SELECT
    'refund1_'||r.id::varchar  AS sales_id,
    r.encrypted_ref_id as transaction_id,
    r.status AS transaction_status,
    'refund' AS transaction_type,
    r.type AS transaction_method,
    case when r.type = 'credit_card' then card.brand else NULL::text end AS transaction_details,
    r.reason AS transaction_reason,
    coalesce((r.amount)/100,0) as amount,
    coalesce((r.amount)/100,0) as amount_available_for_refund,
    r.created_at,
    r.invoice_id,
    invoice.status as invoice_status,
    sub.plan_id,
    r.created_by as team_member_id,
    NULL::text AS device_id,
    card.card_holder_name AS card_holder_name,
    NULL::text AS is_voided
FROM
    gaia_opul${environment}.refund r
LEFT JOIN
    gaia_opul${environment}.gratuity gratuity
        ON gratuity.id = r.gratuity_id
LEFT JOIN
    gaia_opul${environment}.subscription sub
        ON subscription_id = sub.id
LEFT JOIN
    gaia_opul${environment}.gateway_transaction gt
        ON r.gateway_transaction_id = gt.id
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
    subscription_id IS NOT NULL
    AND r.status  in (20,-3)
    AND r.is_void = 'f'
),
refund2 as
(   SELECT
    'refund2_'||r.id::varchar  AS sales_id,
    r.encrypted_ref_id as transaction_id,
    r.status AS transaction_status,
    'refund' AS transaction_type,
    r.type AS transaction_method,
    case when r.type = 'credit_card' then card.brand else NULL::text end AS transaction_details,
    r.reason AS transaction_reason,
    coalesce((r.amount)/100,0) as amount,
    coalesce((r.amount)/100,0) as amount_available_for_refund,
    r.created_at,
    r.invoice_id,
    invoice.status as invoice_status,
    sub.plan_id,
    r.created_by as team_member_id,
    NULL::text AS device_id,
    card.card_holder_name AS card_holder_name,
    NULL::text AS is_voided
FROM
    gaia_opul${environment}.refund r
LEFT JOIN
    gaia_opul${environment}.gateway_transaction gt
        ON gateway_transaction_id = gt.id
LEFT JOIN
    gaia_opul${environment}.payment  payment
        ON gt.payment_id = payment.id
LEFT JOIN
    gaia_opul${environment}.subscription sub
        ON payment.subscription_id = sub.id
LEFT JOIN
    gaia_opul${environment}.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul${environment}.card
        ON cpg.card_id = card.id
LEFT JOIN
    gaia_opul${environment}.invoice invoice
        ON r.invoice_id = invoice.id
WHERE
    r.subscription_id IS NULL
    AND gt.invoice_item_id IS NULL
    AND source_object_name = 'refund'
    AND r.status  in (20,-3)
    AND r.is_void = 'f'
),
void1 as
(    SELECT
    'void1_'||r.id::varchar AS sales_id,
    r.encrypted_ref_id as transaction_id,
    r.status AS transaction_status,
    'void' AS transaction_type,
    r.type AS transaction_method,
    case when r.type = 'credit_card' then card.brand else NULL::text end AS transaction_details,
    r.reason AS transaction_reason,
    coalesce((r.amount)/100,0) as amount,
    coalesce((r.amount)/100,0) as amount_available_for_refund,
    r.created_at,
    r.invoice_id,
    invoice.status as invoice_status,
    sub.plan_id,
    r.created_by as team_member_id,
    NULL::text AS device_id,
    card.card_holder_name AS card_holder_name,
    CASE WHEN r.is_void = 't' then 't'::varchar 
         WHEN r.is_void = 'f' then 'f'::varchar else NULL::VARCHAR  END AS is_voided
FROM
    gaia_opul${environment}.refund r
LEFT JOIN
    gaia_opul${environment}.gateway_transaction gt
        ON r.gateway_transaction_id = gt.id
LEFT JOIN
    gaia_opul${environment}.invoice_item ivi
        ON gt.invoice_item_id = ivi.id
LEFT JOIN
    gaia_opul${environment}.subscription sub
        ON ivi.subscription_id = sub.id
LEFT JOIN
    gaia_opul${environment}.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul${environment}.card
        ON cpg.card_id = card.id
LEFT JOIN
    gaia_opul${environment}.invoice invoice
        ON r.invoice_id = invoice.id
WHERE
    r.status  in (20,-3)
    AND r.is_void = 't'
    AND gt.payment_id IS NULL
),
void2 as
(   SELECT
    'void2_'||r.id::varchar AS sales_id,
    r.encrypted_ref_id as transaction_id,
    r.status AS transaction_status,
    'void' AS transaction_type,
    r.type AS transaction_method,
    case when r.type = 'credit_card' then card.brand else NULL::text end AS transaction_details,
    r.reason AS transaction_reason,
    coalesce((r.amount)/100,0) as amount,
    coalesce((r.amount)/100,0) as amount_available_for_refund,
    r.created_at,
    r.invoice_id,
    invoice.status as invoice_status,
    sub.plan_id,
    r.created_by as team_member_id,
    NULL::text AS device_id,
    card.card_holder_name AS card_holder_name,
    CASE WHEN r.is_void = 't' then 't'::varchar 
         WHEN r.is_void = 'f' then 'f'::varchar else NULL::VARCHAR END AS is_voided
FROM
    gaia_opul${environment}.refund r

LEFT JOIN
    gaia_opul${environment}.gateway_transaction gt
        ON r.gateway_transaction_id = gt.id
LEFT JOIN
    gaia_opul${environment}.payment payment
        ON payment.id = payment_id
LEFT JOIN
    gaia_opul${environment}.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul${environment}.card
        ON cpg.card_id = card.id
LEFT JOIN
    gaia_opul${environment}.invoice invoice
        ON r.invoice_id = invoice.id
LEFT JOIN
    gaia_opul${environment}.invoice_item ivi
        ON gt.invoice_item_id = ivi.id
LEFT JOIN
    gaia_opul${environment}.subscription sub
        ON ivi.subscription_id = sub.id
WHERE
    r.status in (20,-3)
    AND r.is_void = 't'
    AND gt.payment_id IS NOT NULL
),
invoice_data as (
  select distinct 
    inv.id::varchar as inv_id2,
    inv.status as inv_status2,
    case 
      when gt.source_object_name = 'payment' then 'payment_'||gt.source_object_id::varchar
      when gt.source_object_name = 'credit' then 'credit_'||gt.source_object_id::varchar
      when gt.source_object_name = 'wallet payment' then 'payment_'||gt.payment_id::varchar
      else null
      end AS sale_id
  from gaia_opul${environment}.invoice inv
  left join
    gaia_opul${environment}.gateway_transaction gt
      on inv.id = gt.invoice_id
  where inv.status = -3 and source_object_name in ('payment', 'credit', 'wallet payment')
),
invoice_data2 as (
  select distinct 
    inv.id::varchar as inv_id2,
    inv.status as inv_status2
  from gaia_opul${environment}.invoice inv
  left join
    gaia_opul${environment}.gateway_transaction gt
      on inv.id = gt.invoice_id
  where inv.status = -3 and source_object_name in ('payment', 'credit', 'wallet payment')
),
all_data AS
(
    SELECT * FROM credit_data
    UNION ALL
    SELECT * FROM payment_data
    UNION ALL
    SELECT * FROM refund1
    UNION ALL
    SELECT * FROM refund2
    UNION ALL
    SELECT * FROM void1
    UNION ALL
    SELECT * FROM void2
),
payment_summary as
(
    SELECT
    a.sales_id,
    a.transaction_id,
    a.transaction_status,
    a.transaction_type,
    a.transaction_method,
    a.transaction_details,
    a.transaction_reason,
    a.amount,
    a.amount_available_for_refund,
    a.created_at,
    a.invoice_id,
    a.invoice_status,
    a.team_member_id,
    a.device_id,
    a.card_holder_name,
    a.is_voided,
    inv.inv_id2,
    inv.inv_status2,
    customer.encrypted_ref_id as gx_customer_id,
    provider.encrypted_ref_id as gx_provider_id
    FROM all_data a
    LEFT JOIN
    gaia_opul${environment}.plan plan
        ON a.plan_id = plan.id
    LEFT JOIN
    gaia_opul${environment}.customer customer
        ON customer.id = plan.customer_id
    LEFT JOIN
    gaia_opul${environment}.provider provider
        ON provider.id = provider_id
    LEFT JOIN
    invoice_data inv
        ON a.sales_id = inv.sale_id
    where a.sales_id like 'payment%' or a.sales_id like 'credit%'
    
    UNION ALL
    
    SELECT
    a.sales_id,
    a.transaction_id,
    a.transaction_status,
    a.transaction_type,
    a.transaction_method,
    a.transaction_details,
    a.transaction_reason,
    a.amount,
    a.amount_available_for_refund,
    a.created_at,
    a.invoice_id,
    a.invoice_status,
    a.team_member_id,
    a.device_id,
    a.card_holder_name,
    a.is_voided,
    inv2.inv_id2,
    inv2.inv_status2,
    customer.encrypted_ref_id as gx_customer_id,
    provider.encrypted_ref_id as gx_provider_id
    FROM all_data a
    LEFT JOIN
    gaia_opul${environment}.plan plan
        ON a.plan_id = plan.id
    LEFT JOIN
    gaia_opul${environment}.customer customer
        ON customer.id = plan.customer_id
    LEFT JOIN
    gaia_opul${environment}.provider provider
        ON provider.id = provider_id
    LEFT JOIN
    invoice_data2 inv2
        ON a.invoice_id = inv2.inv_id2
    where a.sales_id like 'refund1%' or a.sales_id like 'refund2%' or a.sales_id like 'void1%' or  a.sales_id like 'void2%'
),
sub_cus as
(
    SELECT
    subscription.name AS subscription_name,
    customer.encrypted_ref_id AS gx_cus_id,
    count(subscription.created_at) over (partition by customer.encrypted_ref_id order by subscription.created_at desc rows between unbounded preceding and unbounded following) as sub_created
FROM
    gaia_opul${environment}.subscription subscription
JOIN
    gaia_opul${environment}.plan plan
        ON plan_id = plan.id
JOIN
    gaia_opul${environment}.customer customer
        ON customer.id = customer_id
JOIN
    gaia_opul${environment}.invoice
        ON subscription.plan_id = invoice.plan_id
join 
    kronos_opul${environment}.customer_data customer2 on customer.encrypted_ref_id = customer2.gx_customer_id
WHERE
    subscription.status in (-1,0,1,20)
    AND invoice.status = 20
    AND subscription.auto_renewal = 'f'
    AND customer2.type=1

),

transaction as
(
  select 
    a.sales_id,
    a.transaction_id,
    a.transaction_status,
    a.transaction_type,
    a.transaction_method,
    a.transaction_details,
    a.transaction_reason,
    a.amount,
    a.amount_available_for_refund,
    sc.subscription_name as description, 
    a.created_at,
    a.invoice_id,
    a.invoice_status,
    a.team_member_id,
    a.device_id,
    substring(a.card_holder_name, 1, OCTETINDEX(' ', card_holder_name)) as customer_first_name,
    substring(a.card_holder_name, OCTETINDEX(' ', card_holder_name)+1, len(card_holder_name)) as customer_last_name,
    a.is_voided,
    a.inv_id2,
    a.inv_status2,
    a.gx_customer_id,
    a.gx_provider_id,
    case when (a.sales_id like 'void1%' or a.sales_id like 'void2%') and a.is_voided = 'Yes' then 'BAD'
       when a.inv_status2 = -3 and a.transaction_type != 'credit_card' then 'BAD'
       when a.inv_status2 = -3 and a.transaction_type = 'credit_card' and a.is_voided = 't' then 'BAD'
       else 'GOOD' end  category
  from payment_summary a
  left join (select * from sub_cus where sub_created = 1) as sc on a.gx_customer_id = sc.gx_cus_id
  
) ,

main as
(
    select 
    a.transaction_id,
    a.transaction_status,
    a.transaction_type,
    a.transaction_method,
    a.transaction_details,
    a.transaction_reason,
    a.amount,
    a.amount_available_for_refund,
    a.description, 
    a.created_at,
    a.invoice_id,
    a.invoice_status,
    a.team_member_id,
    a.device_id,
    a.customer_first_name,
    a.customer_last_name,
    a.gx_customer_id,
    a.gx_provider_id
    from transaction a
    where a.category = 'GOOD'
)
select * from main
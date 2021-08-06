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
FROM  gaia_opul.gateway_transaction gt
inner join 
  gaia_opul.invoice on gt.invoice_id = invoice.id
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
    gaia_opul.gateway_transaction gt
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
    gaia_opul.payment p
LEFT JOIN
 (SELECT distinct 
  gt.payment_id, 
  gt.card_payment_gateway_id
FROM  gaia_opul.gateway_transaction gt
WHERE 
  card_payment_gateway_id IS NOT NULL and card_payment_gateway_id != 0
  and gt.payment_id is not null) gt
        ON gt.payment_id = p.id
LEFT JOIN
(SELECT distinct 
  gt.invoice_id, 
  gt.source_object_id,
  invoice.status as invoice_status
FROM  gaia_opul.gateway_transaction gt
inner join 
  gaia_opul.invoice on gt.invoice_id = invoice.id
WHERE 
  source_object_name = 'payment' 
  ) gt2
         ON gt2.source_object_id = p.id   
LEFT JOIN
    gaia_opul.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul.card card
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
    gaia_opul.refund r
LEFT JOIN
    gaia_opul.gratuity gratuity
        ON gratuity.id = r.gratuity_id
LEFT JOIN
    gaia_opul.subscription sub
        ON subscription_id = sub.id
LEFT JOIN
    gaia_opul.gateway_transaction gt
        ON r.gateway_transaction_id = gt.id
LEFT JOIN
    gaia_opul.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul.card card
        ON cpg.card_id = card.id
LEFT JOIN
    gaia_opul.invoice invoice
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
    gaia_opul.refund r
LEFT JOIN
    gaia_opul.gateway_transaction gt
        ON gateway_transaction_id = gt.id
LEFT JOIN
    gaia_opul.payment  payment
        ON gt.payment_id = payment.id
LEFT JOIN
    gaia_opul.subscription sub
        ON payment.subscription_id = sub.id
LEFT JOIN
    gaia_opul.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul.card
        ON cpg.card_id = card.id
LEFT JOIN
    gaia_opul.invoice invoice
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
    gaia_opul.refund r
LEFT JOIN
    gaia_opul.gateway_transaction gt
        ON r.gateway_transaction_id = gt.id
LEFT JOIN
    gaia_opul.invoice_item ivi
        ON gt.invoice_item_id = ivi.id
LEFT JOIN
    gaia_opul.subscription sub
        ON ivi.subscription_id = sub.id
LEFT JOIN
    gaia_opul.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul.card
        ON cpg.card_id = card.id
LEFT JOIN
    gaia_opul.invoice invoice
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
    gaia_opul.refund r

LEFT JOIN
    gaia_opul.gateway_transaction gt
        ON r.gateway_transaction_id = gt.id
LEFT JOIN
    gaia_opul.payment payment
        ON payment.id = payment_id
LEFT JOIN
    gaia_opul.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul.card
        ON cpg.card_id = card.id
LEFT JOIN
    gaia_opul.invoice invoice
        ON r.invoice_id = invoice.id
LEFT JOIN
    gaia_opul.invoice_item ivi
        ON gt.invoice_item_id = ivi.id
LEFT JOIN
    gaia_opul.subscription sub
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
  from gaia_opul.invoice inv
  left join
    gaia_opul.gateway_transaction gt
      on inv.id = gt.invoice_id
  where inv.status = -3 and source_object_name in ('payment', 'credit', 'wallet payment')
),
invoice_data2 as (
  select distinct 
    inv.id::varchar as inv_id2,
    inv.status as inv_status2
  from gaia_opul.invoice inv
  left join
    gaia_opul.gateway_transaction gt
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
    org.id as organization_id,
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
    gaia_opul.plan plan
        ON a.plan_id = plan.id
    LEFT JOIN
    gaia_opul.customer customer
        ON customer.id = plan.customer_id
    LEFT JOIN
    gaia_opul.provider provider
        ON provider.id = provider_id
    LEFT JOIN
    kronos_opul.organization_data org
        ON provider.encrypted_ref_id = org.gx_provider_id
    LEFT JOIN
    invoice_data inv
        ON a.sales_id = inv.sale_id
    where a.sales_id like 'payment%' or a.sales_id like 'credit%'
    
    UNION ALL
    
    SELECT
    a.sales_id,
    a.transaction_id,
    org.id as organization_id,
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
    gaia_opul.plan plan
        ON a.plan_id = plan.id
    LEFT JOIN
    gaia_opul.customer customer
        ON customer.id = plan.customer_id
    LEFT JOIN
    gaia_opul.provider provider
        ON provider.id = provider_id
    LEFT JOIN
    kronos_opul.organization_data org
        ON provider.encrypted_ref_id = org.gx_provider_id
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
    gaia_opul.subscription subscription
JOIN
    gaia_opul.plan plan
        ON plan_id = plan.id
JOIN
    gaia_opul.customer customer
        ON customer.id = customer_id
JOIN
    gaia_opul.invoice
        ON subscription.plan_id = invoice.plan_id
join 
    kronos_opul.customer_data customer2 on customer.encrypted_ref_id = customer2.gx_customer_id
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
    a.organization_id,
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

sub_plan AS 
(SELECT
    customer_id,
    to_date(plan.created_at,'yyyy-mm-dd') AS member_on_boarding_date,
    to_date(plan.deprecated_at,'yyyy-mm-dd') AS member_cancel_date,
    plan.status as plan_status
FROM
    subscription_qe.plan as plan
), 

customer AS 
( SELECT
    customer_data.id AS k_customer_id,
    customer_data.gx_customer_id,
    CASE          
        WHEN member_on_boarding_date is NOT NULL and plan_status ='ACTIVE' THEN 'TRUE'          
        WHEN member_on_boarding_date is NOT NULL and plan_status !='ACTIVE' THEN 'FALSE' 
        ELSE 'FALSE' 
    END AS customer_has_subscription,
    users.mobile,
    sub_plan.member_on_boarding_date,
    sub_plan.member_cancel_date,
    sub_plan.plan_status,
    case when customer_data.type = 1 then 'Guest' else 'Patient' end AS user_type,
    users.firstname,
    users.lastname
FROM kronos_opul.users  users
JOIN kronos_opul.customer_data customer_data ON users.id = customer_data.user_id  
LEFT JOIN gaia_opul.customer g_customer ON g_customer.encrypted_ref_id = customer_data.gx_customer_id  
LEFT JOIN sub_plan ON sub_plan.customer_id = g_customer.id  
),

staff as 
(
    SELECT  
    users.title,
    users.id as user_id,
    case when users.firstname IS NULL or users.firstname = '' then 'N/A' else users.firstname end as firstname,  
    case when users.lastname IS NULL or users.lastname = '' then '' else users.lastname end as lastname, 
    trim((case when users.title IS NULL or users.title = '' then ' ' else users.title end) || ' ' ||(case when users.firstname IS NULL or users.firstname = '' then 'N/A' else users.firstname end) || ' ' || (case when users.lastname IS NULL or users.lastname = '' then ' ' else users.lastname end)) AS staff_name,
    users.role,
    case  
      when users.role=10 then 'admin'
      when users.role=6 then 'staff'
      when users.role=2 then 'curator'
      when users.role=1 then 'sys_admin'
    end as role_name
    FROM kronos_opul.users 
    where users.role in (1,2,6,10)
),

device as
(SELECT
 	id AS device_id,
 	case when label IS NULL or trim(label) = '' then 'N/A' else label end AS label,
 	status,
 	device_uuid
FROM
	p2pe_opul${environment}.p2pe_device 
),

main as
(
    select 
    a.transaction_id,
    a.organization_id,
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
    customer.k_customer_id as customer_id,
    case when customer.customer_has_subscription is not null then customer.customer_has_subscription
      else 'FALSE' end customer_has_subscription,
    COALESCE(a.customer_first_name, customer.firstname) as customer_first_name,
    COALESCE(a.customer_last_name, customer.lastname) as customer_last_name,
    customer.user_type as customer_type,
    customer.mobile as customer_mobile,
    a.team_member_id,
    staff.firstname as team_member_first_name,
    staff.lastname as team_member_last_name,
    a.device_id,
    device.label as device_nickname
    FROM transaction a
    LEFT JOIN 
      customer
        ON a.gx_customer_id = customer.gx_customer_id
    LEFT JOIN
      device
        ON a.device_id = device.device_uuid
    LEFT JOIN
      staff
        ON a.team_member_id = staff.user_id
    WHERE a.category = 'GOOD'
)

SELECT * FROM main

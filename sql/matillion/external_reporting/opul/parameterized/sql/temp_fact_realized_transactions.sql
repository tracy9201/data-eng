WITH ful_sale as (
  SELECT 
    ful.id as ful_id, 
    ful.name as ful_name,
    ful.service_date, 
    ful.created_at,
    ful.updated_at,
    round(cast(ful.quantity_rendered as numeric)/100,2) as ful_quantity,
    sub.unit_name,
    round(cast(sub.quantity as numeric)/100,2) as quantity,
    round(cast(sub.total as numeric)/100,2) as total,
    ful.status as ful_status, 
    ful.type as ful_type,
    ful.fulfilled_by,
    ful.subscription_id,
    kcus.gx_customer_id,
    org.gx_provider_id
  FROM gaia_opul${environment}.fulfillment ful
  left join 
    gaia_opul${environment}.subscription sub 
      on sub.id = ful.subscription_id
  left join 
    gaia_opul${environment}.plan plan 
      on sub.plan_id = plan.id
  left join 
    gaia_opul${environment}.customer cus 
      on cus.id = plan.customer_id
  left join 
    kronos_opul${environment}.customer_data kcus
      on kcus.gx_customer_id = cus.encrypted_ref_id
  left join 
    kronos_opul${environment}.users kuser
      on kuser.id = kcus.user_id
  left join 
    kronos_opul${environment}.organization_data org 
      on kuser.organization_id = org.id
  where 
    sub.auto_renewal = 'false' 
    and ful.status = 0 
    and ful.quantity_rendered > 0 
),
ful_refund as (
  select
    ful.id as ful_id, 
    sum (round(cast(refund.amount as numeric)/100,2)) as refund_amount
  FROM gaia_opul${environment}.fulfillment ful
  inner join 
    gaia_opul${environment}.subscription sub 
      on sub.id = subscription_id
  inner join 
    gaia_opul${environment}.refund refund 
      on refund.subscription_id = sub.id
  where 
    sub.auto_renewal = 'false' 
    and ful.status = 0 
    and ful.quantity_rendered > 0 
    and refund.status =20
  group by 1
),
offering as (
  select 
    distinct inv.subscription_id,
    inv.offering_id as offering_id
  from gaia_opul${environment}.invoice_item inv
  left join 
    gaia_opul${environment}.subscription sub
      on sub.id = subscription_id
  where inv.status = 20
    and sub.auto_renewal = 'false' 
    and sub.status = 0
),
main as (
  select 
    'ful_'||ful_sale.ful_id::varchar||'_refund' AS ful_id,
    ful_sale.ful_name,
    'refund' as type,
    ful_sale.service_date, 
    0 as ful_quantity,
    ful_sale.unit_name,
    ful_sale.quantity,
    coalesce(-1*refund_amount,0) as total,
    0 as offering_id,
    ful_sale.ful_status, 
    ful_sale.ful_type,
    ful_sale.fulfilled_by,
    ful_sale.subscription_id,
    ful_sale.gx_customer_id,
    ful_sale.gx_provider_id,
    extract (epoch from ful_sale.created_at) as epoch_created_at,
    ful_sale.created_at,
    ful_sale.updated_at,
    current_timestamp::timestamp as dwh_created_at
  from ful_sale 
    inner join ful_refund 
      on ful_sale.ful_id = ful_refund.ful_id
  
  UNION ALL
  
  select 
    'ful_'||ful_sale.ful_id::varchar AS ful_id,
    ful_sale.ful_name,
    'sales' as type,
    ful_sale.service_date, 
    ful_quantity,
    ful_sale.unit_name,
    ful_sale.quantity,
    ful_sale.total as total,
    cast(offering_id as integer) as offering_id,
    ful_sale.ful_status, 
    ful_sale.ful_type,
    ful_sale.fulfilled_by,
    ful_sale.subscription_id,
    ful_sale.gx_customer_id,
    ful_sale.gx_provider_id,
    extract (epoch from ful_sale.created_at) as epoch_created_at,
    ful_sale.created_at,
    ful_sale.updated_at,
    current_timestamp::timestamp as dwh_created_at
  from ful_sale
  left join offering
    on ful_sale.subscription_id = offering.subscription_id
  
)
select * from main
  with Offering as
  (
      SELECT distinct
      gx_subscription_id
    	,plan_id
      ,subscription.type as subscription_type
      ,subscription.offering_id
      ,subscription.updated_at
      FROM internal_kronos_hint.subscription subscription
      WHERE subscription.status in (0,7)
  ),
  subscription_payment as
  (
    select
      'invoice_'||cast(invoice.id AS text) AS id1
      ,'invoice_'||cast(invoice.id AS text)||'_sub_'||cast(coalesce(subscription.id,invoice_item.id) AS text) as id
      ,case when invoice.pay_date is null then invoice.updated_at else invoice.pay_date end as pay_date
      ,invoice.id as invoice
      ,subscription.id as subscription_id
      ,subscription.quantity/100 as units
      ,subscription.end_count as subscription_cycle
      ,subscription.unit_name as unit_type
      ,round(cast((subscription.subtotal+ invoice_item.discounts)/subscription.quantity*100.0 as numeric),2)/100 as price_unit 
      ,(subscription.subtotal+ invoice_item.discounts) as total_price
      ,renewal_count as recurring_cycle
      ,subscription.encrypted_ref_id as gx_subscription_id
      ,customer.encrypted_ref_id as gx_customer_id
      ,provider.encrypted_ref_id as gx_provider_id
      ,subscription.created_at as subscription_created_at
      ,subscription.canceled_at as subscription_canceled_at
      ,subscription.updated_at as subscription_updated_at
      ,o.offering_id
      ,o.subscription_type
      ,least(invoice.updated_at,invoice_item.updated_at,subscription.updated_at,discount.updated_at,plan.updated_at,customer.updated_at,provider.updated_at,o.updated_at) as updated_at
      FROM internal_gaia_hint.invoice invoice
      LEFT JOIN internal_gaia_hint.invoice_item invoice_item on invoice_item.invoice_id = invoice.id
      LEFT JOIN internal_gaia_hint.subscription subscription on invoice_item.subscription_id = subscription.id
      LEFT JOIN internal_gaia_hint.discount discount on discount.subscription_id = subscription.id
      LEFT JOIN internal_gaia_hint.plan plan on subscription.plan_id = plan.id
      LEFT JOIN internal_gaia_hint.customer customer on plan.customer_id = customer.id
      LEFT JOIN internal_gaia_hint.provider provider on customer.provider_id = provider.id
      LEFT JOIN Offering o on o.gx_subscription_id = subscription.encrypted_ref_id
      WHERE invoice.status=20
  ),
  main as
  (select 
      gx_subscription_id
      ,units
      ,unit_type
      ,price_unit
      ,subscription_cycle
      ,total_price
      ,recurring_cycle
      ,subscription_type
      ,offering_id
      ,subscription_created_at
      ,subscription_canceled_at
      ,subscription_updated_at
      ,gx_customer_id
      ,gx_provider_id
      ,updated_at
      ,current_timestamp::timestamp as dwh_created_at
    from subscription_payment
    group by 
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15
    )
    select * from main
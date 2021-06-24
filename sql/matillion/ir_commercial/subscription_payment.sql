  with Offering as
  (
      SELECT distinct
      gx_subscription_id
    	,plan_id
      ,subscription.type as subscription_type
      ,subscription.offering_id
      FROM kronos.subscription subscription
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
      ,(subscription.subtotal+ invoice_item.discounts)/subscription.quantity*100.0 as price_unit
      ,(subscription.subtotal+ invoice_item.discounts) as total_price
      ,renewal_count as recurring_payment
      ,invoice_item.subtotal + invoice_item.discounts as invoice_amount
      ,invoice_item.amount + invoice_item.discounts as invoice_actual_amount
      ,invoice_item.coupons + invoice_item.credits + invoice_item.payments as invoice_credit
      ,invoice_item.subtotal as discounted_Price
      ,invoice_item.tax as tax_charged
      ,case when invoice_item.tax >0 then invoice_item.subtotal else 0 end as taxable_amount
      ,invoice_item.discounts as item_discount
      ,discount.note as discount_reason
      ,invoice_item.total as grand_total
      ,subscription.encrypted_ref_id as gx_subscription_id
      ,customer.encrypted_ref_id as gx_customer_id
      ,provider.encrypted_ref_id as gx_provider_id
      ,subscription.created_at as subscription_created_at
      ,subscription.canceled_at as subscription_canceled_at
      ,subscription.updated_at as subscription_updated_at
      FROM gaia.invoice invoice
      LEFT JOIN gaia.invoice_item invoice_item on invoice_item.invoice_id = invoice.id
      LEFT JOIN gaia.subscription subscription on invoice_item.subscription_id = subscription.id
      LEFT JOIN gaia.discount discount on discount.subscription_id = subscription.id
      LEFT JOIN gaia.plan plan on subscription.plan_id = plan.id
      LEFT JOIN gaia.customer customer on plan.customer_id = customer.id
      LEFT JOIN gaia.provider provider on customer.provider_id = provider.id
      WHERE invoice.status=20
  ),
  subscription_payment_offering as(
  SELECT id
      ,pay_date
      ,invoice
      ,subscription_id
      ,units
      ,unit_type
      ,round(cast(price_unit as numeric),2)/100 as price_unit
      ,subscription_cycle
      ,round(cast((case when id like '%sub%' then total_price else (sum(total_price) over (partition by invoice)) end) as numeric)/100,2) as total_price
      ,case when id like '%sub%' then recurring_payment else (sum(recurring_payment) over (partition by invoice))/(count(recurring_payment) over (partition by invoice) ) end as recurring_cycle
      ,round(cast((case when id like '%sub%' then tax_charged else (sum(tax_charged) over (partition by invoice)) end) as numeric)/100,2) as tax_charged
      ,round(cast((case when id like '%sub%' then item_discount else (sum(item_discount) over (partition by invoice)) end) as numeric)/100,2) as item_discount
      ,round(cast((case when id like '%sub%' then grand_total else (sum(grand_total) over (partition by invoice)) end) as numeric)/100,2) as grand_total
      ,subscription_payment.gx_subscription_id
      ,gx_customer_id
      ,gx_provider_id
      ,o.offering_id
      ,subscription_type
      ,subscription_created_at
      ,subscription_canceled_at
      ,subscription_updated_at
  FROM subscription_payment
  LEFT JOIN Offering o on o.gx_subscription_id = subscription_payment.gx_subscription_id
  order by invoice,id
  ),
  main as
  (select 
      subscription_id
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
      ,sum(tax_charged) as total_paid_tax
      ,sum(item_discount) as total_discounted
      ,sum(grand_total) as total_paid
    from subscription_payment_offering
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
      12
    )
    select * from main
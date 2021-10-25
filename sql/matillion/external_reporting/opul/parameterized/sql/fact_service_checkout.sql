
WITH 
  main as
  (
    select
      invoice.id AS invoice_id
      ,invoice_item.id AS invoice_item_id
      ,case when invoice.pay_date is null then invoice.updated_at else invoice.pay_date end as pay_date
      ,round(cast(subscription.quantity as numeric),2)/100 as units
      ,subscription.unit_name as unit_type
      ,(invoice_item.subtotal+ invoice_item.discounts)*100/subscription.quantity as price_unit
      ,round(cast((invoice_item.subtotal + invoice_item.discounts) as numeric),2)/100 as total_price
      ,round(cast((invoice_item.subtotal) as numeric),2)/100 as discounted_price
      ,round(cast(invoice_item.discounts as numeric),2)/100 as item_discount
      ,round(cast(invoice_item.tax as numeric),2)/100 as tax
      ,discount.note as discount_reason
      ,round(cast(invoice_item.total as numeric),2)/100 as grand_total
      ,subscription.encrypted_ref_id as gx_subscription_id
      ,customer.encrypted_ref_id as gx_customer_id
      ,provider.encrypted_ref_id as gx_provider_id
      ,invoice_item.offering_id
      FROM gaia_opul${environment}.invoice invoice
      LEFT JOIN gaia_opul${environment}.invoice_item invoice_item on invoice_item.invoice_id = invoice.id
      LEFT JOIN gaia_opul${environment}.subscription subscription on invoice_item.subscription_id = subscription.id
      LEFT JOIN gaia_opul${environment}.discount discount on discount.subscription_id = subscription.id
      LEFT JOIN gaia_opul${environment}.plan plan on subscription.plan_id = plan.id
      LEFT JOIN gaia_opul${environment}.customer customer on plan.customer_id = customer.id
      LEFT JOIN gaia_opul${environment}.provider provider on customer.provider_id = provider.id
    	
      WHERE invoice.status=20 
  ) 

  SELECT 
    invoice_item_id,
    units,
    unit_type,
    round(cast(price_unit as numeric)/100,2) as price_unit,
    total_price,
    item_discount,
    discount_reason,
    discounted_price,
    grand_total,
    offering_id,
    gx_customer_id,
    gx_provider_id
  FROM main
 
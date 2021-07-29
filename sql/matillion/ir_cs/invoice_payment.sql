WITH Invoice_level as
  (
      SELECT
      'invoice_'||cast(invoice.id AS text) AS id1
      ,null as id2
      ,case when invoice.pay_date is null then invoice.updated_at else invoice.pay_date end as pay_date
      ,invoice.id as invoice
      ,null as subscription_id
      ,0 as units
      ,null as subscription_cycle
      ,NULL as unit_type
      ,0 as price_unit
      ,0 as total_price
      ,0 as recurring_payment
      ,0 as invoice_amount
      ,0 as invoice_actual_amount
      ,0 as invoice_credit
      ,0 as discounted_Price
      ,0 as tax_charged
      ,0 as taxable_amount
      ,0 as item_discount
      ,NULL as discount_reason
      ,0 as grand_total
      ,NULL as gx_subscription_id
      ,customer.encrypted_ref_id as gx_customer_id
      ,provider.encrypted_ref_id as gx_provider_id
      ,count_of_invoice_item
    	,cast('1' as INTEGER) as count_brand
      ,cast('1' as INTEGER) as count_product
      ,cast('1' as INTEGER) as count_sku
      FROM internal_gaia_hint.invoice invoice
      left join (select invoice_id, count(*) as count_of_invoice_item from internal_gaia_hint.invoice_item group by 1) invoice_item on invoice_id = invoice.id
      LEFT JOIN internal_gaia_hint.plan plan on invoice.plan_id = plan.id
      LEFT JOIN internal_gaia_hint.customer customer on plan.customer_id = customer.id
      LEFT JOIN internal_gaia_hint.provider provider on customer.provider_id = provider.id
      WHERE  invoice.status=20
  ),
  Offering as
  (
      SELECT distinct
      gx_subscription_id
    	,plan_id
      ,subscription.status as subscription_status
      ,catalog_item.name as product_service
      ,brand.name as brand
      ,sku
      FROM internal_kronos_hint.subscription subscription
      LEFT JOIN internal_kronos_hint.offering offering on offering_id = offering.id
      LEFT JOIN internal_kronos_hint.catalog_item catalog_item on catalog_item.id = catalog_item_id
      left join internal_kronos_hint.brand brand on brand.id = brand_id
      WHERE subscription.status in (0,7)
  ),
  Invoice_Item_level as
  (
    select
      'invoice_'||cast(invoice.id AS text) AS id1
      ,'invoice_'||cast(invoice.id AS text)||'_sub_'||cast(coalesce(subscription.id,invoice_item.id) AS text) AS id2
      ,case when invoice.pay_date is null then invoice.updated_at else invoice.pay_date end as pay_date
      ,invoice.id as invoice
      ,subscription.id as subscription_id
      ,subscription.quantity/100 as units
      ,subscription.end_count as subscription_cycle
      ,subscription.unit_name as unit_type
      ,(subscription.subtotal+ invoice_item.discounts)/subscription.quantity*100 as price_unit
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
      ,count(*) over (partition by invoice.id) as count_of_invoice_item
    	,dense_rank()over(partition by invoice order by o.brand ) as count_brand
      ,dense_rank()over(partition by invoice order by o.product_service )  as count_product
      ,dense_rank()over(partition by invoice order by o.sku ) as count_sku
      FROM internal_gaia_hint.invoice invoice
      LEFT JOIN internal_gaia_hint.invoice_item invoice_item on invoice_item.invoice_id = invoice.id
      LEFT JOIN internal_gaia_hint.subscription subscription on invoice_item.subscription_id = subscription.id
      LEFT JOIN internal_gaia_hint.discount discount on discount.subscription_id = subscription.id
      LEFT JOIN internal_gaia_hint.plan plan on subscription.plan_id = plan.id
      LEFT JOIN internal_gaia_hint.customer customer on plan.customer_id = customer.id
      LEFT JOIN internal_gaia_hint.provider provider on customer.provider_id = provider.id
    	LEFT JOIN Offering o on o.gx_subscription_id = subscription.encrypted_ref_id
      WHERE invoice.status=20
  ) ,
  main as
  (
      SELECT *, id1 as id FROM Invoice_level where count_of_invoice_item>1
      UNION ALL
      SELECT *, id2 as id FROM Invoice_Item_level where count_of_invoice_item>1
      UNION ALL
      SELECT *, id1 as id FROM Invoice_Item_level where count_of_invoice_item=1
  )
  SELECT id
      ,pay_date
      ,invoice
      ,subscription_id
      ,units
      ,unit_type
      ,round(cast(price_unit as numeric),2)/100 as price_unit
      ,subscription_cycle
      ,round(cast((case when id like '%sub%' then total_price else (sum(total_price) over (partition by invoice)) end) as numeric)/100,2) as total_price
      ,case when id like '%sub%' then recurring_payment else (sum(recurring_payment) over (partition by invoice))/(count(recurring_payment) over (partition by invoice) ) end as recurring_payment
      ,round(cast((case when id like '%sub%' then invoice_amount else (sum(invoice_amount) over (partition by invoice)) end) as numeric)/100,2) as invoice_amount
      ,round(cast((case when id like '%sub%' then discounted_Price else (sum(discounted_Price) over (partition by invoice)) end) as numeric)/100,2) as discounted_Price
      ,round(cast((case when id like '%sub%' then tax_charged else (sum(tax_charged) over (partition by invoice)) end) as numeric)/100,2) as tax_charged
      ,round(cast((case when id like '%sub%' then taxable_amount else (sum(taxable_amount) over (partition by invoice)) end) as numeric)/100,2) as taxable_amount
      ,round(cast((case when id like '%sub%' then item_discount else (sum(item_discount) over (partition by invoice)) end) as numeric)/100,2) as item_discount
      ,case when id like '%sub%' then discount_reason else (case when (sum(case when discount_reason is not null then 1 else 0 end ) over (partition by invoice))>0 then 'Various' else null end) end as discount_reason
      ,round(cast((case when id like '%sub%' then grand_total else (sum(grand_total) over (partition by invoice)) end) as numeric)/100,2) as grand_total
      ,main.gx_subscription_id
      ,gx_customer_id
      ,gx_provider_id
      ,count_of_invoice_item
      ,round(cast((case when id like '%sub%' then invoice_actual_amount else (sum(invoice_actual_amount) over (partition by invoice)) end) as numeric)/100,2) as invoice_actual_amount
      ,round(cast((case when id like '%sub%' then invoice_credit else (sum(invoice_credit) over (partition by invoice)) end) as numeric)/100,2) as invoice_credit
      ,max(count_brand)over(partition by invoice) as count_distinct_brand
      ,case when max(count_brand)over(partition by invoice) = 1 and id not like '%sub%' then first_value(brand ignore nulls) over (partition by invoice order by count_brand rows between unbounded preceding and unbounded following)
            when max(count_brand)over(partition by invoice) >1  and id not like '%sub%' then 'Various'
            else brand end as brand
      ,max(count_product)over(partition by invoice)  as count_distinct_product
      ,case when max(count_product)over(partition by invoice) = 1 and id not like '%sub%' then first_value(product_service ignore nulls) over (partition by invoice order by count_brand rows between unbounded preceding and unbounded following)
            when max(count_product)over(partition by invoice) >1  and id not like '%sub%' then 'Various'
            else product_service end as product_service
      ,max(count_sku)over(partition by invoice)  as count_distinct_sku
      ,sku
  FROM main
  LEFT JOIN Offering o on o.gx_subscription_id = main.gx_subscription_id
  order by invoice,id

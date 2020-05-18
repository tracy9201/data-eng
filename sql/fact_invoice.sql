BEGIN;

DELETE FROM dwh.fact_invoice_item;

INSERT INTO dwh.fact_invoice_item
WITH Invoice_level as
(
    SELECT
    'invoice_'||cast(invoice.id AS text) AS id
    ,invoice.pay_date as pay_date
    ,invoice.id as invoice
    ,null as subscription_id
    ,0 as units
    ,null as subscription_cycle
    ,NULL as unit_type
    ,0 as price_unit
    ,0 as total_price
    ,0 as recurring_payment
    ,0 as invoice_amount
    ,0 as discounted_Price
    ,0 as tax_charged
    ,0 as tax_percentage
    ,0 as item_discount
    ,NULL as discount_reason
    ,0 as grand_total
    ,NULL as gx_subscription_id
    ,customer.encrypted_ref_id as gx_customer_id
    ,provider.encrypted_ref_id as gx_provider_id
    ,count_of_invoice_item 
    FROM rds_data.g_invoice invoice
    left join (select invoice_id, count(*) as count_of_invoice_item from rds_data.g_invoice_item group by 1) invoice_item on invoice_id = invoice.id
    LEFT JOIN rds_data.g_plan plan on invoice.plan_id = plan.id
    LEFT JOIN rds_data.g_customer customer on plan.customer_id = customer.id
    LEFT JOIN rds_data.g_provider provider on customer.provider_id = provider.id
    WHERE  invoice.status=20
),
Invoice_Item_level as
(
  select
    'invoice_'||cast(invoice.id AS text)||'_sub_'||cast(subscription.id AS text) AS id
    ,invoice.pay_date as pay_date
    ,invoice.id as invoice
    ,subscription.id as subscription_id
    ,subscription.quantity as units
    ,subscription.end_count as subscription_cycle
    ,subscription.unit_name as unit_type
    ,(subscription.subtotal+ (case when discount.amount_off is null then 0 end))/subscription.quantity as price_unit
    ,(subscription.subtotal+ (case when discount.amount_off is null then 0 end)) as total_price
    ,renewal_count as recurring_payment
    ,invoice_item.subtotal + invoice_item.discounts as invoice_amount
    ,invoice_item.subtotal as discounted_Price
    ,invoice_item.tax as tax_charged
    ,invoice_item.tax_percentage as tax_percentage
    ,discount.amount_off as item_discount
    ,discount.note as discount_reason
    ,invoice_item.total as grand_total
    ,subscription.encrypted_ref_id as gx_subscription_id
    ,customer.encrypted_ref_id as gx_customer_id
    ,provider.encrypted_ref_id as gx_provider_id
    ,count(*) over (partition by invoice.id) as count_of_invoice_item
    FROM rds_data.g_invoice invoice
    LEFT JOIN rds_data.g_invoice_item invoice_item on invoice_item.invoice_id = invoice.id
    LEFT JOIN rds_data.g_subscription subscription on invoice_item.subscription_id = subscription.id
    LEFT JOIN rds_data.g_discount discount on discount.subscription_id = subscription.id
    LEFT JOIN rds_data.g_plan plan on subscription.plan_id = plan.id
    LEFT JOIN rds_data.g_customer customer on plan.customer_id = customer.id
    LEFT JOIN rds_data.g_provider provider on customer.provider_id = provider.id
    WHERE invoice.status=20
) ,
main as
(
    SELECT * FROM Invoice_level where count_of_invoice_item>1
    UNION ALL
    SELECT * FROM Invoice_Item_level where count_of_invoice_item>1
    UNION ALL
    SELECT * FROM Invoice_Item_level where count_of_invoice_item=1
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
    ,tax_percentage as tax_percentage
    ,round(cast((case when id like '%sub%' then item_discount else (sum(item_discount) over (partition by invoice)) end) as numeric)/100,2) as item_discount
    ,case when id like '%sub%' then discount_reason else (case when (sum(item_discount) over (partition by invoice))>0 then 'Various' else null end) end as discount_reason
    ,round(cast((case when id like '%sub%' then grand_total else (sum(grand_total) over (partition by invoice)) end) as numeric)/100,2) as grand_total
    ,gx_subscription_id
    ,gx_customer_id
    ,gx_provider_id
    ,count_of_invoice_item
FROM main order by invoice,id;

COMMIT;
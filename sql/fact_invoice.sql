WITH Invoice_level as
(
    SELECT
    'invoice_'||cast(invoice.id AS text) AS id
    ,invoice.pay_date as date
    ,invoice.id as invoice
    ,null as subscription_id
    ,0 as units
    ,null as subscription_cycle
    ,NULL as unit_type
    ,0 as price_unit
    ,0 as total_price
    ,0 as invoice_charge
    ,0 as discounted_Price
    ,0 as tax_charged
    ,0 as tax_percentage
    ,0 as item_discount
    ,NULL as discount_reason
    ,NULL as gx_subscription_id
    ,customer.encrypted_ref_id as gx_customer_id
    ,provider.encrypted_ref_id as gx_provider_id
    FROM rds_data.g_invoice invoice
    LEFT JOIN rds_data.g_plan plan on invoice.plan_id = plan.id
    LEFT JOIN rds_data.g_customer customer on plan.customer_id = customer.id
    LEFT JOIN rds_data.g_provider provider on customer.provider_id = provider.id
    WHERE  invoice.status=20
),
Invoice_Item_level as
(
    SELECT
    'invoice_'||cast(invoice.id AS text)||'_sub_'||cast(subscription.id AS text) AS id
    ,NULL as date
    ,invoice.id as invoice
    ,subscription.id as subscription_id
    ,subscription.quantity as units
    ,subscription.end_count as subscription_cycle
    ,subscription.unit_name as unit_type
    ,(subscription.subtotal+discount.amount_off)/subscription.quantity as price_unit
    ,(subscription.subtotal+discount.amount_off) as total_price
    ,(subscription.subtotal/subscription.end_count) as invoice_charge
    ,subscription.subtotal as discounted_Price
    ,subscription.tax as tax_charged
    ,subscription.tax_percentage as tax_percentage
    ,discount.amount_off as item_discount
    ,discount.note as discount_reason
    ,subscription.encrypted_ref_id as gx_subscription_id
    ,customer.encrypted_ref_id as gx_customer_id
    ,provider.encrypted_ref_id as gx_provider_id
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
    SELECT * FROM Invoice_level
    UNION ALL
    SELECT * FROM Invoice_Item_level
)
SELECT *  FROM main;

------product sales--------------
SELECT subscription.id AS subscription_id, subscription.encrypted_ref_id AS k_subscirption_id, subscription.quantity, subscription.unit_name, subscription.remaining_payment, subscription.balance, subscription.discount_percentages, subscription.discount_amts, subscription.coupons, subscription.credits, subscription.payments, subscription.total_installment, subscription.tax, subscription.subtotal, subscription.total, subscription.START_date, subscription.END_date, subscription.end_count, subscription.END_unit, subscription.proration, subscription.auto_renewal, subscription.renewal_count, subscription.name AS subscription_name, subscription.created_at AS subscription_created, subscription.updated_at AS subscription_updated_at, subscription.canceled_at AS subscription_canceled_at, plan.id AS plan_id, plan.encrypted_ref_id AS k_plan_id, customer_id, customer.mobile_number AS customer_mobile, provider.name AS practice
FROM v4_g_subscription subscription 
JOIN v4_g_plan plan ON plan_id = plan.id
join v4_g_invoice invoice on subscription.plan_id = invoice.plan_id
JOIN v4_g_customer customer ON customer.id = customer_id
JOIN v4_g_provider provider ON provider.id = provider_id
WHERE subscription.status = 1 and subscription.auto_renewal = 'f' and invoice.status != 20 and subscription.created_at < '2020-06-16'
order by subscription.created_at desc limit 100

---------------void for payment_summary-------------

SELECT 'void3_'||cast(refund.id AS text) AS sales_id, refund.name AS sales_name, refund.amount AS sales_amount, refund.type AS sales_type, refund.status AS sales_status, refund.created_at AS sales_created_at
--, customer.encrypted_ref_id AS gx_customer_id
, provider.name AS gx_provider_id,  CASE WHEN refund.id IS NOT NULL THEN '' END AS transaction_id,  refund.reason AS payment_id, null as tokenization, subscription.encrypted_ref_id AS gx_subscription_id
, refund.created_by AS staff_user_id, NULL AS device_id, gratuity.amount AS gratuity_amount, refund.is_void::text AS is_voided
 FROM v4_g_refund refund
LEFT JOIN gratuity ON gratuity.id = refund.gratuity_id
LEFT JOIN v4_g_gateway_transaction gateway_transaction ON refund.gateway_transaction_id = gateway_transaction.id
left join v4_g_invoice_item invoice_item on gateway_transaction.invoice_item_id = invoice_item.id
LEFT JOIN v4_g_subscription subscription ON invoice_item.subscription_id = subscription.id
LEFT JOIN v4_g_plan plan ON subscription.plan_id = plan.id
LEFT JOIN v4_g_customer customer ON customer.id = plan.customer_id
LEFT JOIN v4_g_provider provider ON provider.id = provider_id
WHERE  refund.status =20 AND refund.is_void = 't'

-----------------refund for payment------------------

SELECT 'refund1_'||cast(refund.id AS text) AS sales_id, refund.name AS sales_name, refund.amount AS sales_amount, refund.type AS sales_type, refund.status AS sales_status, refund.created_at AS sales_created_at, customer.mobile_number AS gx_customer_id, provider.encrypted_ref_id AS gx_provider_id,  CASE WHEN refund.id IS NOT NULL THEN '' END AS transaction_id
--, CASE WHEN refund.type = 'credit_card' THEN last4 ELSE refund.reason END AS payment_id
--, card_payment_gateway.tokenization
, subscription.encrypted_ref_id AS gx_subscription_id
, refund.created_by AS staff_user_id, NULL AS device_id, gratuity.amount AS gratuity_amount, null as is_voided
 FROM v4_g_refund refund
LEFT JOIN gratuity ON gratuity.id = refund.gratuity_id
LEFT JOIN v4_g_subscription subscription ON subscription_id = subscription.id
LEFT JOIN v4_g_plan plan ON subscription.plan_id = plan.id
LEFT JOIN v4_g_customer customer ON customer.id = plan.customer_id
LEFT JOIN v4_g_provider provider ON provider.id = provider_id
LEFT JOIN v4_g_gateway_transaction gateway_transaction ON refund.gateway_transaction_id = gateway_transaction.id
--LEFT JOIN card_payment_gateway ON card_payment_gateway.id = gateway_transaction.card_payment_gateway_id
--LEFT JOIN card ON card_payment_gateway.card_id = card.id
WHERE 
subscription_id IS NOT NULL AND refund.status =20 
AND customer.encrypted_ref_id IS  NULL 
--AND 
--refund.type IN ('credit_card','adjustment')  
AND refund.is_void = 'f'
--and customer.mobile_number = '+'
--limit 199

UNION

SELECT 'refund3_'||cast(refund.id AS text) AS sales_id, refund.name AS sales_name, refund.amount AS sales_amount, refund.type AS sales_type, refund.status AS sales_status,
refund.created_at AS sales_created_at, customer.mobile_number AS gx_customer_id, provider.encrypted_ref_id AS gx_provider_id, gateway_transaction.transaction_id,
--CASE WHEN refund.type = 'credit_card' THEN last4 ELSE refund.reason END AS payment_id, card_payment_gateway.tokenization, 
subscription.encrypted_ref_id AS gx_subscription_id
, refund.created_by AS staff_user_id, NULL AS device_id, gratuity.amount AS gratuity_amount, null as is_voided
FROM v4_g_refund refund
LEFT JOIN gratuity ON gratuity.id = refund.gratuity_id
LEFT JOIN v4_g_gateway_transaction gateway_transaction ON gateway_transaction_id = gateway_transaction.id
LEFT JOIN v4_g_payment payment ON gateway_transaction.payment_id = payment.id
LEFT JOIN v4_g_plan plan ON payment.plan_id = plan.id
LEFT JOIN v4_g_subscription subscription ON payment.subscription_id = subscription.id
LEFT JOIN v4_g_customer customer ON customer.id = plan.customer_id
LEFT JOIN v4_g_provider provider ON provider.id = provider_id
--LEFT JOIN card_payment_gateway ON card_payment_gateway.id = gateway_transaction.card_payment_gateway_id
--LEFT JOIN card ON card_payment_gateway.card_id = card.id
WHERE refund.subscription_id IS NULL AND gateway_transaction.invoice_item_id IS NULL  AND source_object_name = 'refund'  AND refund.status =20 AND refund.is_void = 'f'and customer.mobile_number = '+'
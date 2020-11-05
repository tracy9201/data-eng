WITH Subscription_cte AS
(
SELECT subscription.id AS subscription_id, subscription.encrypted_ref_id AS k_subscirption_id, subscription.quantity, subscription.unit_name, subscription.remaining_payment, subscription.balance, subscription.discount_percentages, subscription.discount_amts, subscription.coupons, subscription.credits, subscription.payments, subscription.total_installment, subscription.tax, subscription.subtotal, subscription.total, subscription.START_date, subscription.END_date, subscription.end_count, subscription.END_unit, subscription.proration, subscription.auto_renewal, subscription.renewal_count, subscription.name AS subscription_name, subscription.created_at AS subscription_created, subscription.updated_at AS subscription_updated_at, subscription.canceled_at AS subscription_canceled_at, plan.id AS plan_id, plan.encrypted_ref_id AS k_plan_id, customer_id, customer.encrypted_ref_id AS k_customer_id, provider_id, provider.encrypted_ref_id AS k_provider_id, now()
FROM subscription
JOIN plan ON plan_id = plan.id
JOIN customer ON customer.id = customer_id
JOIN provider ON provider.id = provider_id
WHERE subscription.status = 1 -- AND subscription.auto_renewal = 't'
)
, invoice AS
(
SELECT invoice.id AS invoice_id, invoice.plan_id AS invoice_plan, invoice.status AS invoice_status
FROM invoice
)
,subscription_no_auto_renewal AS
(
SELECT subscription_cte.* FROM Subscription_cte
JOIN invoice ON subscription_cte.plan_id = invoice_plan
WHERE invoice_status = 20 AND subscription_cte.auto_renewal = 'f'
)
, main AS
(
SELECT * FROM Subscription_cte WHERE subscription_cte.auto_renewal = 't'
UNION
SELECT * FROM subscription_no_auto_renewal
)

SELECT * FROM main
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33

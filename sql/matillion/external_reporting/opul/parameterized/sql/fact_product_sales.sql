WITH Subscription_all AS
(SELECT
    subscription.id AS subscription_id,
    subscription.encrypted_ref_id AS k_subscription_id,
    subscription.quantity,
    subscription.unit_name,
    subscription.remaining_payment,
    subscription.balance,
    subscription.discount_percentages,
    subscription.discount_amts,
    subscription.coupons,
    subscription.credits,
    subscription.payments,
    subscription.total_installment,
    subscription.tax,
    subscription.subtotal,
    subscription.total,
    subscription.START_date,
    subscription.END_date,
    subscription.end_count,
    subscription.END_unit,
    subscription.proration,
    subscription.auto_renewal,
    subscription.renewal_count,
    subscription.name AS subscription_name,
    subscription.created_at AS subscription_created,
    subscription.updated_at AS subscription_updated_at,
    subscription.canceled_at AS subscription_canceled_at,
    plan.id AS plan_id,
    plan.encrypted_ref_id AS k_plan_id,
    customer_id,
    customer.encrypted_ref_id AS k_customer_id,
    provider_id,
    provider.encrypted_ref_id AS k_provider_id,
    current_timestamp::timestamp as dwh_created_at
FROM
    gaia_opul${environment}.subscription subscription
JOIN
    gaia_opul${environment}.plan plan
        ON plan_id = plan.id
JOIN
    gaia_opul${environment}.customer customer
        ON customer.id = customer_id
JOIN
    gaia_opul${environment}.provider provider
        ON provider.id = provider_id
WHERE
    subscription.status in (-1,0,1,20)
    
),
invoice AS
(SELECT
    invoice.id AS invoice_id,
    invoice.plan_id AS invoice_plan,
    invoice.status AS invoice_status
FROM
    gaia_opul${environment}.invoice invoice
),
subscription_no_auto_renewal AS
(SELECT
    Subscription_all.*      
FROM
    Subscription_all 
JOIN
     invoice
        ON Subscription_all.plan_id = invoice.invoice_plan
WHERE
    invoice_status = 20
    AND auto_renewal = 'f'
),
all_data AS
(
SELECT * FROM Subscription_all
WHERE
auto_renewal = 't'
UNION ALL
SELECT * FROM subscription_no_auto_renewal
),
main AS
(
SELECT
    distinct *
FROM
    all_data
)
SELECT * FROM main
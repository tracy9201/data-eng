WITH credit_data as
(   SELECT
    'credit_'||c.id::varchar AS sales_id,
    c.name AS sales_name,
    c.amount AS sales_amount,
    c.type AS sales_type,
    c.status AS sales_status,
    c.created_at AS sales_created_at,
    c.plan_id,
    CASE
        WHEN c.id IS NOT NULL THEN ''
    END AS transaction_id,
    c.name AS payment_id,
    '0000000000000000'::varchar AS tokenization,
    sub.encrypted_ref_id AS gx_subscription_id ,
    c.created_by AS staff_user_id,
    NULL::text AS device_id,
    NULL::bigint AS gratuity_amount,
    NULL::text AS is_voided
FROM
    gaia.credit c
LEFT JOIN
    gaia.subscription sub
        ON sub.id = c.subscription_id
WHERE
    c.id IS NOT NULL
    AND c.status =1
),
payment_data as
(   SELECT distinct
    'payment_'||p.id::varchar  AS sales_id,
    p.name AS sales_name,
    p.amount AS sales_amount,
    p.type AS sales_type,
    p.status AS sales_status,
    p.created_at AS sales_created_at,
    p.plan_id,
    p.transaction_id,
    CASE
        WHEN p.type ='credit_card' THEN account_number
        ELSE p.name
    END AS payment_id,
    cpg.tokenization,
    sub.encrypted_ref_id AS gx_subscription_id,
    p.created_by AS staff_user_id,
    p.device_id,
    gratuity.amount AS gratuity_amount,
    NULL::text AS is_voided
FROM
    gaia.payment p
LEFT JOIN
    gaia.subscription sub
        ON sub.id = p.subscription_id
LEFT JOIN
    gaia.gratuity gratuity
        ON gratuity.id = p.gratuity_id
LEFT JOIN
-- gateway_transaction gt
 (SELECT distinct payment_id,card_payment_gateway_id
  FROM  gaia.gateway_transaction
  WHERE card_payment_gateway_id IS NOT NULL) gt
        ON gt.payment_id = p.id
LEFT JOIN
    gaia.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia.card card
        ON cpg.card_id = card.id
WHERE
    p.id IS NOT NULL
    AND p.status = 1
),
refund1 as
(    SELECT
    'refund1_'||refund.id::varchar  AS sales_id,
    refund.name AS sales_name,
    refund.amount AS sales_amount,
    refund.type AS sales_type,
    refund.status AS sales_status,
    refund.created_at AS sales_created_at,
    sub.plan_id,
    CASE
        WHEN refund.id IS NOT NULL THEN gt.transaction_id
        else ''
    END AS transaction_id,
    CASE
        WHEN refund.type = 'credit_card' THEN last4
        ELSE refund.reason
    END AS payment_id,
    cpg.tokenization,
    sub.encrypted_ref_id AS gx_subscription_id ,
    refund.created_by AS staff_user_id,
    NULL::text AS device_id,
    gratuity.amount AS gratuity_amount,
    NULL::text AS is_voided
FROM
    gaia.refund refund
LEFT JOIN
    gaia.gratuity gratuity
        ON gratuity.id = refund.gratuity_id
LEFT JOIN
    gaia.subscription sub
        ON subscription_id = sub.id
LEFT JOIN
    gaia.gateway_transaction gt
        ON refund.gateway_transaction_id = gt.id
LEFT JOIN
    gaia.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia.card card
        ON cpg.card_id = card.id
WHERE
    subscription_id IS NOT NULL
    AND refund.status =20
    AND refund.is_void = 'f'
),
refund3 as
(   SELECT
    'refund3_'||refund.id::varchar  AS sales_id,
    refund.name AS sales_name,
    refund.amount AS sales_amount,
    refund.type AS sales_type,
    refund.status AS sales_status,
    refund.created_at AS sales_created_at,
    payment.plan_id,
    gt.transaction_id,
    CASE
        WHEN refund.type = 'credit_card' THEN last4
        ELSE refund.reason
    END AS payment_id,
    cpg.tokenization,
    sub.encrypted_ref_id AS gx_subscription_id,
    refund.created_by AS staff_user_id ,
    NULL::text AS device_id,
    gratuity.amount AS gratuity_amount,
    NULL::text AS is_voided
FROM
    gaia.refund refund
LEFT JOIN
    gaia.gratuity gratuity
        ON gratuity.id = refund.gratuity_id
LEFT JOIN
    gaia.gateway_transaction gt
        ON gateway_transaction_id = gt.id
LEFT JOIN
    gaia.payment  payment
        ON gt.payment_id = payment.id
LEFT JOIN
    gaia.subscription sub
        ON payment.subscription_id = sub.id
LEFT JOIN
    gaia.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia.card
        ON cpg.card_id = card.id
WHERE
    refund.subscription_id IS NULL
    AND gt.invoice_item_id IS NULL
    AND source_object_name = 'refund'
    AND refund.status =20
    AND refund.is_void = 'f'
),
tran as
(
    SELECT
    'tran_'||gt.id::varchar  AS sales_id,
    gt.name AS sales_name,
    gt.amount AS sales_amount,
    gt.type AS sales_type,
    gt.status AS sales_status,
    gt.created_at AS sales_created_at,
    invoice.plan_id,
    transaction_id,
    last4 AS payment_id ,
    cpg.tokenization,
    sub.encrypted_ref_id AS gx_subscription_id ,
    NULL::text AS staff_user_id,
    NULL::text AS device_id,
    gt.gratuity_amount,
    NULL::text AS is_voided
FROM
    gaia.gateway_transaction gt
LEFT JOIN
    gaia.invoice invoice
        ON invoice_id = invoice.id
LEFT JOIN
    gaia.invoice_item ivi
        ON invoice_item_id = ivi.id
LEFT JOIN
    gaia.subscription sub
        ON sub.id = ivi.subscription_id
LEFT JOIN
    gaia.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia.card
        ON cpg.card_id = card.id
WHERE
    source_object_name  = 'card_payment_gateway'
    AND gt.status = 20
    AND gt.payment_id IS NULL
    AND gt.is_voided = 'f'
),
hintmd_voids as
(
    SELECT
        CASE
            WHEN refund.id IS NOT NULL THEN gt.transaction_id
        END AS transaction_id
    FROM
        gaia.refund refund
    LEFT JOIN
        gaia.gateway_transaction gt
            ON refund.gateway_transaction_id = gt.id
    WHERE
        refund.status =20
        AND refund.is_void = 't'
),
void1 as
(    SELECT
    'void1_'||settlement.id::varchar AS sales_id,
    gt.name AS sales_name,
    settlement.tendered *100 AS sales_amount,
    gt.type AS sales_type,
    settlement.status AS sales_status,
    settlement.authd_date AS sales_created_at,
    invoice.plan_id,
    gt.transaction_id,
    settlement.last_four AS payment_id,
    token AS tokenization,
    sub.encrypted_ref_id AS gx_subscription_id ,
    NULL::text AS staff_user_id,
    NULL::text AS device_id,
    gt.gratuity_amount AS gratuity_amount,
    CASE WHEN gt.is_voided = 't' then 't'::varchar 
         WHEN gt.is_voided = 'f' then 'f'::varchar else NULL::VARCHAR END AS is_voided
FROM
    gaia.settlement settlement
LEFT JOIN
    gaia.gateway_transaction gt
        ON gt.id = gateway_transaction_id
LEFT JOIN
    gaia.invoice invoice
        ON gt.invoice_id = invoice.id
LEFT JOIN
    gaia.invoice_item ivi
        ON ivi.id = gt.invoice_item_id
LEFT JOIN
    gaia.subscription sub
        ON sub.id = ivi.subscription_id
LEFT JOIN
    hintmd_voids h_void
        on gt.transaction_id  = h_void.transaction_id
WHERE
    settlement.settlement_status = 'Voided'
    AND gt.invoice_id IS NOT NULL
    AND gt.is_voided = 'f'
    AND h_void.transaction_id IS NULL
),
void2 as
(
    SELECT
    'void2_'||settlement.id::varchar AS sales_id,
    gt.name AS sales_name,
    settlement.tendered*100 AS sales_amount,
    gt.type AS sales_type,
    settlement.status AS sales_status,
    settlement.authd_date AS sales_created_at,
    payment.plan_id,
    gt.transaction_id,
    settlement.last_four AS payment_id,
    token AS tokenization,
    sub.encrypted_ref_id AS gx_subscription_id ,
    NULL::text AS staff_user_id,
    NULL::text AS device_id,
    gt.gratuity_amount AS gratuity_amount,
    CASE WHEN gt.is_voided = 't' then 't'::varchar 
         WHEN gt.is_voided = 'f' then 'f'::varchar else NULL::VARCHAR END AS is_voided
FROM
    gaia.settlement settlement
LEFT JOIN
    gaia.gateway_transaction gt
        ON gt.id = gateway_transaction_id
LEFT JOIN
    gaia.payment
        ON  payment_id = payment.id
LEFT JOIN
    gaia.subscription sub
        ON sub.id = payment.subscription_id
LEFT JOIN
    hintmd_voids h_void
        on gt.transaction_id  = h_void.transaction_id
WHERE
    settlement.settlement_status = 'Voided'
    AND invoice_id IS NULL
    AND gt.is_voided = 'f'
    AND h_void.transaction_id IS NULL
),
void3 as
(    SELECT
    'void3_'||refund.id::varchar AS sales_id,
    refund.name AS sales_name,
    refund.amount AS sales_amount,
    refund.type AS sales_type,
    refund.status AS sales_status,
    refund.created_at AS sales_created_at,
    sub.plan_id,
    CASE
        WHEN refund.id IS NOT NULL THEN gt.transaction_id
        else ''
    END AS transaction_id,
    refund.reason AS payment_id,
    cpg.tokenization,
    sub.encrypted_ref_id AS gx_subscription_id ,
    refund.created_by AS staff_user_id,
    NULL::text AS device_id,
    gratuity.amount AS gratuity_amount,
    CASE WHEN refund.is_void = 't' then 't'::varchar 
         WHEN refund.is_void = 'f' then 'f'::varchar else NULL::VARCHAR  END AS is_voided
FROM
    gaia.refund refund
LEFT JOIN
    gaia.gratuity gratuity
        ON gratuity.id = refund.gratuity_id
LEFT JOIN
    gaia.gateway_transaction gt
        ON refund.gateway_transaction_id = gt.id
LEFT JOIN
    gaia.invoice_item ivi
        ON gt.invoice_item_id = ivi.id
LEFT JOIN
    gaia.subscription sub
        ON ivi.subscription_id = sub.id
LEFT JOIN
    gaia.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
WHERE
    refund.status =20
    AND refund.is_void = 't'
    AND gt.payment_id IS NULL
),
void4 as
(   SELECT
    'void4_'||refund.id::varchar AS sales_id,
    refund.name AS sales_name,
    refund.amount AS sales_amount,
    refund.type AS sales_type,
    refund.status AS sales_status,
    refund.created_at AS sales_created_at,
    payment.plan_id,
    CASE
        WHEN refund.id IS NOT NULL THEN gt.transaction_id
        else ''
    END AS transaction_id,
    refund.reason AS payment_id,
    cpg.tokenization,
    sub.encrypted_ref_id AS gx_subscription_id ,
    refund.created_by AS staff_user_id,
    NULL::text AS device_id,
    gratuity.amount AS gratuity_amount,
    CASE WHEN refund.is_void = 't' then 't'::varchar 
         WHEN refund.is_void = 'f' then 'f'::varchar else NULL::VARCHAR END AS is_voided
FROM
    gaia.refund refund
LEFT JOIN
    gaia.gratuity gratuity
        ON gratuity.id = refund.gratuity_id
LEFT JOIN
    gaia.subscription sub
        ON refund.subscription_id = sub.id
LEFT JOIN
    gaia.gateway_transaction gt
        ON refund.gateway_transaction_id = gt.id
LEFT JOIN
    gaia.payment payment
        ON payment.id = payment_id
LEFT JOIN
    gaia.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
WHERE
    refund.status =20
    AND refund.is_void = 't'
    AND gt.payment_id IS NOT NULL
),
all_data AS
(
    SELECT * FROM credit_data
    UNION ALL
    SELECT * FROM payment_data
    UNION ALL
    SELECT * FROM refund1
    UNION ALL
    SELECT * FROM refund3
    UNION ALL
    SELECT * FROM tran
    UNION ALL
    SELECT * FROM void1
    UNION ALL
    SELECT * FROM void2
    UNION ALL
    SELECT * FROM void3
    UNION ALL
    SELECT * FROM void4
),
main as
(
    SELECT
    a.sales_id,
    a.sales_name,
    a.sales_amount,
    a.sales_type,
    a.sales_status,
    a.sales_created_at,
    customer.encrypted_ref_id AS gx_customer_id,
    provider.encrypted_ref_id AS gx_provider_id,
    a.transaction_id,
    a.payment_id,
    a.tokenization,
    a.gx_subscription_id ,
    a.staff_user_id,
    a.device_id,
    a.gratuity_amount,
    a.is_voided
    FROM all_data a
    LEFT JOIN
    gaia.plan plan
        ON a.plan_id = plan.id
    LEFT JOIN
    gaia.customer customer
        ON customer.id = plan.customer_id
    LEFT JOIN
    gaia.provider provider
        ON provider.id = provider_id
)
SELECT * FROM main
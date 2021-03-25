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
    NULL::varchar as card_brand,
    sub.encrypted_ref_id AS gx_subscription_id ,
    c.created_by AS staff_user_id,
    NULL::text AS device_id,
    NULL::bigint AS gratuity_amount,
    NULL::text AS is_voided,
    NULL::text as card_holder_name,
    null as invoice_id,
    c.created_at,
    c.updated_at
FROM
    gaia_opul_${environment}.credit c
LEFT JOIN
    gaia_opul_${environment}.subscription sub
        ON sub.id = c.subscription_id
WHERE
    c.id IS NOT NULL
    AND c.status  in (1,-3)
),
payment as
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
    coalesce(card.brand,p.card_brand) as card_brand,
    sub.encrypted_ref_id AS gx_subscription_id,
    p.created_by AS staff_user_id,
    p.device_id,
    gratuity.amount AS gratuity_amount,
    null AS is_voided,
    card_holder_name,
    null as invoice_id,
    gt.payment_id as gt_payment_id,
    p.created_at,
    p.updated_at
FROM
    gaia_opul_${environment}.payment p
LEFT JOIN
    gaia_opul_${environment}.subscription sub
        ON sub.id = p.subscription_id
LEFT JOIN
    gaia_opul_${environment}.gratuity gratuity
        ON gratuity.id = p.gratuity_id
LEFT JOIN
 (SELECT distinct 
  gt.payment_id, 
  card_payment_gateway_id
FROM  gaia_opul_${environment}.gateway_transaction gt
WHERE 
  card_payment_gateway_id IS NOT NULL and card_payment_gateway_id != 0
  and gt.payment_id is not null) gt
        ON gt.payment_id = p.id
LEFT JOIN
    gaia_opul_${environment}.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul_${environment}.card card
        ON cpg.card_id = card.id
WHERE
    p.id IS NOT NULL
    AND p.status  in (1,-3)
),
payment_void as 
( SELECT 
    distinct 
    gt.payment_id, 
    CASE WHEN gt.is_voided = 't' then 't'::varchar END AS is_voided
  FROM  
    gaia_opul_${environment}.gateway_transaction gt
  WHERE 
    card_payment_gateway_id IS NOT NULL 
    and card_payment_gateway_id != 0
    and gt.payment_id is not null 
    and is_voided = 't'
),
payment_data as (
  SELECT
    sales_id,
    sales_name,
    sales_amount,
    sales_type,
    sales_status,
    sales_created_at,
    plan_id,
    transaction_id,
    payment.payment_id,
    tokenization,
    card_brand,
    gx_subscription_id,
    staff_user_id,
    device_id,
    gratuity_amount,
    payment_void.is_voided,
    card_holder_name,
    invoice_id,
    created_at,
    updated_at
  from 
    payment
  left join 
    payment_void
    on payment.gt_payment_id = payment_void.payment_id
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
    coalesce(card.brand,refund.card_brand) as card_brand,
    sub.encrypted_ref_id AS gx_subscription_id ,
    refund.created_by AS staff_user_id,
    NULL::text AS device_id,
    gratuity.amount AS gratuity_amount,
    NULL::text AS is_voided,
    card_holder_name,
    refund.invoice_id::varchar as invoice_id,
    refund.created_at,
    refund.updated_at
FROM
    gaia_opul_${environment}.refund refund
LEFT JOIN
    gaia_opul_${environment}.gratuity gratuity
        ON gratuity.id = refund.gratuity_id
LEFT JOIN
    gaia_opul_${environment}.subscription sub
        ON subscription_id = sub.id
LEFT JOIN
    gaia_opul_${environment}.gateway_transaction gt
        ON refund.gateway_transaction_id = gt.id
LEFT JOIN
    gaia_opul_${environment}.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul_${environment}.card card
        ON cpg.card_id = card.id
WHERE
    subscription_id IS NOT NULL
    AND refund.status  in (20,-3)
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
    coalesce(card.brand,refund.card_brand) as card_brand,
    sub.encrypted_ref_id AS gx_subscription_id,
    refund.created_by AS staff_user_id ,
    NULL::text AS device_id,
    gratuity.amount AS gratuity_amount,
    NULL::text AS is_voided,
    card_holder_name,
    refund.invoice_id::varchar as invoice_id,
    refund.created_at,
    refund.updated_at
FROM
    gaia_opul_${environment}.refund refund
LEFT JOIN
    gaia_opul_${environment}.gratuity gratuity
        ON gratuity.id = refund.gratuity_id
LEFT JOIN
    gaia_opul_${environment}.gateway_transaction gt
        ON gateway_transaction_id = gt.id
LEFT JOIN
    gaia_opul_${environment}.payment  payment
        ON gt.payment_id = payment.id
LEFT JOIN
    gaia_opul_${environment}.subscription sub
        ON payment.subscription_id = sub.id
LEFT JOIN
    gaia_opul_${environment}.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul_${environment}.card
        ON cpg.card_id = card.id
WHERE
    refund.subscription_id IS NULL
    AND gt.invoice_item_id IS NULL
    AND source_object_name = 'refund'
    AND refund.status  in (20,-3)
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
    card.brand as card_brand,
    sub.encrypted_ref_id AS gx_subscription_id ,
    NULL::text AS staff_user_id,
    NULL::text AS device_id,
    gt.gratuity_amount,
    NULL::text AS is_voided,
    NULL::text as card_holder_name,
    gt.invoice_id::varchar as invoice_id,
    gt.created_at,
    gt.updated_at
FROM
    gaia_opul_${environment}.gateway_transaction gt
LEFT JOIN
    gaia_opul_${environment}.invoice invoice
        ON invoice_id = invoice.id
LEFT JOIN
    gaia_opul_${environment}.invoice_item ivi
        ON invoice_item_id = ivi.id
LEFT JOIN
    gaia_opul_${environment}.subscription sub
        ON sub.id = ivi.subscription_id
LEFT JOIN
    gaia_opul_${environment}.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul_${environment}.card
        ON cpg.card_id = card.id
WHERE
    source_object_name  = 'card_payment_gateway'
    AND gt.status  in (20,-3)
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
        gaia_opul_${environment}.refund refund
    LEFT JOIN
        gaia_opul_${environment}.gateway_transaction gt
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
    card.brand as card_brand,
    sub.encrypted_ref_id AS gx_subscription_id ,
    NULL::text AS staff_user_id,
    NULL::text AS device_id,
    gt.gratuity_amount AS gratuity_amount,
    CASE WHEN gt.is_voided = 't' then 't'::varchar 
         WHEN gt.is_voided = 'f' then 'f'::varchar else NULL::VARCHAR END AS is_voided,
    NULL::text as card_holder_name,
    invoice.id::varchar as invoice_id,
    settlement.created_at,
    settlement.updated_at
FROM
    gaia_opul_${environment}.settlement settlement
LEFT JOIN
    gaia_opul_${environment}.gateway_transaction gt
        ON gt.id = gateway_transaction_id
LEFT JOIN
    gaia_opul_${environment}.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul_${environment}.card
        ON cpg.card_id = card.id
LEFT JOIN
    gaia_opul_${environment}.invoice invoice
        ON gt.invoice_id = invoice.id
LEFT JOIN
    gaia_opul_${environment}.invoice_item ivi
        ON ivi.id = gt.invoice_item_id
LEFT JOIN
    gaia_opul_${environment}.subscription sub
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
    card.brand as card_brand,
    sub.encrypted_ref_id AS gx_subscription_id ,
    NULL::text AS staff_user_id,
    NULL::text AS device_id,
    gt.gratuity_amount AS gratuity_amount,
    CASE WHEN gt.is_voided = 't' then 't'::varchar 
         WHEN gt.is_voided = 'f' then 'f'::varchar else NULL::VARCHAR END AS is_voided,
    NULL::text as card_holder_name,
    gt.invoice_id::varchar as invoice_id,
    settlement.created_at,
    settlement.updated_at
FROM
    gaia_opul_${environment}.settlement settlement
LEFT JOIN
    gaia_opul_${environment}.gateway_transaction gt
        ON gt.id = gateway_transaction_id
LEFT JOIN
    gaia_opul_${environment}.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul_${environment}.card
        ON cpg.card_id = card.id
LEFT JOIN
    gaia_opul_${environment}.payment
        ON  payment_id = payment.id
LEFT JOIN
    gaia_opul_${environment}.subscription sub
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
    coalesce(card.brand,refund.card_brand) as card_brand,
    sub.encrypted_ref_id AS gx_subscription_id ,
    refund.created_by AS staff_user_id,
    NULL::text AS device_id,
    gratuity.amount AS gratuity_amount,
    CASE WHEN refund.is_void = 't' then 't'::varchar 
         WHEN refund.is_void = 'f' then 'f'::varchar else NULL::VARCHAR  END AS is_voided,
    card_holder_name,
    refund.invoice_id::varchar as invoice_id,
    refund.created_at,
    refund.updated_at
FROM
    gaia_opul_${environment}.refund refund
LEFT JOIN
    gaia_opul_${environment}.gratuity gratuity
        ON gratuity.id = refund.gratuity_id
LEFT JOIN
    gaia_opul_${environment}.gateway_transaction gt
        ON refund.gateway_transaction_id = gt.id
LEFT JOIN
    gaia_opul_${environment}.invoice_item ivi
        ON gt.invoice_item_id = ivi.id
LEFT JOIN
    gaia_opul_${environment}.subscription sub
        ON ivi.subscription_id = sub.id
LEFT JOIN
    gaia_opul_${environment}.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul_${environment}.card
        ON cpg.card_id = card.id
WHERE
    refund.status  in (20,-3)
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
    coalesce(card.brand,refund.card_brand) as card_brand,
    sub.encrypted_ref_id AS gx_subscription_id ,
    refund.created_by AS staff_user_id,
    payment.device_id AS device_id,
    gratuity.amount AS gratuity_amount,
    CASE WHEN refund.is_void = 't' then 't'::varchar 
         WHEN refund.is_void = 'f' then 'f'::varchar else NULL::VARCHAR END AS is_voided,
    card_holder_name,
    refund.invoice_id::varchar as invoice_id,
    refund.created_at,
    refund.updated_at
FROM
    gaia_opul_${environment}.refund refund
LEFT JOIN
    gaia_opul_${environment}.gratuity gratuity
        ON gratuity.id = refund.gratuity_id
LEFT JOIN
    gaia_opul_${environment}.subscription sub
        ON refund.subscription_id = sub.id
LEFT JOIN
    gaia_opul_${environment}.gateway_transaction gt
        ON refund.gateway_transaction_id = gt.id
LEFT JOIN
    gaia_opul_${environment}.payment payment
        ON payment.id = payment_id
LEFT JOIN
    gaia_opul_${environment}.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul_${environment}.card
        ON cpg.card_id = card.id
WHERE
    refund.status in (20,-3)
    AND refund.is_void = 't'
    AND gt.payment_id IS NOT NULL
),
invoice_data as (
  select distinct 
    inv.id::varchar as inv_id,
    inv.status as inv_status,
    case 
      when gt.source_object_name = 'payment' then 'payment_'||gt.source_object_id::varchar
      when gt.source_object_name = 'credit' then 'credit_'||gt.source_object_id::varchar
      else null
      end AS sales_id
  from gaia_opul_${environment}.invoice inv
  left join
    gaia_opul_${environment}.gateway_transaction gt
      on inv.id = gt.invoice_id
  where inv.status = -3 and source_object_name in ('payment', 'credit')
),
invoice_data2 as (
  select distinct 
    inv.id::varchar as inv_id,
    inv.status as inv_status
  from gaia_opul_${environment}.invoice inv
  left join
    gaia_opul_${environment}.gateway_transaction gt
      on inv.id = gt.invoice_id
  where inv.status = -3 and source_object_name in ('payment', 'credit')
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
    case when trim(transaction_id) = '' or transaction_id is null then 'N/A' else transaction_id end as transaction_id,
    a.payment_id,
    a.tokenization,
    CASE WHEN a.card_brand in ('A','AMEX') then 'Amex'
         WHEN a.card_brand like 'M' then 'Mastercard'
         WHEN a.card_brand like 'D' then 'Discover'
         WHEN a.card_brand in ('V','VISA') then 'Visa'
         WHEN a.card_brand like 'N' then 'Other Credit Card'
         ELSE a.card_brand
         END as card_brand,
    substring(a.tokenization,2,2) as token_substr,
    a.gx_subscription_id ,
    a.staff_user_id,
    a.device_id,
    a.gratuity_amount,
    a.is_voided,
    card_holder_name,
    invoice_id,
    inv_id,
    inv_status,
    a.created_at,
    a.updated_at,
    current_timestamp::timestamp as dwh_created_at
    FROM all_data a
    LEFT JOIN
    gaia_opul_${environment}.plan plan
        ON a.plan_id = plan.id
    LEFT JOIN
    gaia_opul_${environment}.customer customer
        ON customer.id = plan.customer_id
    LEFT JOIN
    gaia_opul_${environment}.provider provider
        ON provider.id = provider_id
    LEFT JOIN
    invoice_data inv
        ON a.sales_id = inv.sales_id
    where a.sales_id like 'payment%' or a.sales_id like 'credit%' or  a.sales_id like 'tran%' or  a.sales_id like 'void1%' or  a.sales_id like 'void2%'
    
    UNION ALL
    
    SELECT
    a.sales_id,
    a.sales_name,
    a.sales_amount,
    a.sales_type,
    a.sales_status,
    a.sales_created_at,
    customer.encrypted_ref_id AS gx_customer_id,
    provider.encrypted_ref_id AS gx_provider_id,
    case when trim(transaction_id) = '' or transaction_id is null then 'N/A' else transaction_id end as transaction_id,
    a.payment_id,
    a.tokenization,
    CASE WHEN a.card_brand in ('A','AMEX') then 'Amex'
        WHEN a.card_brand like 'M' then 'Mastercard'
        WHEN a.card_brand like 'D' then 'Discover'
        WHEN a.card_brand in ('V','VISA') then 'Visa'
        WHEN a.card_brand like 'N' then 'Other Credit Card'
        ELSE a.card_brand
        END as card_brand,
    substring(a.tokenization,2,2) as token_substr,
    a.gx_subscription_id ,
    a.staff_user_id,
    a.device_id,
    a.gratuity_amount,
    a.is_voided,
    card_holder_name,
    invoice_id,
    inv_id as inv_id,
    inv_status as inv_status,
    a.created_at,
    a.updated_at,
    current_timestamp::timestamp as dwh_created_at
    FROM all_data a
    LEFT JOIN
    gaia_opul_${environment}.plan plan
        ON a.plan_id = plan.id
    LEFT JOIN
    gaia_opul_${environment}.customer customer
        ON customer.id = plan.customer_id
    LEFT JOIN
    gaia_opul_${environment}.provider provider
        ON provider.id = provider_id
    LEFT JOIN
    invoice_data2 inv2
        ON a.invoice_id = inv2.inv_id
    where a.sales_id like 'refund1%' or a.sales_id like 'refund3%' or a.sales_id like 'void3%' or  a.sales_id like 'void4%'
)
SELECT * FROM main
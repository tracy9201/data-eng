--------------------- payment_summary -----------------------
WITH credit AS
(
    SELECT
            'credit_'||cast(credit.id AS text) AS sales_id,
            credit.name AS sales_name,
            credit.amount AS sales_amount,
            credit.type AS sales_type,
            credit.status AS sales_status,
            credit.created_at AS sales_created_at,
            customer.encrypted_ref_id AS gx_customer_id,
            provider.encrypted_ref_id AS gx_provider_id,
            CASE
                WHEN credit.id IS NOT NULL THEN '':: VARCHAR
            END AS transaction_id,
            credit.name AS payment_id,
            '0000000000000000':: VARCHAR AS tokenization,
            subscription.encrypted_ref_id AS gx_subscription_id,
            credit.created_by AS staff_user_id,
            NULL::VARCHAR AS device_id,
            NULL::DECIMAL(10,9) AS gratuity_amount,
            NULL::VARCHAR AS is_voided
    FROM
            credit
        LEFT JOIN
            subscription
                ON subscription.id = credit.subscription_id
        LEFT JOIN
            plan
                ON credit.plan_id = plan.id
        LEFT JOIN
            customer
                ON customer.id = plan.customer_id
        LEFT JOIN
            provider
                ON provider.id = provider_id
        WHERE
            credit.id IS NOT NULL
            AND credit.status =1
)
, refund_subs_not_null AS
(
    SELECT
            'refund_subs_not_null_'||cast(refund.id AS text) AS sales_id,
            refund.name AS sales_name,
            refund.amount AS sales_amount,
            refund.type AS sales_type,
            refund.status AS sales_status,
            refund.created_at AS sales_created_at,
            customer.encrypted_ref_id AS gx_customer_id,
            provider.encrypted_ref_id AS gx_provider_id,
            CASE
                WHEN refund.id IS NOT NULL THEN ''::VARCHAR
            END AS transaction_id,
            CASE
                WHEN refund.type = 'credit_card' THEN last4
                ELSE refund.reason
            END AS payment_id,
            card_payment_gateway.tokenization::VARCHAR ,
            subscription.encrypted_ref_id AS gx_subscription_id,
            refund.created_by AS staff_user_id,
            NULL::VARCHAR AS device_id,
            gratuity.amount::DECIMAL(10,9) AS gratuity_amount,
            NULL::VARCHAR AS is_voided
    FROM
            refund
        LEFT JOIN
            gratuity
                ON gratuity.id = refund.gratuity_id
        LEFT JOIN
            subscription
                ON subscription_id = subscription.id
        LEFT JOIN
            plan
                ON subscription.plan_id = plan.id
        LEFT JOIN
            customer
                ON customer.id = plan.customer_id
        LEFT JOIN
            provider
                ON provider.id = provider_id
        LEFT JOIN
            gateway_transaction
                ON refund.gateway_transaction_id = gateway_transaction.id
        LEFT JOIN
            card_payment_gateway
                ON card_payment_gateway.id = gateway_transaction.card_payment_gateway_id
        LEFT JOIN
            card
                ON card_payment_gateway.card_id = card.id
        WHERE
            subscription_id IS NOT NULL
            AND refund.status =20
            AND refund.is_void = 'f'
)
, tran AS
(
    SELECT
            'tran_'||cast(gateway_transaction.id AS text) AS sales_id,
            gateway_transaction.name AS sales_name,
            gateway_transaction.amount AS sales_amount,
            gateway_transaction.type AS sales_type,
            gateway_transaction.status AS sales_status,
            gateway_transaction.created_at AS sales_created_at,
            customer.encrypted_ref_id AS gx_customer_id,
            provider.encrypted_ref_id AS gx_provider_id,
            transaction_id::VARCHAR ,
            last4 AS payment_id ,
            card_payment_gateway.tokenization:: VARCHAR ,
            subscription.encrypted_ref_id AS gx_subscription_id,
            NULL::VARCHAR AS staff_user_id,
            NULL::VARCHAR AS device_id,
            gateway_transaction.gratuity_amount::decimal(10,9),
            NULL::VARCHAR  AS is_voided
        FROM
            gateway_transaction
        LEFT JOIN
            invoice
                ON invoice_id = invoice.id
        LEFT JOIN
            invoice_item
                ON invoice_item_id = invoice_item.id
        LEFT JOIN
            subscription
                ON subscription.id = invoice_item.subscription_id
        LEFT JOIN
            plan
                ON invoice.plan_id = plan.id
        LEFT JOIN
            customer
                ON customer.id = plan.customer_id
        LEFT JOIN
            provider
                ON provider.id = provider_id
        LEFT JOIN
            card_payment_gateway
                ON card_payment_gateway.id = gateway_transaction.card_payment_gateway_id
        LEFT JOIN
            card
                ON card_payment_gateway.card_id = card.id
        WHERE
            source_object_name  = 'card_payment_gateway'
            AND gateway_transaction.status = 20
            AND gateway_transaction.payment_id IS NULL
            AND gateway_transaction.is_voided = 'f'
)
, void_cc_inv_not_null AS
(
    SELECT
            'void_cc_inv_not_null_'||cast(settlement.id AS text) AS sales_id,
            gateway_transaction.name AS sales_name,
            settlement.tendered * 100 AS sales_amount,
            gateway_transaction.type AS sales_type,
            settlement.status AS sales_status,
            settlement.authd_date AS sales_created_at,
            customer.encrypted_ref_id AS gx_customer_id,
            provider.encrypted_ref_id AS gx_provider_id,
            gateway_transaction.transaction_id::VARCHAR ,
            settlement.last_four AS payment_id,
            card_payment_gateway.tokenization:: VARCHAR AS tokenization,
            subscription.encrypted_ref_id AS gx_subscription_id,
            NULL:: VARCHAR AS staff_user_id,
            NULL::VARCHAR AS device_id,
            gateway_transaction.gratuity_amount:: DECIMAL(10,9) AS gratuity_amount,
            't'::VARCHAR AS is_voided
    FROM
            settlement
        LEFT JOIN
            gateway_transaction
                ON gateway_transaction.id = gateway_transaction_id
        LEFT JOIN
            invoice
                ON gateway_transaction.invoice_id = invoice.id
        LEFT JOIN
            invoice_item
                ON invoice_item.id = gateway_transaction.invoice_item_id
        LEFT JOIN
            subscription
                ON subscription.id = invoice_item.subscription_id
        LEFT JOIN
            plan
                ON invoice.plan_id = plan.id
        LEFT JOIN
            customer
                ON customer_id = customer.id
        LEFT JOIN
            provider
                ON provider_id = provider.id
        LEFT JOIN
            card_payment_gateway
                ON card_payment_gateway.id = gateway_transaction.card_payment_gateway_id
        WHERE
            settlement.settlement_status = 'Voided'
            AND gateway_transaction.invoice_id IS NOT NULL
            AND gateway_transaction.is_voided = 'f'
)
, void_cc_inv_null AS
(
    SELECT
            'void_cc_inv_null_'||cast(settlement.id AS text) AS sales_id,
            gateway_transaction.name AS sales_name,
            settlement.tendered * 100 AS sales_amount,
            gateway_transaction.type AS sales_type,
            settlement.status AS sales_status,
            settlement.authd_date AS sales_created_at,
            customer.encrypted_ref_id AS gx_customer_id,
            provider.encrypted_ref_id AS gx_provider_id,
            gateway_transaction.transaction_id:: VARCHAR,
            settlement.last_four AS payment_id,
            card_payment_gateway.tokenization:: VARCHAR AS tokenization,
            subscription.encrypted_ref_id AS gx_subscription_id,
            NULL::VARCHAR AS staff_user_id,
            NULL:: VARCHAR AS device_id,
            gateway_transaction.gratuity_amount:: DECIMAL(10,9) AS gratuity_amount,
            't':: VARCHAR AS is_voided
    FROM
            settlement
        LEFT JOIN
            gateway_transaction
                ON gateway_transaction.id = gateway_transaction_id
        LEFT JOIN
            payment
                ON  payment_id = payment.id
        LEFT JOIN
            subscription
                ON subscription.id = payment.subscription_id
        LEFT JOIN
            plan
                ON payment.plan_id = plan.id
        LEFT JOIN
            customer
                ON customer_id = customer.id
        LEFT JOIN
            provider
                ON provider_id = provider.id
        LEFT JOIN
            card_payment_gateway
                ON card_payment_gateway.id = gateway_transaction.card_payment_gateway_id
        WHERE
            settlement.settlement_status = 'Voided'
            AND invoice_id IS NULL
            AND gateway_transaction.is_voided = 'f'
)
, void_hint_payment_null AS
(
    SELECT
            'void_hint_payment_null_'||cast(refund.id AS text) AS sales_id,
            refund.name AS sales_name,
            refund.amount AS sales_amount,
            refund.type AS sales_type,
            refund.status AS sales_status,
            refund.created_at AS sales_created_at,
            customer.encrypted_ref_id AS gx_customer_id,
            provider.encrypted_ref_id AS gx_provider_id,
            CASE
                WHEN refund.id IS NOT NULL THEN '':: VARCHAR
            END AS transaction_id,
            refund.reason AS payment_id,
            card_payment_gateway.tokenization:: VARCHAR AS tokenization,
            subscription.encrypted_ref_id AS gx_subscription_id,
            refund.created_by AS staff_user_id,
            NULL:: VARCHAR AS device_id,
            gratuity.amount:: DECIMAL(10,9) AS gratuity_amount,
            refund.is_void::VARCHAR AS is_voided
    FROM
            refund
        LEFT JOIN
            gratuity
                ON gratuity.id = refund.gratuity_id
        LEFT JOIN
            gateway_transaction
                ON refund.gateway_transaction_id = gateway_transaction.id
        LEFT JOIN
            invoice_item
                ON gateway_transaction.invoice_item_id = invoice_item.id
        LEFT JOIN
            subscription
                ON invoice_item.subscription_id = subscription.id
        LEFT JOIN
            plan
                ON subscription.plan_id = plan.id
        LEFT JOIN
            customer
                ON customer.id = plan.customer_id
        LEFT JOIN
            provider
                ON provider.id = provider_id
        LEFT JOIN
            card_payment_gateway
                ON card_payment_gateway.id = gateway_transaction.card_payment_gateway_id
        WHERE
            refund.status =20
            AND refund.is_void = 't'
            AND gateway_transaction.payment_id IS NULL
)
, void_hint_payment_not_null AS
(
  SELECT
          'void_hint_payment_not_null_'||cast(refund.id AS text) AS sales_id,
          refund.name AS sales_name,
          refund.amount AS sales_amount,
          refund.type AS sales_type,
          refund.status AS sales_status,
          refund.created_at AS sales_created_at,
          customer.encrypted_ref_id AS gx_customer_id,
          provider.encrypted_ref_id AS gx_provider_id,
          CASE WHEN refund.id IS NOT NULL THEN '':: VARCHAR END AS transaction_id,
          refund.reason AS payment_id,
          NULL:: VARCHAR AS tokenization,
          subscription.encrypted_ref_id AS gx_subscription_id,
          refund.created_by AS staff_user_id,
          NULL:: VARCHAR AS device_id,
          gratuity.amount:: DECIMAL(10,9) AS gratuity_amount,
          refund.is_void::VARCHAR AS is_voided
       FROM refund
       LEFT JOIN
           gratuity
               ON gratuity.id = refund.gratuity_id
       LEFT JOIN
           subscription
               ON refund.subscription_id = subscription.id
       LEFT JOIN
           gateway_transaction
               ON refund.gateway_transaction_id = gateway_transaction.id
       LEFT JOIN
           payment
               ON payment.id = payment_id
       LEFT JOIN
           plan
               ON payment.plan_id = plan.id
       LEFT JOIN
           customer
               ON customer.id = plan.customer_id
       LEFT JOIN
           provider
               ON provider.id = provider_id
       WHERE
           refund.status =20
           AND refund.is_void = 't'
           AND gateway_transaction.payment_id IS NOT NULL
)
, payment AS
(
    SELECT
            'payment_'||cast(payment.id AS text) AS sales_id,
            payment.name AS sales_name,
            payment.amount AS sales_amount,
            payment.type AS sales_type,
            payment.status AS sales_status,
            payment.created_at AS sales_created_at,
            customer.encrypted_ref_id AS gx_customer_id,
            provider.encrypted_ref_id AS gx_provider_id,
            payment.transaction_id:: VARCHAR,
            CASE
                WHEN payment.type ='credit_card' THEN account_number
                ELSE payment.name
            END AS payment_id,
            card_payment_gateway.tokenization:: VARCHAR ,
            subscription.encrypted_ref_id AS gx_subscription_id,
            payment.created_by AS staff_user_id,
            payment.device_id:: VARCHAR,
            gratuity.amount:: DECIMAL(10,9) AS gratuity_amount,
            NULL:: VARCHAR AS is_voided
    FROM
            payment
        LEFT JOIN
            subscription
                ON subscription.id = payment.subscription_id
        LEFT JOIN
            gratuity
                ON gratuity.id = payment.gratuity_id
        LEFT JOIN
            plan
                ON payment.plan_id = plan.id
        LEFT JOIN
            customer
                ON customer.id = customer_id
        LEFT JOIN
            provider
                ON provider.id = provider_id
        LEFT JOIN
            gateway_transaction
                ON gateway_transaction.payment_id = payment.id
        LEFT JOIN
            card_payment_gateway
                ON card_payment_gateway.id = gateway_transaction.card_payment_gateway_id
        LEFT JOIN
            card
                ON card_payment_gateway.card_id = card.id
        WHERE
            payment.id IS NOT NULL
            AND payment.status = 1
)

, main AS
(
  SELECT
      * 
  FROM
      credit     
  UNION ALL     
  SELECT
      * 
  FROM
      refund_subs_not_null     
  UNION ALL     
  SELECT
      * 
  FROM
      tran     
  UNION ALL     
  SELECT
      * 
  FROM
      void_cc_inv_not_null     
  UNION ALL     
  SELECT
      * 
  FROM
      void_cc_inv_null     
  UNION ALL     
  SELECT
      * 
  FROM
      void_hint_payment_null     
  UNION ALL     
  SELECT
      * 
  FROM
      void_hint_payment_not_null     
  UNION ALL     
  SELECT
      * 
  FROM
      payment
)
SELECT * FROM main
GROUP BY
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
    12,
    13,
    14,
    15,
    16

----------- customer ----------------

WITH sub_plan AS ( SELECT
    plan_id,
    to_char(min(CASE
        WHEN subscription.type =1  THEN subscription.created_at
        WHEN subscription.type=2 THEN subscription.created_at
        ELSE NULL
    end),
    'yyyy-mm-dd') AS member_on_boarding_date,
    to_char(max(CASE
        WHEN subscription.type =1  THEN subscription.deprecated_at
        WHEN subscription.type=2 THEN subscription.deprecated_at
        ELSE NULL
    end),
    'yyyy-mm-dd') AS member_cancel_date
FROM
    subscription
WHERE
    subscription.status=0
GROUP BY
    plan_id ) , main AS ( SELECT
    customer_data.id AS k_customer_id,
    member_on_boarding_date,
    member_cancel_date,
    email AS customer_email,
    mobile AS customer_mobile,
    gender AS customer_gender,
    extract(YEAR
FROM
    birth_date_utc) AS customer_birth_year,
    gx_customer_id,
    CASE
        WHEN member_on_boarding_date IS NULL THEN 'non-member'
        ELSE 'member'
    END AS member_type,
    city AS customer_city,
    state AS customer_state,
    zip AS customer_zip,
    customer_data.type AS user_type,
    firstname,
    lastname
FROM
    users
JOIN
    customer_data
        ON users.id = user_id
LEFT JOIN
    plan
        ON plan.user_id = users.id
LEFT JOIN
    sub_plan
        ON plan_id = plan.id
LEFT JOIN
    address
        ON billing_address_id = address.id ) SELECT
        *
FROM
    main

----------------- product_sales -------------

WITH Subscription_cte AS
(
    SELECT
            subscription.id AS subscription_id,
            subscription.encrypted_ref_id AS k_subscirption_id,
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
            now()
    FROM
            subscription
        JOIN
            plan
                ON plan_id = plan.id
        JOIN
            customer
                ON customer.id = customer_id
        JOIN
            provider
                ON provider.id = provider_id
        WHERE
            subscription.status = 1 -- AND subscription.auto_renewal = 't'
)
, invoice AS
(
    SELECT
            invoice.id AS invoice_id,
            invoice.plan_id AS invoice_plan,
            invoice.status AS invoice_status
    FROM
            invoice
)
, subscription_no_auto_renewal AS
(
    SELECT
            subscription_cte.*
    FROM
            subscription_cte
        JOIN
            invoice
                ON subscription_cte.plan_id = invoice_plan
        WHERE
            invoice_status = 20
            AND
            subscription_cte.auto_renewal = 'f'
)
, main AS
(
    SELECT
        *
    FROM
        Subscription_cte
    WHERE
        subscription_cte.auto_renewal = 't'
    UNION ALL
    SELECT
        *
    FROM
        subscription_no_auto_renewal
)

    SELECT
            *
    FROM
        main
    GROUP BY
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
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24,
        25,
        26,
        27,
        28,
        29,
        30,
        31,
        32,
        33
----------- practice ----------
SELECT
    organization_data.id AS k_practice_id,
    gx_provider_id,
    activated_at AS practice_activated_at,
    timezone AS practice_time_zone,
    lastname AS practice_name,
    city AS practice_city,
    state AS practice_state,
    zip AS practice_zip
FROM
    organization_data
JOIN
    users
        ON organization_data.id = organization_id
JOIN
    address
        ON address.id = address_id
WHERE
    role = 7 

------- p2pe_device ----------

SELECT
      id AS device_id,
      organization_id,
      merchant_id,
      label,
      status,
      device_uuid
FROM
      p2pe_device 

----- kronos_subscription ------

SELECT
    sub.id AS subscription_id,
    sub.status,
    sub.cycles,
    sub.quantity,
    sub.is_subscription,
    sub.period_unit,
    sub.period,
    gx_subscription_id,
    sub.plan_id,
    sub.offering_id,
    sub.type AS subscription_type,
    ad_hoc_offering_id
FROM
    subscription sub
left join
    ad_hoc_offering ad
        on ad.id = ad_hoc_offering_id 

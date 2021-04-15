WITH refund1 as
(
  SELECT
       'refund1_'||cast(refund.id AS text) AS sales_id,
       refund.name AS sales_name,
       refund.amount AS sales_amount,
       refund.type AS sales_type,
       refund.status AS sales_status,
       refund.created_at AS sales_created_at,
       customer.encrypted_ref_id AS gx_customer_id,
       provider.encrypted_ref_id AS gx_provider_id,
       CASE  WHEN refund.id IS NOT NULL THEN gt.transaction_id else '' END AS transaction_id,
       CASE WHEN refund.type = 'credit_card' THEN last4 ELSE refund.reason END AS payment_id,
       cpg.tokenization,
       sub.encrypted_ref_id AS gx_subscription_id,
       refund.created_by AS staff_user_id,
       NULL AS device_id,
       gratuity.amount AS gratuity_amount,
       NULL AS is_voided
   FROM public.refund
   LEFT JOIN public.gratuity
           ON gratuity.id = refund.gratuity_id
   LEFT JOIN public.subscription sub
           ON subscription_id = sub.id
   LEFT JOIN public.plan
           ON sub.plan_id = plan.id
   LEFT JOIN public.customer
           ON customer.id = plan.customer_id
   LEFT JOIN public.provider
           ON provider.id = provider_id
   LEFT JOIN public.gateway_transaction gt
           ON refund.gateway_transaction_id = gt.id
   LEFT JOIN public.card_payment_gateway cpg
           ON cpg.id = gt.card_payment_gateway_id
   LEFT JOIN public.card
           ON cpg.card_id = card.id
   WHERE
       subscription_id IS NOT NULL
       AND refund.status =20
       AND refund.is_void = 'f'
)
, refund3 as
(
  SELECT
       'refund3_'||cast(refund.id AS text) AS sales_id   ,
       refund.name AS sales_name   ,
       refund.amount AS sales_amount   ,
       refund.type AS sales_type   ,
       refund.status AS sales_status   ,
       refund.created_at AS sales_created_at   ,
       customer.encrypted_ref_id AS gx_customer_id   ,
       provider.encrypted_ref_id AS gx_provider_id   ,
       gt.transaction_id   ,
       CASE WHEN refund.type = 'credit_card' THEN last4 ELSE refund.reason END AS payment_id   ,
       cpg.tokenization   ,
       sub.encrypted_ref_id AS gx_subscription_id   ,
       refund.created_by AS staff_user_id   ,
       NULL AS device_id   ,
       gratuity.amount AS gratuity_amount   ,
       null as is_voided
   FROM public.refund
   LEFT JOIN public.gratuity
           ON gratuity.id = refund.gratuity_id
   LEFT JOIN public.gateway_transaction gt
           ON gateway_transaction_id = gt.id
   LEFT JOIN public.payment
           ON gt.payment_id = payment.id
   LEFT JOIN public.plan
           ON payment.plan_id = plan.id
   LEFT JOIN public.subscription sub
           ON payment.subscription_id = sub.id
   LEFT JOIN public.customer
           ON customer.id = plan.customer_id
   LEFT JOIN public.provider
           ON provider.id = provider_id
   LEFT JOIN public.card_payment_gateway cpg
           ON cpg.id = gt.card_payment_gateway_id
   LEFT JOIN public.card
           ON cpg.card_id = card.id
   WHERE
       refund.subscription_id IS NULL
       AND gt.invoice_item_id IS NULL
       AND source_object_name = 'refund'
       AND refund.status =20
       AND refund.is_void = 'f'
)
, void3 as
(
  SELECT
       'void3_'||cast(refund.id AS text) AS sales_id   ,
       refund.name AS sales_name   ,
       refund.amount AS sales_amount   ,
       refund.type AS sales_type   ,
       refund.status AS sales_status   ,
       refund.created_at AS sales_created_at   ,
       customer.encrypted_ref_id AS gx_customer_id   ,
       provider.encrypted_ref_id AS gx_provider_id   ,
       CASE WHEN refund.id IS NOT NULL THEN gt.transaction_id else '' END AS transaction_id   ,
       refund.reason AS payment_id   ,
       cpg.tokenization   ,
       sub.encrypted_ref_id AS gx_subscription_id   ,
       refund.created_by AS staff_user_id   ,
       NULL AS device_id   ,
       gratuity.amount AS gratuity_amount   ,
       refund.is_void::TEXT AS is_voided
   FROM public.refund
   LEFT JOIN public.gratuity
           ON gratuity.id = refund.gratuity_id
   LEFT JOIN public.gateway_transaction gt
           ON refund.gateway_transaction_id = gt.id
   LEFT JOIN public.invoice_item ivi
           ON gt.invoice_item_id = ivi.id
   LEFT JOIN public.subscription sub
           ON ivi.subscription_id = sub.id
   LEFT JOIN public.plan
           ON sub.plan_id = plan.id
   LEFT JOIN public.customer
           ON customer.id = plan.customer_id
   LEFT JOIN public.provider
           ON provider.id = provider_id
   LEFT JOIN public.card_payment_gateway cpg
           ON cpg.id = gt.card_payment_gateway_id
   WHERE
       refund.status =20
       AND refund.is_void = 't'
       AND gt.payment_id IS NULL
)
, void4 as
(
  SELECT
       'void4_'||cast(refund.id AS text) AS sales_id   ,
       refund.name AS sales_name   ,
       refund.amount AS sales_amount   ,
       refund.type AS sales_type   ,
       refund.status AS sales_status   ,
       refund.created_at AS sales_created_at   ,
       customer.encrypted_ref_id AS gx_customer_id   ,
       provider.encrypted_ref_id AS gx_provider_id   ,
       CASE WHEN refund.id IS NOT NULL THEN gt.transaction_id else '' END AS transaction_id   ,
       refund.reason AS payment_id,
       cpg.tokenization   ,
       sub.encrypted_ref_id AS gx_subscription_id   ,
       refund.created_by AS staff_user_id   ,
       NULL AS device_id   ,
       gratuity.amount AS gratuity_amount   ,
       refund.is_void::TEXT AS is_voided
   FROM public.refund
   LEFT JOIN public.gratuity
           ON gratuity.id = refund.gratuity_id
   LEFT JOIN public.subscription sub
           ON refund.subscription_id = sub.id
   LEFT JOIN public.gateway_transaction gt
           ON refund.gateway_transaction_id = gt.id
   LEFT JOIN public.payment
           ON payment.id = payment_id
   LEFT JOIN public.plan
           ON payment.plan_id = plan.id
   LEFT JOIN public.customer
           ON customer.id = plan.customer_id
   LEFT JOIN public.provider
           ON provider.id = provider_id
   LEFT JOIN public.card_payment_gateway cpg
           ON cpg.id = gt.card_payment_gateway_id
   WHERE
       refund.status =20
       AND refund.is_void = 't'
       AND gt.payment_id IS NOT NULL
)
, refund_void as
(
  SELECT * FROM refund1
  UNION ALL
  SELECT * FROM refund3
  UNION ALL
  SELECT * FROM void3
  UNION ALL
  SELECT * FROM void4
)
, Subscription_all AS
(
  SELECT
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
       current_timestamp::timestamp as loaded_at
   FROM public.subscription subscription
   INNER JOIN public.plan plan
           ON plan_id = plan.id
   INNER JOIN public.customer customer
           ON customer.id = customer_id
   INNER JOIN public.provider provider
           ON provider.id = provider_id
   WHERE
       subscription.status in (-1,0,1,20)
)
, invoice AS
(
  SELECT
       invoice.id AS invoice_id,
       invoice.plan_id AS invoice_plan,
       invoice.status AS invoice_status
   FROM
       public.invoice invoice
)
, subscription_no_auto_renewal AS
(
  SELECT Subscription_all.* FROM Subscription_all
  INNER JOIN invoice
           ON Subscription_all.plan_id = invoice.invoice_plan
  WHERE
       invoice_status = 20
       AND auto_renewal = 'f'
)
,  all_subscriptions AS
(
  SELECT * FROM Subscription_all
   WHERE auto_renewal = 't'
   UNION ALL
   SELECT * FROM subscription_no_auto_renewal
)
, product_sales AS
(
  SELECT distinct * FROM all_subscriptions
)
, product_sales_refund as
(
  SELECT
       prod.subscription_id,
       prod.k_subscription_id,
       prod.quantity,
       prod.unit_name,
       prod.remaining_payment,
       prod.balance,
       prod.discount_percentages,
       prod.discount_amts,
       prod.coupons,
       prod.credits,
       prod.payments,
       prod.total_installment,
       0::Numeric(18,2) as tax,
       case when ref.sales_amount < 0 then ref.sales_amount else (-1 * ref.sales_amount) end as subtotal,
       case when ref.sales_amount < 0 then ref.sales_amount else (-1 * ref.sales_amount) end as total,
       prod.START_date,
       prod.END_date,
       prod.end_count,
       prod.END_unit,
       prod.proration,
       prod.auto_renewal,
       prod.renewal_count,
       prod.subscription_name,
       prod.subscription_created,
       prod.subscription_updated_at,
       prod.subscription_canceled_at,
       prod.plan_id,
       prod.k_plan_id,
       prod.customer_id,
       prod.k_customer_id,
       prod.provider_id,
       prod.k_provider_id,
       prod.loaded_at,
       ref.sales_id
   FROM product_sales prod
   INNER JOIN refund_void ref
           ON ref.gx_subscription_id = prod.k_subscription_id
)
, union_qry as
(
  SELECT *, NULL::VARCHAR(64) AS sales_id FROM product_sales
  UNION ALL
  SELECT * FROM product_sales_refund
)
, main AS
(
  SELECT
  CASE WHEN sales_id IS NOT NULL THEN 'sub_'||subscription_id::VARCHAR||'_'||sales_id ELSE 'sub_'||subscription_id::VARCHAR(64) END  AS primary_product_id,
       union_qry.*
   FROM union_qry
)
SELECT * FROM main

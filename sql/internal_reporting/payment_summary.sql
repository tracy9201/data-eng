----- Data Pipeline: payment_summary ---------------------
----- Redshift Table: payment_summary ---------------------
----- Looker View: payment_summary ---------------------


select * from(
  SELECT 'credit_'||cast(credit.id AS text) AS sales_id,
    credit.name AS sales_name,
    credit.amount AS sales_amount,
    credit.type AS sales_type,
    credit.status AS sales_status,
    credit.created_at AS sales_created_at,
    gx_customer_id, gx_provider_id,
    credit.created_by AS staff_user_id,
    NULL AS device_id, NULL AS gratuity_amount,
    credit.balance as balance,
    null as reason
  FROM v4_g_credit credit
    LEFT JOIN v4_g_plan plan ON credit.plan_id = plan.id
    LEFT JOIN v4_k_plan k_plan on plan.encrypted_ref_id = k_plan.gx_plan_id
    LEFT JOIN v4_k_customer_data  customer on k_plan.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
  WHERE credit.id IS NOT NULL
    AND credit.status =1
    AND gx_plan_id is not null

  UNION

  SELECT 'payment_'||cast(payment.id AS text) AS sales_id,
    payment.name AS sales_name,
    payment.amount AS sales_amount,
    payment.type AS sales_type,
    payment.status AS sales_status,
    payment.created_at AS sales_created_at,
    gx_customer_id,
    gx_provider_id,
    payment.created_by AS staff_user_id,
    payment.device_id AS device_id,
    gratuity.amount AS gratuity_amount,
    payment.balance as balance,
    payment.reason
  FROM v4_g_payment payment
    LEFT JOIN gratuity ON gratuity.id = payment.gratuity_id
    LEFT JOIN v4_g_plan plan ON payment.plan_id = plan.id
    LEFT JOIN v4_k_plan k_plan on plan.encrypted_ref_id = k_plan.gx_plan_id
    LEFT JOIN v4_k_customer_data customer on k_plan.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
    LEFT JOIN v4_g_gateway_transaction gateway_transaction ON gateway_transaction.payment_id = payment.id
  WHERE payment.id IS NOT NULL
    AND payment.status = 1

  UNION

  SELECT 'refund1_'||cast(refund.id AS text) AS sales_id,
    refund.name AS sales_name,
    refund.amount AS sales_amount,
    refund.type AS sales_type,
    refund.status AS sales_status,
    refund.created_at AS sales_created_at,
    gx_customer_id,
    gx_provider_id,
    refund.created_by AS staff_user_id,
    NULL AS device_id,
    gratuity.amount AS gratuity_amount,
    refund.balance as balance,
    gateway_transaction.reason
  FROM v4_g_refund refund
    LEFT JOIN gratuity ON gratuity.id = refund.gratuity_id
    LEFT JOIN v4_g_subscription subscription ON subscription_id = subscription.id
    LEFT JOIN v4_g_plan plan ON subscription.plan_id = plan.id
    LEFT JOIN v4_g_gateway_transaction gateway_transaction on refund.gateway_transaction_id = gateway_transaction.id
    LEFT JOIN v4_k_plan k_plan on plan.encrypted_ref_id = k_plan.gx_plan_id
    LEFT JOIN v4_k_customer_data customer on k_plan.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
  WHERE subscription_id IS NOT NULL
    AND refund.status =20
    AND refund.is_void = 'f'

  UNION

  SELECT 'tran_'||cast(gateway_transaction.id AS text) AS sales_id,
    gateway_transaction.name AS sales_name,
    gateway_transaction.amount AS sales_amount,
    gateway_transaction.type AS sales_type,
    gateway_transaction.status AS sales_status,
    gateway_transaction.created_at AS sales_created_at,
    gx_customer_id,
    gx_provider_id,
    NULL AS staff_user_id,
    NULL AS device_id,
    gateway_transaction.gratuity_amount,
    NULL as balance,
    gateway_transaction.reason
  FROM v4_g_gateway_transaction gateway_transaction
    LEFT JOIN v4_g_invoice invoice ON invoice_id = invoice.id
    LEFT JOIN v4_g_invoice_item invoice_item ON invoice_item_id = invoice_item.id
    LEFT JOIN v4_g_subscription subscription ON subscription.id = invoice_item.subscription_id
    LEFT JOIN v4_g_plan plan ON subscription.plan_id = plan.id
    LEFT JOIN v4_k_plan k_plan on plan.encrypted_ref_id = k_plan.gx_plan_id
    LEFT JOIN v4_k_customer_data customer on k_plan.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
  WHERE source_object_name  = 'card_payment_gateway'
    AND gateway_transaction.status = 20
    AND gateway_transaction.payment_id IS NULL
    AND gateway_transaction.is_voided = 'f'


  UNION

  SELECT 'refund3_'||cast(refund.id AS text) AS sales_id,
    refund.name AS sales_name,
    refund.amount AS sales_amount,
    refund.type AS sales_type,
    refund.status AS sales_status,
    refund.created_at AS sales_created_at,
    gx_customer_id,
    gx_provider_id,
    refund.created_by AS staff_user_id,
    NULL AS device_id,
    gratuity.amount AS gratuity_amount,
    refund.balance as balance,
    gateway_transaction.reason
  FROM v4_g_refund refund
    LEFT JOIN gratuity ON gratuity.id = refund.gratuity_id
    LEFT JOIN v4_g_subscription ON subscription_id = v4_g_subscription.id
    LEFT JOIN v4_g_gateway_transaction gateway_transaction ON gateway_transaction_id = gateway_transaction.id
    LEFT JOIN v4_g_payment payment ON gateway_transaction.payment_id = payment.id
    LEFT JOIN v4_g_plan plan ON payment.plan_id = plan.id
    LEFT JOIN v4_k_plan k_plan on plan.encrypted_ref_id = k_plan.gx_plan_id
    LEFT JOIN v4_k_customer_data customer on k_plan.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
  WHERE refund.subscription_id IS NULL
    AND gateway_transaction.invoice_item_id IS NULL
    AND source_object_name = 'refund'
    AND refund.status =20
    AND refund.is_void = 'f'

  UNION

  SELECT 'settle_'||cast(settlement.id AS text) AS sales_id,
    card_brand AS sales_name,
    amount*100 AS sales_amount,
    settlement.type AS sales_type,
    CASE
      WHEN settlement_status like 'Accepted' then 1
      WHEN settlement_status like 'Amount' then 2
      WHEN settlement_status like 'Processed' then 3
      WHEN settlement_status like 'Queued' then 4
      WHEN settlement_status like 'Rejected' then 5
      WHEN settlement_status like 'Voided' then 6
      ELSE 7
      END AS sales_status,
    settlement_date AS sales_created_at,
    null AS gx_customer_id,
    provider.encrypted_ref_id AS gx_provider_id,
    NULL AS staff_user_id,
    NULL AS device_id,
    NULL AS gratuity_amount,
    NULL as balance,
    NULL as reason
  FROM v4_g_authorisation authorisation
    RIGHT JOIN v4_g_settlement settlement ON authorisation.id = settlement.authorisation_id
    LEFT JOIN v4_g_provider provider ON object_id = provider.id
  WHERE gateway_transaction_id IS NULL
    AND authorisation.object ='provider'

  UNION

  SELECT 'void1_'||cast(settlement.id AS text) AS sales_id,
    gateway_transaction.name AS sales_name,
    settlement.tendered*100 AS sales_amount,
    gateway_transaction.type AS sales_type,
    settlement.status AS sales_status,
    settlement.authd_date AS sales_created_at,
    customer.gx_customer_id,
    provider.gx_provider_id,
    NULL AS staff_user_id,
    NULL AS device_id,
    gateway_transaction.gratuity_amount AS gratuity_amount,
    NULL as balance,
    gateway_transaction.reason
  FROM v4_g_settlement settlement
    LEFT JOIN v4_g_gateway_transaction gateway_transaction ON gateway_transaction.id = gateway_transaction_id
    LEFT JOIN v4_g_invoice invoice ON  gateway_transaction.invoice_id = invoice.id
    LEFT JOIN v4_g_plan plan ON invoice.plan_id = plan.id
    LEFT JOIN v4_k_plan plan2 on plan.encrypted_ref_id = plan2.gx_plan_id
    LEFT JOIN v4_k_customer_data customer on plan2.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
  WHERE settlement.settlement_status = 'Voided'

  UNION

  SELECT 'void2_'||cast(settlement.id AS text) AS sales_id,
    gateway_transaction.name AS sales_name,
    settlement.tendered*100 AS sales_amount,
    gateway_transaction.type AS sales_type,
    settlement.status AS sales_status,
    settlement.authd_date AS sales_created_at,
    customer.gx_customer_id,
    provider.gx_provider_id,
    NULL AS staff_user_id,
    NULL AS device_id,
    gateway_transaction.gratuity_amount AS gratuity_amount,
    NULL as balance,
    gateway_transaction.reason
  FROM v4_g_settlement settlement
    LEFT JOIN v4_g_gateway_transaction gateway_transaction ON gateway_transaction.id = gateway_transaction_id
    LEFT JOIN v4_g_payment payment ON  payment.id = gateway_transaction.payment_id
    LEFT JOIN v4_g_plan plan ON payment.plan_id = plan.id
    LEFT JOIN v4_k_plan plan2 on plan.encrypted_ref_id = plan2.gx_plan_id
    LEFT JOIN v4_k_customer_data customer on plan2.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
  WHERE settlement.settlement_status = 'Voided'
    AND gateway_transaction.invoice_id IS NULL

  UNION

  SELECT 'void3_'||cast(refund.id AS text) AS sales_id,
    refund.name AS sales_name,
    refund.amount AS sales_amount,
    refund.type AS sales_type,
    refund.status AS sales_status,
    refund.created_at AS sales_created_at,
    customer.gx_customer_id,
    provider.gx_provider_id,
    refund.created_by AS staff_user_id,
    NULL AS device_id,
    gratuity.amount AS gratuity_amount,
    refund.balance as balance,
    gateway_transaction.reason
  FROM v4_g_refund refund
    LEFT JOIN gratuity ON gratuity.id = refund.gratuity_id
    LEFT JOIN v4_g_subscription subscription ON subscription_id = subscription.id
    LEFT JOIN v4_g_plan plan ON subscription.plan_id = plan.id
    LEFT JOIN v4_g_gateway_transaction gateway_transaction on refund.gateway_transaction_id = gateway_transaction.id
    LEFT JOIN v4_k_plan k_plan on plan.encrypted_ref_id = k_plan.gx_plan_id
    LEFT JOIN v4_k_customer_data customer on k_plan.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
  WHERE refund.status =20
    AND refund.is_void = 't'
) as a
 group by 1,2,3,4,5,6,7,8,9,10,11,12,13


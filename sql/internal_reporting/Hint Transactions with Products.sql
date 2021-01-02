
select sales_id, round(sales_amount/100,2) as sales_amount, sales_type, sales_created_at, customer_id, provider, staff_user_id, device_id, product_name, product_payment_amount, product_payment_id,
case when substring(tokenization,2,2) like '4%' then 'visa'
  when substring(tokenization,2,2) like '34%' or substring(tokenization,2,2) like '37%' then 'amex'
  when substring(tokenization,2,2) like '51%' or substring(tokenization,2,2) like '52%' or substring(tokenization,2,2) like '53%' or substring(tokenization,2,2) like '54%' or substring(tokenization,2,2) like '55%' then 'master'
  when substring(tokenization,2,2) like '60%' or substring(tokenization,2,2) like '65%' then 'visa'
  when tokenization is null then null
  else  'others' end as cc_brand
from (
    SELECT 'payment_'||cast(payment.id AS text) AS sales_id, payment.amount AS sales_amount, payment.type AS sales_type
    , payment.status AS sales_status, payment.created_at AS sales_created_at, customer.id AS customer_id, provider.name as provider
    , payment.created_by AS staff_user_id, device_id
    , ivi.name as product_name, tokenization, gt.amount as product_payment_amount, ivi.id as product_payment_id
    FROM rds_data.g_payment payment
    LEFT JOIN rds_data.g_plan ON payment.plan_id = g_plan.id
    LEFT JOIN rds_data.g_customer customer ON customer.id = g_plan.customer_id
    left join rds_data.g_provider provider on provider_id = provider.id
    left join rds_data.g_gateway_transaction gt on source_object_id = payment.id
    left join rds_data.g_invoice_item ivi on invoice_item_id = ivi.id
    LEFT JOIN rds_data.g_card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
    WHERE payment.status =1 and gt.status = 20 and ivi.status = 20 and source_object_name = 'payment'
  union all 
  SELECT 'credit_'||cast(credit.id AS text) AS sales_id, credit.amount AS sales_amount, credit.type AS sales_type
    , credit.status AS sales_status, credit.created_at AS sales_created_at, customer.id AS customer_id, provider.name as provider
    , credit.created_by AS staff_user_id, null as device_id
    , ivi.name as product_name, null as tokenization, gt.amount as product_payment_amount, ivi.id as product_payment_id
    FROM rds_data.g_credit credit
    LEFT JOIN rds_data.g_plan ON credit.plan_id = g_plan.id
    LEFT JOIN rds_data.g_customer customer ON customer.id = g_plan.customer_id
    left join rds_data.g_provider provider on provider_id = provider.id
    left join rds_data.g_gateway_transaction gt on source_object_id = credit.id
    left join rds_data.g_invoice_item ivi on invoice_item_id = ivi.id
    WHERE credit.status =1 and gt.status = 20 and ivi.status = 20 and source_object_name = 'credit'
  union all 
      SELECT 'invoice_'||cast(invoice.id AS text) AS sales_id, invoice.amount AS sales_amount, 'recurring' AS sales_type
      , invoice.status AS sales_status, invoice.created_at AS sales_created_at, customer.id AS customer_id, provider.name as provider
      , null AS staff_user_id, null as device_id
      , ivi.name as product_name, tokenization, ivi.amount as product_payment_amount,ivi.id as product_payment_id
      FROM rds_data.g_invoice invoice
      LEFT JOIN rds_data.g_plan ON invoice.plan_id = g_plan.id
      LEFT JOIN rds_data.g_customer customer ON customer.id = g_plan.customer_id
      left join rds_data.g_provider provider on provider_id = provider.id
      left join rds_data.g_invoice_item ivi on invoice.id = invoice_id
      left join rds_data.g_gateway_transaction gt on ivi.id = invoice_item_id
       LEFT JOIN rds_data.g_card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
      WHERE invoice.status =20  and invoice.amount >0 and ivi.status = 20 
      union all 
      SELECT 'refund_'||cast(refund.id AS text) AS sales_id, -1*refund.amount AS sales_amount, refund.type AS sales_type
    , refund.status AS sales_status, refund.created_at AS sales_created_at, customer.id AS customer_id, provider.name as provider
    , refund.created_by AS staff_user_id, null as device_id
    , ivi.name as product_name, tokenization,  -1*gt.amount as product_payment_amount
    , ivi.id as product_payment_id
    FROM rds_data.g_refund refund
    left join rds_data.g_gateway_transaction gt on gt.id = gateway_transaction_id
    left join rds_data.g_invoice iv on gt.invoice_id = iv.id
    left join rds_data.g_invoice_item ivi on iv.id = ivi.invoice_id
    LEFT JOIN rds_data.g_plan ON iv.plan_id = g_plan.id
    LEFT JOIN rds_data.g_customer customer ON customer.id = g_plan.customer_id
    left join rds_data.g_provider provider on provider_id = provider.id
    LEFT JOIN rds_data.g_card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
    WHERE (refund.status =1 or refund.status =20) and gt.status = 20 AND refund.is_void = 'f'
    union all 
    SELECT 'void1_'||cast(settlement.id AS text) AS sales_id,-1*settlement.tendered *100 AS sales_amount, 'voided' AS sales_type,settlement.status AS sales_status,settlement.authd_date AS sales_created_at,customer.id AS customer_id,provider.name AS provider, null AS staff_user_id, null as device_id, 
      ivi.name as product_name, token as tokenization,  -1*gt.amount as product_payment_amount, ivi.id as product_payment_id
  FROM rds_data.g_settlement settlement
  LEFT JOIN rds_data.g_gateway_transaction gt ON gt.id = gateway_transaction_id
  LEFT JOIN rds_data.g_invoice iv ON gt.invoice_id = iv.id
  LEFT JOIN rds_data.g_invoice_item ivi ON ivi.id = gt.invoice_item_id
  LEFT JOIN rds_data.g_plan plan ON iv.plan_id = plan.id
  LEFT JOIN rds_data.g_customer customer ON customer_id = customer.id
  LEFT JOIN rds_data.g_provider provider ON provider_id = provider.id
  LEFT JOIN 
  (
  SELECT  CASE WHEN refund.id IS NOT NULL THEN gt.transaction_id END AS transaction_id
  FROM rds_data.g_refund refund
  LEFT JOIN rds_data.g_gateway_transaction gt ON refund.gateway_transaction_id = gt.id
  WHERE  refund.status =20 AND refund.is_void = 't'
  ) AS void_3_4 on gt.transaction_id  = void_3_4.transaction_id
  WHERE settlement.settlement_status = 'Voided' AND gt.invoice_id IS NOT NULL AND gt.is_voided = 'f'
  and void_3_4.transaction_id is null
  union all
  SELECT 'void2_'||cast(settlement.id AS text) AS sales_id,-1*settlement.tendered *100 AS sales_amount, 'voided' AS sales_type,settlement.status AS sales_status,settlement.authd_date AS sales_created_at,customer.id AS customer_id,provider.name AS provider, null AS staff_user_id, null as device_id, 
      sub.name as product_name, token as tokenization, -1*gt.amount as product_payment_amount, invoice_item_id as product_payment_id
  FROM rds_data.g_settlement settlement
  LEFT JOIN rds_data.g_gateway_transaction gt ON gt.id = gateway_transaction_id
  LEFT JOIN rds_data.g_payment payment ON  payment_id = payment.id
  LEFT JOIN rds_data.g_subscription sub ON sub.id = payment.subscription_id
  LEFT JOIN rds_data.g_plan plan ON sub.plan_id = plan.id
  LEFT JOIN rds_data.g_customer customer ON customer_id = customer.id
  LEFT JOIN rds_data.g_provider provider ON provider_id = provider.id
  LEFT JOIN 
  (
  SELECT  CASE WHEN refund.id IS NOT NULL THEN gt.transaction_id END AS transaction_id
  FROM rds_data.g_refund refund
  LEFT JOIN rds_data.g_gateway_transaction gt ON refund.gateway_transaction_id = gt.id
  WHERE  refund.status =20 AND refund.is_void = 't'
  ) AS void_3_4 on gt.transaction_id  = void_3_4.transaction_id
  WHERE settlement.settlement_status = 'Voided' AND gt.invoice_id IS NULL AND gt.is_voided = 'f'
  and void_3_4.transaction_id is null
  union all 
  SELECT 'void3_'||cast(refund.id AS text) AS sales_id, -1*refund.amount AS sales_amount,refund.type AS sales_type,refund.status AS sales_status,refund.created_at AS sales_created_at, customer.id AS customer_id, provider.name as provider
    , refund.created_by AS staff_user_id, null as device_id
    , ivi.name as product_name, tokenization, -1*gt.amount as product_payment_amount
    , ivi.id as product_payment_id
  FROM rds_data.g_refund refund
  LEFT JOIN rds_data.g_gateway_transaction gt ON refund.gateway_transaction_id = gt.id
  LEFT JOIN rds_data.g_invoice_item ivi ON gt.invoice_item_id = ivi.id
  LEFT JOIN rds_data.g_subscription sub ON ivi.subscription_id = sub.id
  LEFT JOIN rds_data.g_plan plan ON sub.plan_id = plan.id
  LEFT JOIN rds_data.g_customer customer ON customer.id = plan.customer_id
  LEFT JOIN rds_data.g_provider provider ON provider.id = provider_id
  LEFT JOIN rds_data.g_card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
  WHERE  refund.status =20 AND refund.is_void = 't' AND gt.payment_id IS NULL
  union all
  SELECT 'void4_'||cast(refund.id AS text) AS sales_id, -1*refund.amount AS sales_amount,refund.type AS sales_type,refund.status AS sales_status,refund.created_at AS sales_created_at, customer.id AS customer_id, provider.name as provider
    , refund.created_by AS staff_user_id, null as device_id
    , sub.name as product_name, tokenization, -1*gt.amount as product_payment_amount
    , gt.invoice_item_id as product_payment_id
  FROM rds_data.g_refund refund
  LEFT JOIN rds_data.g_subscription sub ON refund.subscription_id = sub.id
  LEFT JOIN rds_data.g_gateway_transaction gt ON refund.gateway_transaction_id = gt.id
  LEFT JOIN rds_data.g_payment payment ON payment.id = payment_id
  LEFT JOIN rds_data.g_plan plan ON sub.plan_id = plan.id
  LEFT JOIN rds_data.g_customer customer ON customer.id = plan.customer_id
  LEFT JOIN rds_data.g_provider provider ON provider.id = provider_id
  LEFT JOIN rds_data.g_card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
  WHERE  refund.status =20 AND refund.is_void = 't' AND gt.payment_id IS NOT NULL
)
where sales_created_at >= '2020-01-01'
order by sales_created_at

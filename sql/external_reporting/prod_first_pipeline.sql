------------SrcRDSDataNode5  payment_summary---------------
SELECT * from(
SELECT 'credit_'||cast(c.id AS text) AS sales_id,c.name AS sales_name,c.amount AS sales_amount,c.type AS sales_type,c.status AS sales_status,c.created_at AS sales_created_at,customer.encrypted_ref_id AS gx_customer_id,provider.encrypted_ref_id AS gx_provider_id,CASE WHEN c.id IS NOT NULL THEN '' END AS transaction_id,c.name AS payment_id,'0000000000000000' AS tokenization,sub.encrypted_ref_id AS gx_subscription_id
,c.created_by AS staff_user_id,NULL AS device_id,NULL AS gratuity_amount,NULL AS is_voided
FROM credit c
LEFT JOIN subscription sub ON sub.id = c.subscription_id
LEFT JOIN plan ON c.plan_id = plan.id
LEFT JOIN customer ON customer.id = plan.customer_id
LEFT JOIN provider ON provider.id = provider_id
WHERE c.id IS NOT NULL AND c.status =1
UNION ALL
SELECT 'payment_'||cast(p.id AS text) AS sales_id,p.name AS sales_name,p.amount AS sales_amount,p.type AS sales_type,p.status AS sales_status,p.created_at AS sales_created_at,customer.encrypted_ref_id AS gx_customer_id,provider.encrypted_ref_id AS gx_provider_id,p.transaction_id,CASE WHEN p.type ='credit_card' THEN account_number ELSE p.name END AS payment_id,cpg.tokenization,sub.encrypted_ref_id AS gx_subscription_id,p.created_by AS staff_user_id,p.device_id,gratuity.amount AS gratuity_amount,NULL AS is_voided
FROM payment p
LEFT JOIN subscription sub ON sub.id = p.subscription_id
LEFT JOIN gratuity ON gratuity.id = p.gratuity_id
LEFT JOIN plan ON p.plan_id = plan.id
LEFT JOIN customer ON customer.id = customer_id
LEFT JOIN provider ON provider.id = provider_id
LEFT JOIN gateway_transaction gt ON gt.payment_id = p.id
LEFT JOIN card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN card ON cpg.card_id = card.id
WHERE p.id IS NOT NULL AND p.status = 1
UNION ALL
SELECT 'refund1_'||cast(refund.id AS text) AS sales_id,refund.name AS sales_name,refund.amount AS sales_amount,refund.type AS sales_type,refund.status AS sales_status,refund.created_at AS sales_created_at,customer.encrypted_ref_id AS gx_customer_id,provider.encrypted_ref_id AS gx_provider_id,CASE WHEN refund.id IS NOT NULL THEN gt.transaction_id else '' END AS transaction_id,CASE WHEN refund.type = 'credit_card' THEN last4 ELSE refund.reason END AS payment_id,cpg.tokenization,sub.encrypted_ref_id AS gx_subscription_id
,refund.created_by AS staff_user_id,NULL AS device_id,gratuity.amount AS gratuity_amount,NULL AS is_voided
FROM refund
LEFT JOIN gratuity ON gratuity.id = refund.gratuity_id
LEFT JOIN subscription sub ON subscription_id = sub.id
LEFT JOIN plan ON sub.plan_id = plan.id
LEFT JOIN customer ON customer.id = plan.customer_id
LEFT JOIN provider ON provider.id = provider_id
LEFT JOIN gateway_transaction gt ON refund.gateway_transaction_id = gt.id
LEFT JOIN card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN card ON cpg.card_id = card.id
WHERE subscription_id IS NOT NULL AND refund.status =20 AND refund.is_void = 'f'
UNION ALL
SELECT 'refund3_'||cast(refund.id AS text) AS sales_id,refund.name AS sales_name,refund.amount AS sales_amount,refund.type AS sales_type,refund.status AS sales_status,refund.created_at AS sales_created_at,customer.encrypted_ref_id AS gx_customer_id,provider.encrypted_ref_id AS gx_provider_id,gt.transaction_id,CASE WHEN refund.type = 'credit_card' THEN last4 ELSE refund.reason END AS payment_id,cpg.tokenization,sub.encrypted_ref_id AS gx_subscription_id,refund.created_by AS staff_user_id
,NULL AS device_id,gratuity.amount AS gratuity_amount,null as is_voided
FROM refund
LEFT JOIN gratuity ON gratuity.id = refund.gratuity_id
LEFT JOIN gateway_transaction gt ON gateway_transaction_id = gt.id
LEFT JOIN payment ON gt.payment_id = payment.id
LEFT JOIN plan ON payment.plan_id = plan.id
LEFT JOIN subscription sub ON payment.subscription_id = sub.id
LEFT JOIN customer ON customer.id = plan.customer_id
LEFT JOIN provider ON provider.id = provider_id
LEFT JOIN card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN card ON cpg.card_id = card.id
WHERE refund.subscription_id IS NULL AND gt.invoice_item_id IS NULL  AND source_object_name = 'refund'  AND refund.status =20 AND refund.is_void = 'f'
UNION ALL
SELECT 'tran_'||cast(gt.id AS text) AS sales_id,gt.name AS sales_name,gt.amount AS sales_amount,gt.type AS sales_type,gt.status AS sales_status,gt.created_at AS sales_created_at,customer.encrypted_ref_id AS gx_customer_id,provider.encrypted_ref_id AS gx_provider_id,transaction_id,last4 AS payment_id ,cpg.tokenization,sub.encrypted_ref_id AS gx_subscription_id
,NULL AS staff_user_id,NULL AS device_id,gt.gratuity_amount,NULL AS is_voided
FROM gateway_transaction gt
LEFT JOIN invoice ON invoice_id = invoice.id
LEFT JOIN invoice_item ivi ON invoice_item_id = ivi.id
LEFT JOIN subscription sub ON sub.id = ivi.subscription_id
LEFT JOIN plan ON invoice.plan_id = plan.id
LEFT JOIN customer ON customer.id = plan.customer_id
LEFT JOIN provider ON provider.id = provider_id
LEFT JOIN card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN card ON cpg.card_id = card.id
WHERE source_object_name  = 'card_payment_gateway' AND gt.status = 20 AND gt.payment_id IS NULL  AND gt.is_voided = 'f'
UNION ALL
SELECT 'void1_'||cast(settlement.id AS text) AS sales_id,gt.name AS sales_name,settlement.tendered *100 AS sales_amount,gt.type AS sales_type,settlement.status AS sales_status,settlement.authd_date AS sales_created_at,customer.encrypted_ref_id AS gx_customer_id,provider.encrypted_ref_id AS gx_provider_id,gt.transaction_id,settlement.last_four AS payment_id,token AS tokenization,sub.encrypted_ref_id AS gx_subscription_id
,NULL AS staff_user_id,NULL AS device_id,gt.gratuity_amount AS gratuity_amount,gt.is_voided::text  AS is_voided
FROM settlement
LEFT JOIN gateway_transaction gt ON gt.id = gateway_transaction_id
LEFT JOIN invoice ON gt.invoice_id = invoice.id
LEFT JOIN invoice_item ivi ON ivi.id = gt.invoice_item_id
LEFT JOIN subscription sub ON sub.id = ivi.subscription_id
LEFT JOIN plan ON invoice.plan_id = plan.id
LEFT JOIN customer ON customer_id = customer.id
LEFT JOIN provider ON provider_id = provider.id
LEFT JOIN 
(
SELECT  CASE WHEN refund.id IS NOT NULL THEN gt.transaction_id END AS transaction_id
FROM refund
LEFT JOIN gateway_transaction gt ON refund.gateway_transaction_id = gt.id
WHERE  refund.status =20 AND refund.is_void = 't'
) AS void_3_4 on gt.transaction_id  = void_3_4.transaction_id
WHERE settlement.settlement_status = 'Voided' AND gt.invoice_id IS NOT NULL AND gt.is_voided = 'f'
and void_3_4.transaction_id is null
UNION ALL
SELECT 'void2_'||cast(settlement.id AS text) AS sales_id,gt.name AS sales_name,settlement.tendered*100 AS sales_amount,gt.type AS sales_type,settlement.status AS sales_status,settlement.authd_date AS sales_created_at,customer.encrypted_ref_id AS gx_customer_id,provider.encrypted_ref_id AS gx_provider_id,gt.transaction_id,settlement.last_four AS payment_id,token AS tokenization,sub.encrypted_ref_id AS gx_subscription_id
,NULL AS staff_user_id,NULL AS device_id,gt.gratuity_amount AS gratuity_amount,gt.is_voided::text AS is_voided
FROM settlement
LEFT JOIN gateway_transaction gt ON gt.id = gateway_transaction_id
LEFT JOIN payment ON  payment_id = payment.id
LEFT JOIN subscription sub ON sub.id = payment.subscription_id
LEFT JOIN plan ON payment.plan_id = plan.id
LEFT JOIN customer ON customer_id = customer.id
LEFT JOIN provider ON provider_id = provider.id
LEFT JOIN 
(
SELECT  CASE WHEN refund.id IS NOT NULL THEN gt.transaction_id END AS transaction_id
FROM refund
LEFT JOIN gateway_transaction gt ON refund.gateway_transaction_id = gt.id
WHERE  refund.status =20 AND refund.is_void = 't'
) AS void_3_4 on gt.transaction_id  = void_3_4.transaction_id
WHERE settlement.settlement_status = 'Voided' AND invoice_id IS NULL AND gt.is_voided = 'f'
and void_3_4.transaction_id is null
UNION ALL
SELECT 'void3_'||cast(refund.id AS text) AS sales_id,refund.name AS sales_name,refund.amount AS sales_amount,refund.type AS sales_type,refund.status AS sales_status,refund.created_at AS sales_created_at,customer.encrypted_ref_id AS gx_customer_id,provider.encrypted_ref_id AS gx_provider_id,CASE WHEN refund.id IS NOT NULL THEN gt.transaction_id else '' END AS transaction_id,refund.reason AS payment_id,cpg.tokenization,sub.encrypted_ref_id AS gx_subscription_id
,refund.created_by AS staff_user_id,NULL AS device_id,gratuity.amount AS gratuity_amount,refund.is_void::text AS is_voided
FROM refund
LEFT JOIN gratuity ON gratuity.id = refund.gratuity_id
LEFT JOIN gateway_transaction gt ON refund.gateway_transaction_id = gt.id
LEFT JOIN invoice_item ivi ON gt.invoice_item_id = ivi.id
LEFT JOIN subscription sub ON ivi.subscription_id = sub.id
LEFT JOIN plan ON sub.plan_id = plan.id
LEFT JOIN customer ON customer.id = plan.customer_id
LEFT JOIN provider ON provider.id = provider_id
LEFT JOIN card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
WHERE  refund.status =20 AND refund.is_void = 't' AND gt.payment_id IS NULL
UNION ALL
SELECT 'void4_'||cast(refund.id AS text) AS sales_id,refund.name AS sales_name,refund.amount AS sales_amount,refund.type AS sales_type,refund.status AS sales_status,refund.created_at AS sales_created_at,customer.encrypted_ref_id AS gx_customer_id,provider.encrypted_ref_id AS gx_provider_id,CASE WHEN refund.id IS NOT NULL THEN gt.transaction_id else '' END AS transaction_id,refund.reason AS payment_id,cpg.tokenization,sub.encrypted_ref_id AS gx_subscription_id
,refund.created_by AS staff_user_id,NULL AS device_id,gratuity.amount AS gratuity_amount,refund.is_void::text AS is_voided
FROM refund
LEFT JOIN gratuity ON gratuity.id = refund.gratuity_id
LEFT JOIN subscription sub ON refund.subscription_id = sub.id
LEFT JOIN gateway_transaction gt ON refund.gateway_transaction_id = gt.id
LEFT JOIN payment ON payment.id = payment_id
LEFT JOIN plan ON payment.plan_id = plan.id
LEFT JOIN customer ON customer.id = plan.customer_id
LEFT JOIN provider ON provider.id = provider_id
LEFT JOIN card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
WHERE  refund.status =20 AND refund.is_void = 't' AND gt.payment_id IS NOT NULL
) AS a
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
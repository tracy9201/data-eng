------------SrcRDSDataNode5  payment_summary---------------
WITH CREDIT AS
( 
SELECT 'credit_'||cast(c.id AS text) AS sales_id
,c.name AS sales_name
,c.amount AS sales_amount
,c.type AS sales_type
,c.status AS sales_status
,c.created_at AS sales_created_at
,customer.encrypted_ref_id AS gx_customer_id
,provider.encrypted_ref_id AS gx_provider_id
,CASE WHEN c.id IS NOT NULL THEN '' END AS transaction_id
,c.name AS payment_id
,'0000000000000000'::VARCHAR AS tokenization
,sub.encrypted_ref_id AS gx_subscription_id
,c.created_by AS staff_user_id
,NULL::TEXT AS device_id
,NULL::NUMERIC(20,9) AS gratuity_amount
,NULL::TEXT AS is_voided
FROM credit c
LEFT JOIN subscription sub ON sub.id = c.subscription_id
LEFT JOIN plan ON c.plan_id = plan.id
LEFT JOIN customer ON customer.id = plan.customer_id
LEFT JOIN provider ON provider.id = provider_id
WHERE c.id IS NOT NULL AND c.status =1
)

, PAYMENT_cte AS
(  
SELECT 'payment_'||cast(p.id AS text) AS sales_id
,p.name AS sales_name
,p.amount AS sales_amount
,p.type AS sales_type
,p.status AS sales_status
,p.created_at AS sales_created_at
,customer.encrypted_ref_id AS gx_customer_id
,provider.encrypted_ref_id AS gx_provider_id
,p.transaction_id
,CASE WHEN p.type ='credit_card' THEN account_number ELSE p.name END AS payment_id
,cpg.tokenization::varchar
,sub.encrypted_ref_id AS gx_subscription_id
,p.created_by AS staff_user_id
,p.device_id
,gratuity.amount AS gratuity_amount
,NULL::TEXT AS is_voided
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
)

, REFUND1 AS
( 
SELECT 'refund1_'||cast(refund.id AS text) AS sales_id
,refund.name AS sales_name
,refund.amount AS sales_amount
,refund.type AS sales_type
,refund.status AS sales_status
,refund.created_at AS sales_created_at
,customer.encrypted_ref_id AS gx_customer_id
,provider.encrypted_ref_id AS gx_provider_id
,CASE WHEN refund.id IS NOT NULL THEN gt.transaction_id else '' END AS transaction_id
,CASE WHEN refund.type = 'credit_card' THEN last4 ELSE refund.reason END AS payment_id
,cpg.tokenization::varchar
,sub.encrypted_ref_id AS gx_subscription_id
,refund.created_by AS staff_user_id
,NULL::TEXT AS device_id
,gratuity.amount AS gratuity_amount
,NULL::VARCHAR AS is_voided
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
)

, REFUND3 AS
(
SELECT 'refund3_'||cast(refund.id AS text) AS sales_id
,refund.name AS sales_name
,refund.amount AS sales_amount
,refund.type AS sales_type
,refund.status AS sales_status
,refund.created_at AS sales_created_at
,customer.encrypted_ref_id AS gx_customer_id
,provider.encrypted_ref_id AS gx_provider_id
,gt.transaction_id
,CASE WHEN refund.type = 'credit_card' THEN last4 ELSE refund.reason END AS payment_id
,cpg.tokenization::varchar
,sub.encrypted_ref_id AS gx_subscription_id
,refund.created_by AS staff_user_id
,NULL::TEXT AS device_id
,gratuity.amount AS gratuity_amount
,null::TEXT as is_voided
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
)

, TRAN AS
(
SELECT 'tran_'||cast(gt.id AS text) AS sales_id
,gt.name AS sales_name
,gt.amount AS sales_amount
,gt.type AS sales_type
,gt.status AS sales_status
,gt.created_at AS sales_created_at
,customer.encrypted_ref_id AS gx_customer_id
,provider.encrypted_ref_id AS gx_provider_id
,transaction_id
,last4 AS payment_id 
,cpg.tokenization::varchar
,sub.encrypted_ref_id AS gx_subscription_id
,NULL::TEXT AS staff_user_id
,NULL::TEXT AS device_id
,gt.gratuity_amount
,NULL::text AS is_voided
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
)

, VOID1 AS
(
SELECT 'void1_'||cast(settlement.id AS text) AS sales_id
,gt.name AS sales_name
,settlement.tendered *100 AS sales_amount
,gt.type AS sales_type
,settlement.status AS sales_status
,settlement.authd_date AS sales_created_at
,customer.encrypted_ref_id AS gx_customer_id
,provider.encrypted_ref_id AS gx_provider_id
,gt.transaction_id,settlement.last_four AS payment_id
,token::varchar AS tokenization
,sub.encrypted_ref_id AS gx_subscription_id
,NULL::TEXT AS staff_user_id
,NULL::TEXT AS device_id
,gt.gratuity_amount AS gratuity_amount
,gt.is_voided::text  AS is_voided
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
)

, VOID2 AS
(
SELECT 'void2_'||cast(settlement.id AS text) AS sales_id
,gt.name AS sales_name
,settlement.tendered*100 AS sales_amount
,gt.type AS sales_type
,settlement.status AS sales_status
,settlement.authd_date AS sales_created_at
,customer.encrypted_ref_id AS gx_customer_id
,provider.encrypted_ref_id AS gx_provider_id
,gt.transaction_id
,settlement.last_four AS payment_id
,token::varchar AS tokenization
,sub.encrypted_ref_id AS gx_subscription_id
,NULL::TEXT AS staff_user_id
,NULL::TEXT AS device_id
,gt.gratuity_amount AS gratuity_amount
,gt.is_voided::text AS is_voided
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
)

, VOID3 AS
(
SELECT 'void3_'||cast(refund.id AS text) AS sales_id
,refund.name AS sales_name
,refund.amount AS sales_amount
,refund.type AS sales_type
,refund.status AS sales_status
,refund.created_at AS sales_created_at
,customer.encrypted_ref_id AS gx_customer_id
,provider.encrypted_ref_id AS gx_provider_id
,CASE WHEN refund.id IS NOT NULL THEN gt.transaction_id else '' END AS transaction_id
,refund.reason AS payment_id
,cpg.tokenization::varchar
,sub.encrypted_ref_id AS gx_subscription_id
,refund.created_by AS staff_user_id
,NULL::TEXT AS device_id
,gratuity.amount AS gratuity_amount
,refund.is_void::text AS is_voided
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
)

, VOID4 AS
(
SELECT 'void4_'||cast(refund.id AS text) AS sales_id
,refund.name AS sales_name
,refund.amount AS sales_amount
,refund.type AS sales_type
,refund.status AS sales_status
,refund.created_at AS sales_created_at
,customer.encrypted_ref_id AS gx_customer_id
,provider.encrypted_ref_id AS gx_provider_id
,CASE WHEN refund.id IS NOT NULL THEN gt.transaction_id else '' END AS transaction_id
,refund.reason AS payment_id
,cpg.tokenization::varchar
,sub.encrypted_ref_id AS gx_subscription_id
,refund.created_by AS staff_user_id
,NULL::TEXT AS device_id
,gratuity.amount AS gratuity_amount
,refund.is_void::text AS is_voided
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
) 

, UNION_QRY AS 
(
	SELECT * FROM CREDIT
	UNION ALL
	SELECT * FROM PAYMENT_cte
	UNION ALL
	SELECT * FROM REFUND1
	UNION ALL
	SELECT * FROM REFUND3
	UNION ALL
	SELECT * FROM TRAN
	UNION ALL
	SELECT * FROM VOID1
	UNION ALL
	SELECT * FROM VOID2 
	UNION ALL
	SELECT * FROM VOID3
	UNION ALL
	SELECT * FROM VOID4 
)
, TRANSFORM  AS
(
 SELECT sales_id
 , sales_name
 , sales_amount
 , sales_type
 , case when sales_id like 'refund%' then 'Refund'
      when sales_id like 'credit%'  and  sales_type in ('reward', 'credit') and sales_name = 'BD Payment' then 'Offer Redemption'
      when sales_id like 'credit%'  and  sales_type = 'provider credit' then 'Deposit From Patient'
      when sales_id like 'credit%' then 'Redemption'
      when sales_id like 'void%' then 'Void'
      else 'Sale'
      end as transaction
 , sales_status
 , sales_created_at
 , gx_customer_id
 , gx_provider_id
 , transaction_id
 , payment_id
 , tokenization
 , gx_subscription_id
 , staff_user_id
 , device_id
 , gratuity_amount
 , is_voided
 
 FROM UNION_QRY 
)
, MAIN AS
(
  SELECT sales_id
 , sales_name
 , sales_amount
 , sales_type
 , sales_status
 , sales_created_at
 , gx_customer_id
 , gx_provider_id
 , transaction_id
 , case 
       when sales_type = 'check' then payment_id
       when sales_type ='credit_card' and ( sales_id like 'tran%' or sales_id like 'payment%' or sales_id like 'refund%' )then CONCAT('**** ',cast(payment_id as VARCHAR))
       when transaction = 'Void' then CONCAT('**** ',cast(right(tokenization,4) as VARCHAR))
       else null end 
  as payment_id
 , tokenization
 , gx_subscription_id
 , staff_user_id
 , device_id
 , gratuity_amount
 , is_voided
 FROM TRANSFORM
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
)
SELECT * FROM MAIN

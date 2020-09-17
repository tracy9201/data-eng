DROP TABLE dwh.fact_payfac_deposit;

CREATE TABLE dwh.fact_payfac_deposit as
WITH charges_refunds as
(
	SELECT
	id
	,transaction_id
	,merchant_id
	,transaction_time::date as settlement_date
	,card_brand
	,card_identifier
	,CASE WHEN amount >= 0 THEN 'Charge' ELSE 'Refund' END as type
	,cp_or_cnp
	,CASE	WHEN cp_or_cnp = 'cp' THEN 'Card Present Fee'
			WHEN cp_or_cnp = 'cnp' THEN 'Card Not Present Fee' END as fee_type
	,percent_fee
	,fixed_fee
	,total_fee
	,CASE WHEN type = 'Charge' THEN 0.10 ELSE 0 END as Transaction_fee
	,amount
	FROM payfac.fiserv_transaction
	WHERE transaction_status = 'A'
),

chargebacks as
(
	SELECT 
	id
	,chargeback_id as transaction_id
	,merchant_id
	,transaction_date::date as settlement_date
	,card_brand
	,card_identifier
	,'Chargeback' as type
	,NULL as cp_or_cnp
	,'Chargeback Fee'  as fee_type
	,0 AS percent_fee
	,10 as fixed_fee
	,10 as total_fee
	,0 as Transaction_fee
	,amount
	FROM payfac.fiserv_chargeback
),

adjustments as
(
	SELECT
	id
	,adjustment_id as transaction_id
	,merchant_id
	,transaction_date::date as settlement_date
	,NULL AS card_brand
	,NULL AS card_identifier
	,'Adjustments' as type
	,NULL AS cp_or_cnp
	,NULL AS fee_type
	,0 AS percent_fee
	,0 as fixed_fee
	,0 as total_fee
	,0 as Transaction_fee
	,amount
	FROM payfac.fiserv_deposit_adjustment
),

main as
(
	SELECT * FROM charges_refunds
	UNION all
	SELECT * FROM chargebacks
	UNION all
	SELECT * FROM adjustments
)

SELECT * FROM main;
--------------------------- fact_payfac_deposit  ---------------------------

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




--------------------------- fact_payfac_deposit_details  ---------------------------



DROP TABLE dwh.fact_payfac_deposit_details;

CREATE TABLE dwh.fact_payfac_deposit_details as
WITH deposit_details as 
(
SELECT 
	merchant_id
	,settlement_date
	,to_char(settlement_date,'YYYY-MM') as settlement_month
	,sum(CASE WHEN type in ('Charge','Refund','Chargeback') THEN 1 ELSE 0 end) transactions
	,sum(CASE WHEN type = 'Charge' THEN amount end) as Charges
	,sum(CASE WHEN type = 'Refund' THEN amount end) as Refunds
	,sum(CASE WHEN type = 'Chargeback' THEN amount end) as Chargebacks
	,sum(CASE WHEN type = 'Adjustments' THEN amount end) as Adjustments
	,sum(total_fee) as total_fee
	,sum(CASE WHEN cp_or_cnp = 'cp' and type = 'Charge' THEN amount ELSE 0 end) as cp_transaction_amount
	,sum(CASE WHEN cp_or_cnp = 'cnp' and type = 'Charge' THEN amount ELSE 0 end) as cnp_transaction_amount
	,sum(CASE WHEN type = 'Charge' THEN amount ELSE 0 end) as Charges_transaction_amount
	,sum(CASE WHEN type = 'Chargeback' THEN amount ELSE 0 end) as Chargeback_transaction_amount
	,sum(CASE WHEN cp_or_cnp = 'cp' and type = 'Charge' THEN 1 ELSE 0 end) as cp_transaction_count
	,sum(CASE WHEN cp_or_cnp = 'cnp' and type = 'Charge' THEN 1 ELSE 0 end) as cnp_transaction_count
	,sum(CASE WHEN type = 'Charge' THEN 1 ELSE 0 end) as Charges_transaction_count
	,sum(CASE WHEN type = 'Chargeback' THEN 1 ELSE 0 end) as Chargeback_transaction_count
	FROM dwh.fact_payfac_deposit
	GROUP BY 1,2,3
)

SELECT 
	dt.date
	,dt.merchant_id as merchant_id
	,a.settlement_date
	,a.settlement_month
	,a.transactions
	,a.Charges
	,a.Refunds
	,a.Chargebacks
	,a.Adjustments
	,a.total_fee
	,a.cp_transaction_amount
	,a.cnp_transaction_amount
	,a.Charges_transaction_amount
	,a.Chargeback_transaction_amount
	,a.cp_transaction_count
	,a.cnp_transaction_count
	,a.Charges_transaction_count
	,a.Chargeback_transaction_count
FROM dwh.dim_payfac_date_merchant dt
LEFT JOIN deposit_details a on dt.date = a.settlement_date and dt.merchant_id = a.merchant_id;



--------------------------- fact_payfac_deposit_summary  ---------------------------



DROP TABLE dwh.fact_payfac_deposit_summary;

CREATE TABLE dwh.fact_payfac_deposit_summary as
WITH dates AS 
(
	SELECT  settlement_month
	,to_char(min(settlement_date),'MM/DD') || '-' ||to_char(max(settlement_date),'MM/DD') as range
	FROM  dwh.fact_payfac_deposit_details
	GROUP BY 1
)

SELECT
	b.merchant_id
	,a.settlement_month as setl_month
	,to_date(a.settlement_month||'-01','YYYY-MM-DD') as settlement_month
	,a.range
	,sum(b.transactions) as Transactions
	,sum(b.charges) as Charges
	,sum(b.refunds) as Refunds
	,sum(b.chargebacks) as Chargebacks
	,sum(b.adjustments) as Adjustments
	,sum(b.total_fee) as total_fee
	,sum(b.cp_transaction_count) cp_transaction_count
	,sum(b.cnp_transaction_count) cnp_transaction_count
	,sum(b.Charges_transaction_count) Charges_transaction_count
	,sum(b.Chargeback_transaction_count) Chargeback_transaction_count
	,sum(b.cp_transaction_amount) cp_transaction_amount
	,sum(b.cnp_transaction_amount) cnp_transaction_amount
	,sum(b.Charges_transaction_amount) Charges_transaction_amount
	,sum(b.Chargeback_transaction_amount) Chargeback_transaction_amount
FROM dwh.fact_payfac_deposit_details b
JOIN dates a on a.settlement_month = b.settlement_month
GROUP BY 1,2,3,4;



--------------------------- fact_payfac_fee_basis  ---------------------------


DROP TABLE dwh.fact_payfac_fee_basis;

CREATE TABLE dwh.fact_payfac_fee_basis as
WITH cp as 
(
	SELECT 
	merchant_id
	,to_char(settlement_date,'YYYY-MM') as settlement_month
	,fee_type
	,sum(CASE WHEN cp_or_cnp = 'cp' and type = 'Charge' THEN amount/100 ELSE 0 end) as basis
	FROM dwh.fact_payfac_deposit
	WHERE fee_type = 'Card Present Fee'
	GROUP BY 1,2,3
),

cnp as
(
	SELECT 
	merchant_id
	,to_char(settlement_date,'YYYY-MM') as settlement_month
	,fee_type
	,sum(CASE WHEN cp_or_cnp = 'cnp' and type = 'Charge' THEN amount/100 ELSE 0 end) as basis
	FROM dwh.fact_payfac_deposit
	WHERE fee_type = 'Card Not Present Fee'
	GROUP BY 1,2,3
),

transactions_fee as
(
	SELECT 
	merchant_id
	,to_char(settlement_date,'YYYY-MM') as settlement_month
	,'Transaction Fee' as fee_type
	,sum(CASE WHEN type = 'Charge' THEN 1 ELSE 0 end) as basis
	FROM dwh.fact_payfac_deposit
	WHERE type = 'Charge'
	GROUP BY 1,2,3
),

Chargeback_fee as
(
	SELECT 
	merchant_id
	,to_char(settlement_date,'YYYY-MM') as settlement_month
	,'Chargeback Fee' as fee_type
	,sum(CASE WHEN type = 'Chargeback' THEN 1 ELSE 0 end) as basis
	FROM dwh.fact_payfac_deposit
	WHERE  type = 'Chargeback' 
	GROUP BY 1,2,3
),

main as 
(
	SELECT * FROM cp
	UNION
	SELECT * FROM cnp
	UNION
	SELECT * FROM transactions_fee
	UNION
	SELECT * FROM Chargeback_fee
)

SELECT 
	*
	,CASE WHEN fee_type in ('Card Present Fee','Card Not Present Fee') THEN '$'||basis::varchar  ELSE basis::varchar END as basis_display 
FROM main;

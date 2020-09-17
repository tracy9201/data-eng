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
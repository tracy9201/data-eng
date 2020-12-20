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

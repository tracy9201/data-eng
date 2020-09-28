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

),

date_merchant as
(
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
LEFT JOIN deposit_details a on dt.date = a.settlement_date and dt.merchant_id = a.merchant_id
),

-- This is a placeholder logic, should be changed to pull from the fee table
pci_no_cert_fee as
(
	SELECT distinct
	settlement_date as date
    ,merchant_id,
    ,settlement_date
    ,settlement_month,
    'PCI No Cert Fee' as fee_type,
    20.00::float as total_fee
    from fact_deposit
),

main as 
(
    select 
    a.date,
    ,a.merchant_id
    ,coalesce(a.settlement_date,b.settlement_date) as settlement_date
    ,coalesce(a.settlement_month,b.settlement_month) as settlement_month
    ,a.transactions
    ,a.Charges
    ,a.Refunds
    ,a.Chargebacks
    ,a.Adjustments
    ,coalesce(a.total_fee,0)::float + coalesce(b.total_fee,0)::float as total_fee
    ,a.cp_transaction_amount
    ,a.cnp_transaction_amount
    ,a.Charges_transaction_amount
    ,a.Chargeback_transaction_amount
    ,a.cp_transaction_count
    ,a.cnp_transaction_count
    ,a.Charges_transaction_count
    ,a.Chargeback_transaction_count
    from pdd a 
    left join pci_no_cert_fee b on a.merchant_id = b.merchant_id
    and a.date = b.date
)
select * from main;
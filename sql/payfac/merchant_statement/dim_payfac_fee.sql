DROP TABLE dwh.dim_payfac_fee;

CREATE TABLE dwh.dim_payfac_fee as
SELECT 
	a.id
	,a.fee_type as fee
	,CASE WHEN a.fee_type = 'PCI No Cert Fee' THEN 'Monthly' ELSE 'Transaction' END as fee_type
	,CASE WHEN a.fee_type = 'PCI No Cert Fee' then 'Monthly PCI Cert Fee'
		  WHEN a.fee_type = 'Card Present Fee' then 'Transaction fee when card is present'
		  WHEN a.fee_type = 'Card Not Present Fee' then 'Transaction fee when card is not present' 
		  WHEN a.fee_type = 'Chargeback Fee' then 'Transaction fee on a Chargeback'
		  WHEN a.fee_type = 'Transaction Fee' then 'Transaction fee for each Transaction' end as description
	,a.status
	,a.start_date
	,a.End_date
	,a.service_provider_id
	,b.merchant_id
	,b.fixed_rate
	,b.percentage_rate
	,CASE WHEN b.fixed_rate = 0 THEN b.percentage_rate::varchar||'%' ELSE '$'||b.fixed_rate::varchar END as fee_basis
	,CASE WHEN b.fixed_rate = 0 THEN b.percentage_rate/100 ELSE b.fixed_rate END as fee_basis_calc
FROM payfac.service_provider_fee a 
JOIN payfac.fee_schedule b on a.id = b.service_provider_fee_id;


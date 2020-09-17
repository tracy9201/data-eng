
------------------------------ dim_payfac_date_merchant ------------------------------

DROP TABLE dwh.dim_payfac_date_merchant;

CREATE TABLE dwh.dim_payfac_date_merchant  as 
SELECT 
	a.*
	,b.id as merchant_id
FROM date_table a
CROSS JOIN v4_g_provider b ;


------------------------------ dim_payfac_fee ------------------------------

DROP TABLE dwh.dim_payfac_fee;

CREATE TABLE dwh.dim_payfac_fee as
SELECT 
	a.id
	,a.fee_type as fee
	,CASE WHEN a.fee_type = 'PCI No Cert Fee' THEN 'Monthly' ELSE 'Transaction' END as fee_type
	,'blah blah blah' as description
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


DROP TABLE dwh.dim_payfac_date_merchant;

CREATE TABLE dwh.dim_payfac_date_merchant  as 
SELECT 
	a.*
	,b.id as merchant_id
FROM date_table a
CROSS JOIN v4_g_provider b ;


WITH main as
(SELECT
 	id AS device_id,
 	organization_id,
 	merchant_id,
 	case when label IS NULL or trim(label) = '' then 'N/A' else label end AS label,
 	status,
 	device_uuid,
 	created_at,
    updated_at,
    current_timestamp::timestamp as dwh_created_at
FROM
	p2pe_opul_${environment}.p2pe_device 
)
SELECT * FROM main

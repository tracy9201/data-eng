WITH main as
(SELECT
 	id AS device_id,
 	organization_id,
 	merchant_id,
 	label,
 	status,
 	device_uuid  
FROM
	p2pe_device 
)
SELECT * FROM main;

DELETE FROM p2pe_device;

INSERT INTO p2pe_device
with main as
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
select * from main;

WITH main as
(SELECT
    organization_data.id AS k_practice_id,
    organization_data.gx_provider_id,
    organization_data.activated_at AS practice_activated_at,
    organization_data.timezone AS practice_time_zone,
    users.lastname AS practice_name,
    address.city AS practice_city,
    address.state AS practice_state,
    address.zip AS practice_zip,
    organization_data.merchant_id,
    merchant.type_of_practice,
    contact.email,
    organization_data.created_at,
    organization_data.updated_at,
    current_timestamp::timestamp as dwh_created_at
FROM
    kronos_opul${environment}.organization_data  organization_data
JOIN
    kronos_opul${environment}.users  users        
        ON organization_data.id = organization_id  
JOIN
    kronos_opul${environment}.address  address        
        ON address.id = address_id  
JOIN 
    merchant${environment}.merchant merchant 
        on organization_data.merchant_id = merchant.id
JOIN 
    merchant${environment}.contact contact 
        on contact.merchant_id = organization_data.merchant_id
	
WHERE
    role = 7
    and contact.contact_type = 'DBA'
)
SELECT * FROM main

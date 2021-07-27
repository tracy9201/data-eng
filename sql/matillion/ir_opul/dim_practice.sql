WITH main as
(SELECT
    organization_data.id AS k_practice_id,
    gx_provider_id,
    activated_at AS practice_activated_at,
    timezone AS practice_time_zone,
    lastname AS practice_name,
    city AS practice_city,
    state AS practice_state,
    zip AS practice_zip,
    merchant_id,
    organization_data.created_at,
    organization_data.updated_at,
    current_timestamp::timestamp as dwh_created_at
FROM
    internal_kronos_opul.organization_data  organization_data
JOIN
    internal_kronos_opul.users  users        
        ON organization_data.id = organization_id  
JOIN
    internal_kronos_opul.address  address        
        ON address.id = address_id  
WHERE
    role = 7
)
SELECT * FROM main

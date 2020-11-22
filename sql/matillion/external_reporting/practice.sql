DELETE FROM practice;

INSERT INTO practice
with main as
(SELECT
    organization_data.id AS k_practice_id,
    gx_provider_id,
    activated_at AS practice_activated_at,
    timezone AS practice_time_zone,
    lastname AS practice_name,
    city AS practice_city,
    state AS practice_state,
    zip AS practice_zip  
FROM
    organization_data  
JOIN
    users          
        ON organization_data.id = organization_id  
JOIN
    address          
        ON address.id = address_id  
WHERE
    role = 7
)
select * from main;

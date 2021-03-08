WITH main AS (
SELECT users.id AS user_id,   
    CASE      
        WHEN users.status = 0 THEN 'active'      
        WHEN users.status = 1 THEN 'achived'     
        WHEN users.status = 2 THEN 'pending'      
        END AS status,   
    users.title,   
    users.firstname,   
    users.lastname,   
    CASE      
        WHEN users.role = 1 THEN 'system_admin'      
        WHEN users.role = 2 THEN 'curator'      
        WHEN users.role = 4 THEN 'expert'      
        WHEN users.role = 5 THEN 'expert'      
        WHEN users.role = 6 THEN 'staff'      
        WHEN users.role = 10 THEN 'admin'      
        END AS role,   
    users.email,   
    users.organization_id,   
    users.created_at,   
    users.deprecated_at,    
    users.zendesk_user_id,    
    expert_data.principal AS pricinple_epxert,   
    CASE      
        WHEN expert_data.commission IS NOT NULL THEN round(cast(expert_data.commission as numeric)/100,2)
        WHEN staff_data.commission IS NOT NULL THEN round(cast(staff_data.commission as numeric)/100,2)      
        ELSE NULL      
        END AS commssion_percentage
FROM kronos.users users  
LEFT JOIN kronos.expert_data expert_data 
    ON users.id = expert_data.user_id  
LEFT JOIN kronos.staff_data staff_data 
    ON users.id = staff_data.user_id  
WHERE users.role IN (1,2,4,5,6,10) 
) SELECT * FROM main
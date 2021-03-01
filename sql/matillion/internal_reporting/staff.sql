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
    WHEN role = 1 THEN 'system_admin' 
    WHEN role = 2 THEN 'curator' 
    WHEN role = 4 THEN 'expert' 
    WHEN role = 5 THEN 'expert' 
    WHEN role = 6 THEN 'staff' 
    WHEN role = 10 THEN 'admin' 
    END AS role,
  users.email,
  users.organization_id,
  users.created_at,
  users.deprecated_at, 
  users.zendesk_user_id, 
  principal AS pricinple_epxert,
  CASE 
    WHEN expert_data.commission IS NOT NULL THEN expert_data.commission
    WHEN staff_data.commission IS NOT NULL THEN staff_data.commission 
    ELSE NULL 
    END AS commssion
FROM kronos.users users 
LEFT JOIN kronos.expert_data expert_data ON users.id = expert_data.user_id 
LEFT JOIN kronos.staff_data staff_data ON users.id = staff_data.user_id 
WHERE role IN (1,2,4,5,6,10)
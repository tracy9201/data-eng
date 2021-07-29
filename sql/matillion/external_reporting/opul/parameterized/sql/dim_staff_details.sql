WITH staff_details AS 
(     
  SELECT     
    staff_data.id,     
    staff_data.created_at,     
    staff_data.updated_at,     
    staff_data.deprecated_at,     
    staff_data.status,     
    user_id,     
    commission,     
    'staff' as role_name
  FROM kronos_opul${environment}.staff_data     
), 

sys_admin_details AS 
(     
  SELECT     
    sys_admin_data.id,     
    sys_admin_data.created_at,     
    sys_admin_data.updated_at,     
    sys_admin_data.deprecated_at,     
    sys_admin_data.status,     
    user_id,     
    0 as commission,     
    'sys_admin' as role_name
  FROM kronos_opul${environment}.sys_admin_data     
), 

curator_details AS 
(     
  SELECT     
    curator_data.id,     
    curator_data.created_at,     
    curator_data.updated_at,     
    curator_data.deprecated_at,     
    curator_data.status,     
    user_id,     
    0 as commission,     
    'curator' as role_name
  FROM kronos_opul${environment}.curator_data     
),

expert_details AS 
(     
  SELECT     
    expert_data.id,     
    expert_data.created_at,     
    expert_data.updated_at,     
    expert_data.deprecated_at,     
    expert_data.status,     
    user_id,     
    commission,     
    'expert' as role_name
  FROM kronos_opul${environment}.expert_data     
),

admin_details AS 
(     
  SELECT     
    admin_data.id,     
    admin_data.created_at,     
    admin_data.updated_at,     
    admin_data.deprecated_at,     
    admin_data.status,     
    user_id,     
    commission,     
    'admin' as role_name
  FROM kronos_opul${environment}.admin_data     
),

all_roles as
(
      SELECT * FROM staff_details
      UNION ALL
      SELECT * FROM sys_admin_details
      UNION ALL
      SELECT * FROM curator_details
      UNION ALL
      SELECT * FROM expert_details
      UNION ALL
      SELECT * FROM admin_details
),

main as 
(
    SELECT  
    staff.*,
    users.title,     
    case when users.firstname IS NULL or users.firstname = '' then 'N/A' else users.firstname end as firstname,  
    case when users.lastname IS NULL or users.lastname = '' then '' else users.lastname end as lastname, 
    trim((case when users.title IS NULL or users.title = '' then ' ' else users.title end) || ' ' ||(case when users.firstname IS NULL or users.firstname = '' then 'N/A' else users.firstname end) || ' ' || (case when users.lastname IS NULL or users.lastname = '' then ' ' else users.lastname end)) AS staff_name,
    users.role,
    users.email,     
    users.mobile,     
    users.organization_id,
    current_timestamp::timestamp as dwh_created_at 
    FROM kronos_opul${environment}.users as users
    JOIN all_roles staff on staff.user_id = users.id
)

SELECT * FROM main
WITH staff_details AS (     
  SELECT     
    kronos_opul.staff_data.id,     
    kronos_opul.staff_data.created_at,     
    kronos_opul.staff_data.updated_at,     
    kronos_opul.staff_data.deprecated_at,     
    kronos_opul.staff_data.status,     
    user_id,     
    commission,     
    'staff' as role_name
  FROM kronos_opul.staff_data     
), 
sys_admin_details AS (     
  SELECT     
    kronos_opul.sys_admin_data.id,     
    kronos_opul.sys_admin_data.created_at,     
    kronos_opul.sys_admin_data.updated_at,     
    kronos_opul.sys_admin_data.deprecated_at,     
    kronos_opul.sys_admin_data.status,     
    user_id,     
    0 as commission,     
    'sys_admin' as role_name,
  FROM kronos_opul.sys_admin_data     
) , 
curator_details AS (     
  SELECT     
    kronos_opul.curator_data.id,     
    kronos_opul.curator_data.created_at,     
    kronos_opul.curator_data.updated_at,     
    kronos_opul.curator_data.deprecated_at,     
    kronos_opul.curator_data.status,     
    user_id,     
    0 as commission,     
    'curator' as role_name
  FROM kronos_opul.curator_data     
) , 
expert_details AS (     
  SELECT     
    kronos_opul.expert_data.id,     
    kronos_opul.expert_data.created_at,     
    kronos_opul.expert_data.updated_at,     
    kronos_opul.expert_data.deprecated_at,     
    kronos_opul.expert_data.status,     
    user_id,     
    commission,     
    'expert' as role_name
  FROM kronos_opul.expert_data     
) ,
admin_details AS (     
  SELECT     
    kronos_opul.admin_data.id,     
    kronos_opul.admin_data.created_at,     
    kronos_opul.admin_data.updated_at,     
    kronos_opul.admin_data.deprecated_at,     
    kronos_opul.admin_data.status,     
    user_id,     
    commission,     
    'admin' as role_name
  FROM kronos_opul.admin_data     
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
)
SELECT  
    staff.*,
    title,     
    firstname,     
    lastname,     
    role,
    email,     
    mobile,     
    organization_id 
    from kronos_opul.users
    join all_roles staff on user_id = users.id

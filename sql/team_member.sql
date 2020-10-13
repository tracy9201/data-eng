----- Data Pipeline: v4_k_team_member ---------------------
----- Redshift Table: v4_k_team_member ---------------------
----- Looker View: team_member ---------------------

select id as user_id,
  created_at,
  updated_at,
  deprecated_at,
  status,
  title,
  firstname,
  lastname,
  role,
  email,
  mobile,
  organization_id
from users
where role = 4
  or role = 6
----- Data Pipeline: v4_users ---------------------
----- Redshift Table: v4_users ---------------------
----- Looker View: users ---------------------

SELECT id,
  created_at,
  updated_at,
  deprecated_at,
  status,
  title,
  firstname,
  lastname,
  password,
  salt,
  last_login_attempt_at,
  last_login_at,
  role,
  email,
  mobile,
  organization_id,
  thumbnail,
  color,
  firebase_token,
  invite_sent_date,
  deactivated_date,
  activated_date,
  zendesk_user_id
FROM public.users;
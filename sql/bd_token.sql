----- Data Pipeline: bd_token ---------------------
----- Redshift Table: v4_bd_token ---------------------
----- Looker View: bd_token ---------------------


SELECT id,
  user_id,
  created_at,
  updated_at,
  deprecated_at,
  status,
  token
FROM public.bd_token;
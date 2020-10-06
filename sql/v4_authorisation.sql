----- Data Pipeline: v4_g_authorisation ---------------------
----- Redshift Table: v4_g_authorisation ---------------------
----- Looker View: v4_authorisation ---------------------


SELECT id,
  name,
  object_id,
  object,
  site,
  type,
  status,
  created_at,
  updated_at,
  canceled_at,
  deleted_at
FROM public.v4_g_authorisation;
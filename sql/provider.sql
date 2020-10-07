----- Data Pipeline: v4_g_provider ---------------------
----- Redshift Table: v4_g_provider ---------------------
----- Looker View: provider ---------------------

SELECT id,
  account_id,
  name,
  status,
  created_at,
  updated_at,
  canceled_at,
  deleted_at,
  encrypted_ref_id
FROM public.v4_g_provider;
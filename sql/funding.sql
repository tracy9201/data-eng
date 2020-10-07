----- Data Pipeline: v4_g_funding ---------------------
----- Redshift Table: v4_g_funding ---------------------
----- Looker View: funding ---------------------


SELECT id,
  name,
  payment_gateway_id,
  authorisation_id,
  funding_master_id,
  funding_id,
  net_sales*100,
  third_party*100,
  adjustment*100,
  interchange_fee*100,
  service_charge*100,
  fee*100,
  reversal*100,
  other_adjustment*100,
  total_funding*100,
  funding_date,
  currency,
  dda_number,
  aba_number,
  date_changed,
  date_added,
  deposit_trancode,
  deposit_ach_tracenumber,
  status,
  created_at,
  updated_at,
  canceled_at,
  deleted_at,
  encrypted_ref_id
FROM public.v4_g_funding;
----- Data Pipeline: v4_charge_back ---------------------
----- Redshift Table: v4_charge_back ---------------------
----- Looker View: charge_back ---------------------

SELECT id,
  name,
  payment_gateway_id,
  authorisation_id,
  funding_charge_back_id,
  deposit_date,
  amount,
  transaction_date,
  reason_description,
  reason_code,
  date_changed,
  source_transaction_id,
  transaction_amount,
  charge_back_date,
  sequence_number,
  date_added,
  auth_code,
  funding_master_id,
  case_number,
  acquire_reference_number,
  card_number,
  transaction_id,
  invoice_number,
  status,
  created_at,
  updated_at,
  canceled_at,
  deleted_at,
  encrypted_ref_id
FROM public.v4_g_charge_back;
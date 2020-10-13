----- Data Pipeline: v4_g_gateway_transaction ---------------------
----- Redshift Table: v4_g_gateway_transaction---------------------
----- Looker View: gateway_transaction ---------------------


SELECT id,
  name,
  external_id,
  idempotency_key,
  transaction_id,
  payment_gateway_id,
  invoice_id,
  invoice_item_id,
  card_payment_gateway_id,
  source_object_name,
  source_object_id,
  payment_id,
  amount,
  tendered,
  type,
  reason,
  currency,
  status,
  created_at,
  updated_at,
  canceled_at,
  deleted_at,
  destination_object_name,
  destination_object_id,
  settlement_id,
  entry_mode,
  entry_capability,
  condition_code,
  category_code,
  encrypted_ref_id,
  is_voided,
  gratuity_amount,
  credit_id
FROM public.v4_g_gateway_transaction;

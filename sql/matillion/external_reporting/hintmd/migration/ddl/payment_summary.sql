DROP TABLE IF EXISTS dwh_hint${environment}.payment_summary;
CREATE TABLE IF NOT EXISTS dwh_hint${environment}.payment_summary (
  sales_id varchar(255) ENCODE RAW,
  sales_name varchar(65535) ENCODE RAW,
  sales_amount numeric ENCODE RAW,
  sales_type varchar(16) ENCODE RAW,
  sales_status bigint ENCODE RAW,
  sales_created_at timestamp without time zone ENCODE RAW,
  gx_customer_id varchar(64) ENCODE RAW,
  gx_provider_id varchar(64) ENCODE RAW,
  transaction_id varchar(255) ENCODE RAW,
  payment_id varchar(255) ENCODE RAW,
  tokenization varchar(255) ENCODE RAW,
  gx_subscription_id varchar(64) ENCODE RAW,
  staff_user_id varchar(64) ENCODE RAW,
  device_id varchar(255) ENCODE RAW,
  gratuity_amount numeric ENCODE RAW,
  is_voided varchar(10) ENCODE RAW
) DISTKEY(id);

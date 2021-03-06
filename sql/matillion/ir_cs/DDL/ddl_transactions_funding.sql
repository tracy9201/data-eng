DROP 
  TABLE IF EXISTS internal_reporting_hint.transactions_funding;
CREATE TABLE IF NOT EXISTS internal_reporting_hint.transactions_funding (
  transaction_id VARCHAR(64) ENCODE raw, 
  status VARCHAR(64) ENCODE raw, 
  user_id BIGINT ENCODE raw, 
  payment_method VARCHAR(max) ENCODE raw, 
  transaction VARCHAR(max) ENCODE raw, 
  amount NUMERIC(18, 2) ENCODE raw, 
  device_id VARCHAR(64) ENCODE raw, 
  created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw, 
  updated_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw, 
  created_by BIGINT ENCODE raw, 
  gratuity_amount NUMERIC(18, 2) ENCODE raw, 
  customer_type VARCHAR(64) ENCODE raw, 
  payment_detail VARCHAR(max) ENCODE raw, 
  gx_provider_id VARCHAR(max) ENCODE raw, 
  clover_transaction_id VARCHAR(64) ENCODE raw, 
  dwh_created_at timestamp,
  primary key(transaction_id)
);

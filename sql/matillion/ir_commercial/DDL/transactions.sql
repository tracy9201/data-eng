DROP TABLE IF EXISTS ir_commercial.transactions;

CREATE TABLE IF NOT EXISTS ir_commercial.transactions
(
  transaction_id VARCHAR(64)  ENCODE raw
  ,status VARCHAR(64)   ENCODE raw
  ,user_id BIGINT  ENCODE raw
  ,payment_method VARCHAR(max)   ENCODE raw
  ,transaction VARCHAR(max)   ENCODE raw
  ,amount NUMERIC(18,2)   ENCODE raw
  ,device_id VARCHAR(64)  ENCODE raw
  ,created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,updated_at  TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,created_by  BIGINT   ENCODE raw
  ,gratuity_amount  NUMERIC(18,2)   ENCODE raw
  ,customer_type VARCHAR(64)   ENCODE raw
  ,payment_detail VARCHAR(max)   ENCODE raw
  ,primary key(transaction_id)
)
;
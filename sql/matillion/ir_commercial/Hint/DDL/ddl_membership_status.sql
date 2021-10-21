DROP TABLE IF EXISTS ir_commercial.membership_status;

CREATE TABLE IF NOT EXISTS ir_commercial.membership_status
(
  id bigint ENCODE raw
  ,created_date DATE   ENCODE raw
  ,updated_date DATE  ENCODE raw
  ,status VARCHAR(64)   ENCODE raw
  ,gx_customer_id VARCHAR(64)   ENCODE raw
  ,gx_provider_id VARCHAR(64)   ENCODE raw
  ,num_days_as_active bigint ENCODE raw
  ,days_since_creation bigint ENCODE raw
  ,membership_length bigint ENCODE raw
  ,primary key(id)
)
;
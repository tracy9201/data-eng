DROP TABLE IF EXISTS ir_commercial.member_status_other;
CREATE TABLE IF NOT EXISTS ir_commercial.member_status_other
(
  id bigint ENCODE raw
  ,gx_customer_id VARCHAR(64)   ENCODE raw
  ,catalog VARCHAR(255) ENCODE raw
  ,category VARCHAR(255) ENCODE raw
  ,created_date DATE   ENCODE raw
  ,updated_date DATE  ENCODE raw
  ,status VARCHAR(64)   ENCODE raw
  ,gx_provider_id VARCHAR(64)   ENCODE raw
  ,primary key(id)
)
;
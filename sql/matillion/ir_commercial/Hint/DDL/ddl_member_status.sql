DROP TABLE IF EXISTS ir_commercial.member_status;

CREATE TABLE IF NOT EXISTS ir_commercial.member_status
(
  id bigint ENCODE raw
  ,gx_customer_id VARCHAR(64)   ENCODE raw
  ,created_date DATE   ENCODE raw
  ,updated_date DATE  ENCODE raw
  ,status VARCHAR(64)   ENCODE raw
  ,gx_provider_id VARCHAR(64)   ENCODE raw
  ,updated_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,primary key(id)
)
;
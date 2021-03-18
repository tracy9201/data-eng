DROP TABLE IF EXISTS ir_commercial.member_status;

CREATE TABLE IF NOT EXISTS ir_commercial.member_status
(
  id BIGINT  ENCODE raw
  ,user_id BIGINT  ENCODE raw
  ,created_date DATE   ENCODE raw
  ,updated_date DATE  ENCODE raw
  ,status VARCHAR(64)   ENCODE raw
  ,gx_customer_id VARCHAR(64)   ENCODE raw
  ,gx_provider_id VARCHAR(64)   ENCODE raw
  ,primary key(id)
)
DISTKEY (id)
SORTKEY (id)
;
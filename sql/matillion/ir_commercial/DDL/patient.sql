DROP TABLE IF EXISTS ir_commercial.patient

CREATE TABLE IF NOT EXISTS ir_commercial.patient
(
  gx_customer_id VARCHAR(64)    ENCODE raw
  ,patient_type VARCHAR(64)    ENCODE raw
  ,gender VARCHAR(16)    ENCODE raw
  ,organization_id BIGINT  ENCODE raw
  ,firstname  VARCHAR(64)    ENCODE raw
  ,user_id BIGINT  ENCODE raw
  ,birth_year integer ENCODE raw
  ,city VARCHAR(64)    ENCODE raw
  ,state VARCHAR(64)    ENCODE raw
  ,created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,deprecated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,primary key(gx_customer_id)
)
;
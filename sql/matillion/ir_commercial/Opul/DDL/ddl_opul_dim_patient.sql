DROP TABLE IF EXISTS ir_commercial_opul.opul_dim_patient;

CREATE TABLE IF NOT EXISTS ir_commercial_opul.opul_dim_patient
(
  gx_customer_id VARCHAR(64)    ENCODE raw
  ,patient_type VARCHAR(64)    ENCODE raw
  ,gender VARCHAR(16)    ENCODE raw
  ,gx_provider_id VARCHAR(64)  ENCODE raw
  ,birth_year integer ENCODE raw
  ,city VARCHAR(64)    ENCODE raw
  ,state VARCHAR(64)    ENCODE raw
  ,created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,deprecated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,updated_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,primary key(gx_customer_id)
)
;
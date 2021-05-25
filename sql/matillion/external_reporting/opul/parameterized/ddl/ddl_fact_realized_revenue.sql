DROP TABLE IF EXISTS dwh_opul${environment}.fact_realized_revenue;

CREATE TABLE IF NOT EXISTS dwh_opul${environment}.fact_realized_revenue
(
  ful_id VARCHAR(16) ENCODE raw
  ,ful_name VARCHAR(max) ENCODE raw
  ,service_date TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,ful_quantity  NUMERIC(18,2) ENCODE raw
  ,unit_name VARCHAR(64) ENCODE raw
  ,quantity  NUMERIC(18,2) ENCODE raw
  ,total NUMERIC(18,2) ENCODE raw
  ,offering_id BIGINT ENCODE raw
  ,ful_status SMALLINT ENCODE raw
  ,ful_type VARCHAR(64) ENCODE raw
  ,fulfilled_by BIGINT ENCODE raw
  ,subscription_id  BIGINT ENCODE raw
  ,gx_customer_id VARCHAR(64) ENCODE raw
  ,gx_provider_id VARCHAR(64) ENCODE raw
  ,epoch_created_at BIGINT   ENCODE raw
  ,created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,updated_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,primary key(ful_id)
  ,UNIQUE(ful_id, updated_at)
)
DISTKEY (gx_provider_id)
SORTKEY (epoch_created_at,gx_provider_id,gx_customer_id,fulfilled_by)
;
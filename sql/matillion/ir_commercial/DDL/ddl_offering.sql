DROP TABLE IF EXISTS ir_commercial.offering;

CREATE TABLE IF NOT EXISTS ir_commercial.offering
(
  offering_id BIGINT   ENCODE raw
  ,offering_name VARCHAR(MAX)   ENCODE raw
  ,catalog_name VARCHAR(MAX)   ENCODE raw
  ,catalog_id BIGINT   ENCODE raw
  ,factory_name VARCHAR(max)   ENCODE raw
  ,factory_id BIGINT   ENCODE raw
  ,offering_pay_in_full_price NUMERIC(18,2)   ENCODE raw
  ,offering_subscription_price NUMERIC(18,2)  ENCODE raw
  ,offering_pay_over_time_price NUMERIC(18,2)   ENCODE raw
  ,offering_service_tax NUMERIC(18,2)   ENCODE raw
  ,offering_status integer   ENCODE raw
  ,gx_provider_id varchar(64)   ENCODE raw
  ,offering_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,catalog_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,catalog_status integer  ENCODE raw
  ,catalog_wholesale_price  NUMERIC(18,2) ENCODE raw
  ,bd_status integer  ENCODE raw
  ,brand_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,primary key(offering_id)
)
;
DROP TABLE IF EXISTS ir_commercial_opul.opul_fact_fulfillment;

CREATE TABLE IF NOT EXISTS ir_commercial_opul.opul_fact_fulfillment
(
  fulfillment_id varchar(64) ENCODE raw
  ,created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,deprecated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,canceled_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,status VARCHAR(64)   ENCODE raw
  ,quantity_rendered NUMERIC(18,2)   ENCODE raw
  ,next_service_date TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,service_date TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,value  NUMERIC(18,2)   ENCODE raw
  ,tax_value  NUMERIC(18,2)   ENCODE raw
  ,shipping_cost  NUMERIC(18,2)   ENCODE raw
  ,type VARCHAR(64)   ENCODE raw
  ,name VARCHAR(max)   ENCODE raw
  ,offering_id varchar(64) ENCODE raw
  ,gx_customer_id varchar(64) ENCODE raw
  ,gx_provider_id varchar(64) ENCODE raw
  ,gx_subscription_id varchar(64) ENCODE raw
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,primary key(fulfillment_id)
)
;
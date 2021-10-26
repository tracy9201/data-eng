DROP TABLE IF EXISTS ir_commercial_opul.opul_fact_subscription;

CREATE TABLE IF NOT EXISTS ir_commercial_opul.opul_fact_subscription
(
  gx_subscription_id varchar(64) ENCODE raw
  ,units INTEGER ENCODE raw
  ,unit_type VARCHAR(20) ENCODE raw
  ,price_unit NUMERIC(18,2)   ENCODE raw
  ,subscription_cycle INTEGER   ENCODE raw
  ,total_price INTEGER   ENCODE raw
  ,recurring_cycle INTEGER   ENCODE raw
  ,subscription_type INTEGER   ENCODE raw
  ,offering_id varchar(64) ENCODE raw
  ,subscription_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,subscription_canceled_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,subscription_updated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,gx_customer_id varchar(64) ENCODE raw
  ,gx_provider_id varchar(64) ENCODE raw
  ,updated_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,primary key(gx_subscription_id)

);
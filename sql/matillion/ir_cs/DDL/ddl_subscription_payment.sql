DROP TABLE IF EXISTS ir_cs.subscription_payment;

CREATE TABLE IF NOT EXISTS ir_cs.subscription_payment
(
  gx_subscription_id VARCHAR(64) ENCODE raw
  ,units INTEGER ENCODE raw
  ,unit_type VARCHAR(20) ENCODE raw
  ,price_unit NUMERIC(18,2)   ENCODE raw
  ,subscription_cycle INTEGER   ENCODE raw
  ,total_price INTEGER   ENCODE raw
  ,recurring_cycle INTEGER   ENCODE raw
  ,subscription_type INTEGER   ENCODE raw
  ,offering_id bigint   ENCODE raw
  ,subscription_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,subscription_canceled_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,subscription_updated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,gx_customer_id VARCHAR(64) ENCODE raw
  ,gx_provider_id VARCHAR(64) ENCODE raw
  ,invoice_pay_date date ENCODE raw
  ,ad_hoc_offering_id bigint ENCODE raw
  ,total_paid_tax  NUMERIC(18,2)    ENCODE raw
  ,total_discounted NUMERIC(18,2)    ENCODE raw
  ,total_paid  NUMERIC(18,2)    ENCODE raw
  ,primary key(gx_subscription_id)

);
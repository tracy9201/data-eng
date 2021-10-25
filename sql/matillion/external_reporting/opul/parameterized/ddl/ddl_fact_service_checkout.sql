DROP TABLE IF EXISTS dwh_opul${environment}.fact_service_checkout;

CREATE TABLE IF NOT EXISTS dwh_opul${environment}.fact_service_checkout
(
  invoice_item_id BIGINT  ENCODE raw
  ,units NUMERIC(18,2)   ENCODE raw
  ,price_unit NUMERIC(18,2)   ENCODE raw
  ,total_price NUMERIC(18,2)   ENCODE raw
  ,item_discount NUMERIC(18,2)   ENCODE raw
  ,discount_amts NUMERIC(18,2)   ENCODE raw
  ,discount_reason VARCHAR(max) ENCODE raw
  ,discounted_price NUMERIC(18,2)   ENCODE raw
  ,ground_total NUMERIC(18,2)   ENCODE raw
  ,offering_id BIGINT  ENCODE raw
  ,gx_customer_id VARCHAR(32)   ENCODE raw
  ,gx_provider_id VARCHAR(32)   ENCODE raw
  ,dwh_created_at  TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,primary key(invoice_item_id)
  ,UNIQUE(invoice_item_id, subscription_updated_at)
)
DISTKEY (gx_provider_id)
SORTKEY (gx_provider_id,offering_id,gx_customer_id)
;
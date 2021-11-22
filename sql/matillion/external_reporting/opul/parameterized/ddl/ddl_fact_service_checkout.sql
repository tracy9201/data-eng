DROP TABLE IF EXISTS dwh_opul${environment}.fact_service_checkout;

CREATE TABLE IF NOT EXISTS dwh_opul${environment}.fact_service_checkout
(
  invoice_item_id BIGINT  ENCODE raw
  ,pay_date TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,units NUMERIC(18,2)   ENCODE raw
  ,unit_type VARCHAR(64)   ENCODE raw
  ,price_unit NUMERIC(18,2)   ENCODE raw
  ,total_price NUMERIC(18,2)   ENCODE raw
  ,item_discount NUMERIC(18,2)   ENCODE raw
  ,discount_reason VARCHAR(max) ENCODE raw
  ,discounted_price NUMERIC(18,2)   ENCODE raw
  ,tax NUMERIC(18,2)   ENCODE raw
  ,grand_total NUMERIC(18,2)   ENCODE raw
  ,offering_id VARCHAR(32)   ENCODE raw
  ,gx_customer_id VARCHAR(32)   ENCODE raw
  ,gx_provider_id VARCHAR(32)   ENCODE raw
  ,epoch_pay_date  BIGINT   ENCODE raw
  ,dwh_created_at  TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,primary key(invoice_item_id)
  ,UNIQUE(invoice_item_id, pay_date)
)
DISTKEY (gx_provider_id)
SORTKEY (gx_provider_id,offering_id,gx_customer_id)
;
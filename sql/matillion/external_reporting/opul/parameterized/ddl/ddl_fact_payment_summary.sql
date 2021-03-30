DROP TABLE IF  EXISTS dwh_opul${environment}.fact_payment_summary;

CREATE TABLE IF NOT EXISTS dwh_opul${environment}.fact_payment_summary
(
  sales_id VARCHAR(255)   ENCODE raw
  ,sales_name VARCHAR(MAX)   ENCODE raw
  ,sales_amount NUMERIC(18,2)   ENCODE raw
  ,sales_type VARCHAR(16)   ENCODE raw
  ,sales_status BIGINT   ENCODE raw
  ,sales_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,gx_customer_id VARCHAR(64)   ENCODE zstd
  ,gx_provider_id VARCHAR(64)   ENCODE zstd
  ,transaction_id VARCHAR(255) ENCODE raw
  ,payment_id VARCHAR(255)   ENCODE raw
  ,tokenization VARCHAR(255)   ENCODE raw
  ,card_brand VARCHAR(255) ENCODE raw
  ,token_substr VARCHAR(8) ENCODE raw
  ,gx_subscription_id  VARCHAR(64)   ENCODE raw
  ,staff_user_id VARCHAR(64)   ENCODE raw
  ,device_id VARCHAR(255)   ENCODE raw
  ,gratuity_amount NUMERIC(18,2)   ENCODE raw
  ,is_voided VARCHAR(10) ENCODE raw
  ,card_holder_name VARCHAR(255) ENCODE raw
  ,inv_id VARCHAR(10) ENCODE raw
  ,inv_status SMALLINT ENCODE raw
  ,created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,updated_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,primary key(sales_id)
  ,UNIQUE(sales_id, updated_at)
)
DISTKEY (gx_customer_id)
SORTKEY (gx_customer_id)
;
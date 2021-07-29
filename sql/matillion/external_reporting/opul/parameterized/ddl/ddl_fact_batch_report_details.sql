DROP TABLE IF EXISTS dwh_opul${environment}.fact_batch_report_details;

CREATE TABLE IF NOT EXISTS dwh_opul${environment}.fact_batch_report_details
(
  subscription_name VARCHAR(MAX) ENCODE raw
  ,user_type INTEGER ENCODE raw
  ,is_voided VARCHAR(10) ENCODE raw
  ,sales_id VARCHAR(255)   ENCODE raw
  ,transaction VARCHAR(128)   ENCODE raw
  ,payment_method VARCHAR(128)   ENCODE raw
  ,card_brand VARCHAR(255)   ENCODE raw
  ,payment_detail VARCHAR(128)   ENCODE raw
  ,description VARCHAR(MAX) ENCODE raw
  ,payment_id VARCHAR(MAX)   ENCODE raw
  ,gx_customer_id VARCHAR(255)   ENCODE raw
  ,gx_provider_id  VARCHAR(255)   ENCODE raw
  ,transaction_id VARCHAR(255)   ENCODE raw
  ,sales_created_at  TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,original_sales_created_at  TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,staff_user_id VARCHAR(255) ENCODE raw
  ,device_id VARCHAR(255)   ENCODE raw
  ,tokenization VARCHAR(255)   ENCODE raw
  ,sales_amount NUMERIC(18,2)   ENCODE raw
  ,gratuity_amount NUMERIC(18,2)   ENCODE raw
  ,card_holder_name VARCHAR(MAX) ENCODE raw
  ,epoch_sales_created_at  BIGINT   ENCODE raw
  ,epoch_original_sales_created_at  BIGINT  ENCODE raw
  ,category VARCHAR(4) ENCODE raw
  ,firstname VARCHAR(255)   ENCODE raw
  ,lastname VARCHAR(255)   ENCODE raw
  ,created_at  TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,updated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,primary key(sales_id)
  ,UNIQUE(sales_id, updated_at)
)
DISTKEY (gx_provider_id)
SORTKEY (epoch_sales_created_at,gx_provider_id,gx_customer_id,staff_user_id,device_id,sales_id,category)
;
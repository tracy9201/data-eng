DROP TABLE IF EXISTS dwh_opul_${environment}.fact_batch_report_summary;

CREATE TABLE IF NOT EXISTS dwh_opul_${environment}.fact_batch_report_summary
(
  is_voided VARCHAR(10) ENCODE raw
  ,sales_id VARCHAR(255)   ENCODE raw
  ,sales_type VARCHAR(255)   ENCODE raw
  ,transaction VARCHAR(128)   ENCODE raw
  ,payment_method VARCHAR(128)   ENCODE raw
  ,payment_detail VARCHAR(128)   ENCODE raw
  ,payment_id VARCHAR(MAX)   ENCODE raw
  ,gx_customer_id VARCHAR(MAX)   ENCODE zstd
  ,gx_provider_id VARCHAR(MAX)   ENCODE raw
  ,original_sales_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,staff_user_id VARCHAR(255) ENCODE raw
  ,device_id VARCHAR(255)   ENCODE raw
  ,sales_amount NUMERIC(18,2)   ENCODE raw
  ,gratuity_amount NUMERIC(18,2)   ENCODE raw
  ,epoch_sales_created_at BIGINT ENCODE raw
  ,epoch_original_sales_created_at BIGINT ENCODE raw
  ,category VARCHAR(4) ENCODE raw
  ,created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,updated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,primary key(sales_id)
  ,UNIQUE(sales_id, updated_at)
)
DISTKEY (gx_provider_id)
SORTKEY (gx_provider_id,epoch_sales_created_at,payment_method,category,device_id)
;
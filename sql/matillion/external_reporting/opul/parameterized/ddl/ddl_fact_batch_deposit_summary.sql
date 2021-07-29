DROP TABLE IF EXISTS dwh_opul${environment}.fact_batch_deposit_summary;   

CREATE TABLE IF NOT EXISTS dwh_opul${environment}.fact_batch_deposit_summary
( reference_id VARCHAR(255) ENCODE raw
  ,merchant_id VARCHAR(255) ENCODE raw
  ,batch_date  TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,settled_at_date  TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,adjustments NUMERIC(18,2)   ENCODE raw
  ,fees NUMERIC(18,2)   ENCODE raw
  ,net_sales NUMERIC(18,2)   ENCODE raw
  ,chargebacks NUMERIC(18,2)   ENCODE raw
  ,epoch_batch_date BIGINT ENCODE raw
  ,epoch_settled_at_date BIGINT ENCODE raw
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,primary key(reference_id)
  ,UNIQUE(reference_id)  
)
DISTKEY(merchant_id)  
SORTKEY(merchant_id, settled_at_date, epoch_batch_date);
DROP TABLE IF EXISTS dwh_opul_${environment}.fact_deposit_summary;   

CREATE TABLE IF NOT EXISTS dwh_opul_${environment}.fact_deposit_summary
( reference_id VARCHAR(255) ENCODE raw
  ,merchant_id VARCHAR(255) ENCODE raw
  ,funding_date  TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,adjustments NUMERIC(18,2)   ENCODE raw
  ,fees NUMERIC(18,2)   ENCODE raw
  ,net_sales NUMERIC(18,2)   ENCODE raw
  ,chargebacks NUMERIC(18,2)   ENCODE raw
  ,epoch_funding_date BIGINT ENCODE raw
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,primary key(reference_id)
  ,UNIQUE(reference_id)  
)
DISTKEY(merchant_id)  
SORTKEY(merchant_id, funding_date);
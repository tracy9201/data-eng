DROP TABLE IF EXISTS dwh_hint.fact_deposit_summary;

CREATE TABLE IF NOT EXISTS dwh_hint.fact_deposit_summary
( gx_provider_id VARCHAR(255) ENCODE raw
  ,funding_master_id VARCHAR(255) ENCODE raw
  ,fees NUMERIC(18,2)   ENCODE raw
  ,adjustments NUMERIC(18,2)   ENCODE raw
  ,net_sales NUMERIC(18,2)   ENCODE raw
  ,total_funding NUMERIC(18,2)   ENCODE raw
  ,funding_date TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,date_added TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,chargebacks NUMERIC(18,2)   ENCODE raw
  ,status INTEGER ENCODE raw
  ,funding_id BIGINT ENCODE raw
  ,primary key(funding_master_id)
  ,UNIQUE(funding_master_id)
)
DISTKEY(gx_provider_id)
SORTKEY(gx_provider_id, funding_date);

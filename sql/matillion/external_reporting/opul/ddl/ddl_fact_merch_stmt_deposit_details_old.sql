DROP TABLE IF EXISTS dwh_opul.fact_merch_stmt_deposit_details;

CREATE TABLE IF NOT EXISTS dwh_opul.fact_merch_stmt_deposit_details
(
funding_date DATE ENCODE raw 
,funding_month  DATE ENCODE raw
,merchant_id VARCHAR(256)   ENCODE raw
,transactions INTEGER ENCODE raw
,charges NUMERIC(18,2)   ENCODE raw
,refunds NUMERIC(18,2)   ENCODE raw
,chargebacks NUMERIC(18,2)   ENCODE raw
,adjustments NUMERIC(18,2)   ENCODE raw
,fees NUMERIC(18,2)   ENCODE raw
,epoch_funding_date  BIGINT   ENCODE raw
,epoch_funding_month  BIGINT  ENCODE raw
,dwh_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw 
,PRIMARY KEY(merchant_id,funding_date)
)
DISTKEY (merchant_id)
SORTKEY (merchant_id,funding_date)
;

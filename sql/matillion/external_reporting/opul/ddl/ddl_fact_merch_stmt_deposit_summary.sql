DROP TABLE IF EXISTS dwh_opul.fact_merch_stmt_deposit_summary;

CREATE TABLE IF NOT EXISTS dwh_opul.fact_merch_stmt_deposit_summary
(
 merchant_id VARCHAR(256)   ENCODE raw
,funding_month DATE ENCODE raw
,range VARCHAR(256)   ENCODE raw
,range_with_year VARCHAR(256)   ENCODE raw
,transactions INTEGER ENCODE raw
,charges NUMERIC(18,2)   ENCODE raw
,refunds NUMERIC(18,2)   ENCODE raw
,chargebacks NUMERIC(18,2)   ENCODE raw
,adjustments NUMERIC(18,2)   ENCODE raw
,total_fees NUMERIC(18,2)   ENCODE raw
,revenue NUMERIC(18,2)   ENCODE raw
,epoch_funding_month  BIGINT  ENCODE raw
,dwh_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw 
,PRIMARY KEY(merchant_id,range)
)
DISTKEY (merchant_id)
SORTKEY (merchant_id,range)
;


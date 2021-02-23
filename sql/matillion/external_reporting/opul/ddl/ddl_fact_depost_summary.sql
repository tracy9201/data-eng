drop table dwh_opul.fact_deposit_summary;

CREATE TABLE IF NOT EXISTS dwh_opul.fact_deposit_summary
(
		reference_id VARCHAR(255) encode raw
    ,merchant_id VARCHAR(255) encode raw
    ,settled_date  TIMESTAMP WITHOUT TIME ZONE encode raw
    ,adjustments NUMERIC(18,0)   ENCODE raw
    ,fees NUMERIC(18,0)   ENCODE raw
    ,net_sales NUMERIC(18,0)   ENCODE raw
    ,chargebacks NUMERIC(18,0)   ENCODE raw
		,epoch_settled_date BIGINT
			,primary key(reference_id)
			,UNIQUE(reference_id)
)
DISTSTYLE(merchant_id)
SORTKEY(merchant_id, settled_date)
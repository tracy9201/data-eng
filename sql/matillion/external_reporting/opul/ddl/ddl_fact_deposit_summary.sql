drop table dwh_opul.fact_deposit_summary;

CREATE TABLE IF NOT EXISTS dwh_opul.fact_deposit_summary
(
    reference_id VARCHAR(255) ENCODE raw
    ,merchant_id VARCHAR(255) ENCODE raw
    ,settled_date  TIMESTAMP WITHOUT TIME ZONE ENCODE raw
    ,adjustments NUMERIC(18,0)   ENCODE raw
    ,fees NUMERIC(18,0)   ENCODE raw
    ,net_sales NUMERIC(18,0)   ENCODE raw
    ,chargebacks NUMERIC(18,0)   ENCODE raw
    ,epoch_settled_date BIGINT ENCODE raw
			,primary key(reference_id)
			,UNIQUE(reference_id)
)
DISTKEY(merchant_id)
SORTKEY(merchant_id, settled_date);
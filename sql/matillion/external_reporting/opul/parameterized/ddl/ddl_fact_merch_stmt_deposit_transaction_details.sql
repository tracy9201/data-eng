DROP TABLE IF EXISTS dwh_opul${environment}.fact_merch_stmt_deposit_transaction_details;
CREATE TABLE IF NOT EXISTS  dwh_opul${environment}.fact_merch_stmt_deposit_transaction_details 
(
merchant_id VARCHAR(256)   ENCODE raw
,funding_instruction_id INTEGER  ENCODE raw
,transaction_id VARCHAR(256)   ENCODE raw
,transaction_type VARCHAR(256)   ENCODE raw
,transaction_date TIMESTAMP WITHOUT TIME ZONE   ENCODE raw 
,transactions INTEGER ENCODE raw
,charges NUMERIC(18,2)   ENCODE raw
,refunds NUMERIC(18,2)   ENCODE raw
,chargebacks NUMERIC(18,2)   ENCODE raw
,adjustments NUMERIC(18,2)   ENCODE raw
,fees NUMERIC(18,6)   ENCODE raw
,non_transaction_fee NUMERIC(18,6)   ENCODE raw
,cp_or_cnp  VARCHAR(20)   ENCODE raw
,card_brand  VARCHAR(256)   ENCODE raw
,percent_fee NUMERIC(18,2)   ENCODE raw
,ft_percent_fee NUMERIC(18,2)   ENCODE raw
,funding_date DATE ENCODE RAW
,funding_month DATE ENCODE RAW
,last4 VARCHAR(20)   ENCODE raw
,epoch_funding_date  BIGINT   ENCODE raw
,epoch_funding_month  BIGINT  ENCODE raw
,dwh_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw 
,PRIMARY KEY(transaction_id)
)
DISTKEY (merchant_id)
SORTKEY (merchant_id,funding_date)
;


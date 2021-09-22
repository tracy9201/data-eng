DROP TABLE IF EXISTS dwh_opul${environment}.fact_merch_stmt_deposit_transaction_details;
CREATE TABLE IF NOT EXISTS  dwh_opul${environment}.fact_merch_stmt_deposit_transaction_details 
(
merchant_id VARCHAR(256)   ENCODE raw
,funding_instruction_id INTEGER  ENCODE raw
,transaction_id VARCHAR(256)   ENCODE raw
,transaction_date TIMESTAMP WITHOUT TIME ZONE   ENCODE raw 
,transaction_type VARCHAR(64)   ENCODE raw
,transaction_amount NUMERIC(18,2)   ENCODE raw
,cp_or_cnp  VARCHAR(20)   ENCODE raw
,funding_date DATE ENCODE RAW
,settled_at_date TIMESTAMP WITHOUT TIME ZONE   ENCODE raw 
,card_brand  VARCHAR(20)   ENCODE raw
,subscriber VARCHAR(64)   ENCODE raw
,gx_customer_id VARCHAR(64)   ENCODE raw
,payment_id VARCHAR(64)   ENCODE raw
,epoch_transaction_date  BIGINT   ENCODE raw
,epoch_funding_date  BIGINT   ENCODE raw
,epoch_settled_at_date  BIGINT  ENCODE raw
,dwh_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw 
,PRIMARY KEY(transaction_id)
)
DISTKEY (merchant_id)
SORTKEY (merchant_id,funding_date)
;


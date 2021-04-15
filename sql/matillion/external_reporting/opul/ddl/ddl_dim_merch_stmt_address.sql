DROP TABLE IF EXISTS dwh_opul.dim_merch_stmt_address;

CREATE TABLE IF NOT EXISTS dwh_opul.dim_merch_stmt_address
(
merchant_id VARCHAR(256)   ENCODE raw
,merchant_name 	VARCHAR(2000)   ENCODE raw
,address1 VARCHAR(256)   ENCODE raw
,address2  VARCHAR(256)   ENCODE raw
,city  VARCHAR(256)   ENCODE raw
,state  VARCHAR(256)   ENCODE raw
,country  VARCHAR(256)   ENCODE raw
,zip  VARCHAR(15)   ENCODE raw
,zip2 VARCHAR(15)   ENCODE raw
,full_address VARCHAR(2000)   ENCODE raw
,is_latest_address VARCHAR(1)   ENCODE raw
,created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw 
,updated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw 
,deprecated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw 
,dwh_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw 
,PRIMARY KEY(merchant_id)
)
DISTSTYLE ALL
SORTKEY (merchant_id,zip)
;

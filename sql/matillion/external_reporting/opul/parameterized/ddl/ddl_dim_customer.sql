DROP TABLE IF EXISTS dwh_opul_{environment}.dim_customer;

CREATE TABLE IF NOT EXISTS dwh_opul_{environment}.dim_customer
(
  k_customer_id BIGINT   ENCODE raw
  ,member_on_boarding_date TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,member_cancel_date TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,customer_email VARCHAR(255)   ENCODE raw
  ,customer_mobile VARCHAR(MAX)   ENCODE raw
  ,customer_gender SMALLINT   ENCODE raw
  ,customer_birth_year NUMERIC(18,0)   ENCODE raw
  ,gx_customer_id VARCHAR(max)   ENCODE raw 
  ,member_type VARCHAR(16)   ENCODE raw
  ,customer_city VARCHAR(64)   ENCODE raw
  ,customer_state VARCHAR(MAX)   ENCODE raw
  ,customer_zip VARCHAR(16)   ENCODE raw
  ,user_type INTEGER  ENCODE raw
  ,customer_type VARCHAR(MAX) ENCODE raw
  ,firstname VARCHAR(MAX)   ENCODE raw
  ,lastname  VARCHAR(MAX)  ENCODE raw
  ,created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,updated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,primary key(k_customer_id)
  ,UNIQUE(gx_customer_id, updated_at)
)
DISTKEY (gx_customer_id)
SORTKEY (gx_customer_id,user_type)
;
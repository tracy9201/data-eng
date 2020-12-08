CREATE TABLE IF NOT EXISTS matillion_dwh.dim_customer
(
	k_customer_id BIGINT   ENCODE lzo
	,member_on_boarding_date DATE   ENCODE lzo
	,member_cancel_date DATE   ENCODE lzo
	,customer_email VARCHAR(255)   ENCODE lzo
	,customer_mobile VARCHAR(32)   ENCODE lzo
	,customer_gender SMALLINT   ENCODE lzo
	,customer_birth_year NUMERIC(18,0)   ENCODE lzo
	,gx_customer_id VARCHAR(64)   ENCODE lzo
	,member_type VARCHAR(16)   ENCODE lzo
	,customer_city VARCHAR(64)   ENCODE lzo
	,customer_state VARCHAR(32)   ENCODE lzo
	,customer_zip VARCHAR(16)   ENCODE lzo
  ,user_type INTEGER  ENCODE lzo
	,firstname VARCHAR(64)   ENCODE lzo
	,lastname  VARCHAR(64)  ENCODE lzo
        ,primary key(k_customer_id)
        ,UNIQUE(gx_customer_id)
)
DISTSTYLE EVEN
;

----------------------

CREATE TABLE IF NOT EXISTS matillion_dwh.dim_kronos_subscription
(
	subscription_id BIGINT SORTKEY ENCODE lzo
	,Status INTEGER ENCODE lzo
	,cycles  INTEGER  ENCODE lzo
	,quantity  INTEGER  ENCODE lzo
	,is_subscription  boolean
	,period_unit INTEGER ENCODE lzo
	,period  INTEGER  ENCODE lzo
	,gx_subscription_id VARCHAR(255)  ENCODE lzo
	,plan_id  BIGINT  ENCODE lzo
  ,offering_id  BIGINT  ENCODE lzo
  ,subscription_type  INTEGER   ENCODE lzo
  ,  primary key(subscription_id)
)
DISTSTYLE EVEN;
-------------------------
CREATE TABLE IF NOT EXISTS matillion_dwh.dim_p2pe_device
(
	device_id BIGINT  SORTKEY ENCODE lzo
	,organization_id BIGINT   ENCODE lzo
	,merchant_id VARCHAR(100)   ENCODE lzo
	,label VARCHAR(255)   ENCODE lzo
	,status VARCHAR(30) ENCODE lzo
	,device_uuid VARCHAR(37)   ENCODE lzo
    	,primary key(device_id)
			,UNIQUE(device_uuid)
)
DISTSTYLE EVEN
;
-------------------
CREATE TABLE IF NOT EXISTS matillion_dwh.dim_practice
(
    k_practice_id BIGINT SORTKEY ENCODE lzo
    ,gx_provider_id VARCHAR(32) ENCODE lzo
    ,practice_activated_at TIMESTAMP WITHOUT time zone ENCODE lzo
    ,practice_time_zone VARCHAR(50)
    ,practice_name VARCHAR(MAX)
    ,practice_city VARCHAR(50)
    ,practice_state VARCHAR(20)
    ,practice_zip VARCHAR(10)
    ,primary key(k_practice_id)
    ,UNIQUE(gx_provider_id)
)
DISTSTYLE EVEN;
------------------------------------
CREATE TABLE IF NOT EXISTS matillion_dwh.fact_payment_summary
(
	sales_id VARCHAR(128)   ENCODE lzo
	,sales_name VARCHAR(255)   ENCODE lzo
	,sales_amount NUMERIC(18,0)   ENCODE lzo
	,sales_type VARCHAR(16)   ENCODE lzo
	,sales_status BIGINT   ENCODE lzo
	,sales_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,gx_customer_id VARCHAR(64)   ENCODE lzo
	,gx_provider_id VARCHAR(64)   ENCODE lzo
  ,transaction_id VARCHAR(255) ENCODE lzo
	,payment_id VARCHAR(255)   ENCODE lzo
	,tokenization VARCHAR(255)   ENCODE lzo
    ,gx_subscription_id  VARCHAR(64)   ENCODE lzo
	,staff_user_id BIGINT   ENCODE lzo
    ,device_id VARCHAR(255)   ENCODE lzo
	,gratuity_amount NUMERIC(18,0)   ENCODE lzo
    ,is_voided varchar(10) ENCODE lzo

            ,primary key(sales_id)
            ,foreign key(gx_provider_id) references practice(gx_provider_id)
            ,foreign key(gx_customer_id) references customer(gx_customer_id)
)
DISTSTYLE EVEN
;
-----------------------------------
CREATE TABLE IF NOT EXISTS matillion_dwh.fact_product_sales
(
  subscription_id BIGINT SORTKEY ENCODE lzo
  ,k_subscription_id VARCHAR(32) ENCODE lzo
  ,quantity INTEGER ENCODE lzo
  ,unit_name VARCHAR(max) ENCODE lzo
  ,remaining_payment INTEGER ENCODE lzo
  ,balance INTEGER ENCODE lzo
  ,discount_percentages INTEGER ENCODE lzo
  ,discount_amts INTEGER ENCODE lzo
  ,coupons INTEGER ENCODE lzo
  ,credits INTEGER ENCODE lzo
  ,payments INTEGER ENCODE lzo
  ,total_installment INTEGER ENCODE lzo
  ,tax INTEGER ENCODE lzo
  ,subtotal INTEGER ENCODE lzo
  ,total INTEGER ENCODE lzo
  ,START_date  TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,END_date TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,end_count INTEGER ENCODE lzo
  ,END_unit VARCHAR(max) ENCODE lzo
  ,proration VARCHAR(1) ENCODE lzo
  ,auto_renewal  VARCHAR(1) ENCODE lzo
  ,renewal_count INTEGER ENCODE lzo
  ,subscription_name VARCHAR(max) ENCODE lzo
  ,subscription_created TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,subscription_updated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,subscription_canceled_at TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,plan_id BIGINT   ENCODE lzo
  ,k_plan_id VARCHAR(32)   ENCODE lzo
  ,customer_id BIGINT   ENCODE lzo
  ,k_customer_id VARCHAR(32)   ENCODE lzo
  ,provider_id BIGINT   ENCODE lzo
  ,k_provider_id VARCHAR(32)   ENCODE lzo
  ,timestampz  TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,  primary key(subscription_id)
  ,  UNIQUE(k_subscription_id)
)
DISTSTYLE EVEN;

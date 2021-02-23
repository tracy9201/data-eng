CREATE TABLE IF NOT EXISTS dwh_opul.dim_customer
(
	k_customer_id BIGINT   ENCODE lzo
	,member_on_boarding_date TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,member_cancel_date TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,customer_email VARCHAR(255)   ENCODE lzo
	,customer_mobile VARCHAR(MAX)   ENCODE lzo
	,customer_gender SMALLINT   ENCODE lzo
	,customer_birth_year NUMERIC(18,0)   ENCODE lzo
	,gx_customer_id VARCHAR(max)   ENCODE lzo
	,member_type VARCHAR(16)   ENCODE lzo
	,customer_city VARCHAR(64)   ENCODE lzo
	,customer_state VARCHAR(MAX)   ENCODE lzo
	,customer_zip VARCHAR(16)   ENCODE lzo
  ,user_type INTEGER  ENCODE lzo
	,customer_type VARCHAR(MAX) ENCODE lzo
	,firstname VARCHAR(MAX)   ENCODE lzo
	,lastname  VARCHAR(MAX)  ENCODE lzo
	,created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,updated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE lzo
        ,primary key(k_customer_id)
        ,UNIQUE(gx_customer_id, updated_at)
)
DISTSTYLE EVEN
;

----------------------

CREATE TABLE IF NOT EXISTS dwh_opul.dim_kronos_subscription
(
	subscription_id BIGINT SORTKEY ENCODE lzo
	,status INTEGER ENCODE lzo
	,cycles  INTEGER  ENCODE lzo
	,quantity  INTEGER  ENCODE lzo
	,is_subscription  boolean
	,period_unit INTEGER ENCODE lzo
	,period  INTEGER  ENCODE lzo
	,gx_subscription_id VARCHAR(255)  ENCODE lzo
	,plan_id  BIGINT  ENCODE lzo
  ,offering_id  BIGINT  ENCODE lzo
  ,subscription_type  INTEGER   ENCODE lzo
	,ad_hoc_offering_id BIGINT NCODE lzo
	,created_at TIMESTAMP WITHOUT TIME ZONE ENCODE lzo
	,updated_at TIMESTAMP WITHOUT TIME ZONE ENCODE lzo
	,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE lzo
  		,  primary key(subscription_id)
			, UNIQUE(subscription_id, updated_at)
)
DISTSTYLE EVEN;
-------------------------
CREATE TABLE IF NOT EXISTS dwh_opul.dim_p2pe_device
(
	device_id BIGINT  SORTKEY ENCODE lzo
	,organization_id BIGINT   ENCODE lzo
	,merchant_id VARCHAR(100)   ENCODE lzo
	,label VARCHAR(255)   ENCODE lzo
	,status VARCHAR(30) ENCODE lzo
	,device_uuid VARCHAR(37)   ENCODE lzo
	,created_at TIMESTAMP WITHOUT TIME ZONE ENCODE lzo
	,updated_at TIMESTAMP WITHOUT TIME ZONE ENCODE lzo
	,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE lzo
    	,primary key(device_id)
			,UNIQUE(device_uuid, updated_at)
)
DISTSTYLE EVEN
;
-------------------
CREATE TABLE IF NOT EXISTS dwh_opul.dim_practice
(
    k_practice_id BIGINT SORTKEY ENCODE lzo
    ,gx_provider_id VARCHAR(32) ENCODE lzo
    ,practice_activated_at TIMESTAMP WITHOUT time zone ENCODE lzo
    ,practice_time_zone VARCHAR(50) ENCODE lzo
    ,practice_name VARCHAR(MAX) ENCODE lzo
    ,practice_city VARCHAR(50) ENCODE lzo
    ,practice_state VARCHAR(20) ENCODE lzo
    ,practice_zip VARCHAR(MAX) ENCODE lzo
		,merchant_id BIGINT  ENCODE lzo
		,created_at TIMESTAMP WITHOUT TIME ZONE ENCODE lzo
		,updated_at TIMESTAMP WITHOUT TIME ZONE ENCODE lzo
		,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE lzo
    	,primary key(k_practice_id)
    	,UNIQUE(gx_provider_id, updated_at)
)
DISTSTYLE EVEN;
------------------------------------
CREATE TABLE IF NOT EXISTS dwh_opul.fact_payment_summary
(
	sales_id VARCHAR(255)   ENCODE lzo
	,sales_name VARCHAR(MAX)   ENCODE lzo
	,sales_amount NUMERIC(18,0)   ENCODE lzo
	,sales_type VARCHAR(16)   ENCODE lzo
	,sales_status BIGINT   ENCODE lzo
	,sales_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
	,gx_customer_id VARCHAR(64)   ENCODE lzo
	,gx_provider_id VARCHAR(64)   ENCODE lzo
  ,transaction_id VARCHAR(255) ENCODE lzo
	,payment_id VARCHAR(255)   ENCODE lzo
	,tokenization VARCHAR(255)   ENCODE lzo
	,token_substr VARCHAR(8) ENCODE lzo
  ,gx_subscription_id  VARCHAR(64)   ENCODE lzo
	,staff_user_id BIGINT   ENCODE lzo
  ,device_id VARCHAR(255)   ENCODE lzo
	,gratuity_amount NUMERIC(18,0)   ENCODE lzo
  ,is_voided varchar(10) ENCODE lzo
	,card_holder_name VARCHAR(255) ENCODE lzo
  ,created_at TIMESTAMP WITHOUT TIME ZONE ENCODE lzo
  ,updated_at TIMESTAMP WITHOUT TIME ZONE ENCODE lzo
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE lzo
      		,primary key(sales_id)
					,UNIQUE(sales_id, updated_at)
DISTSTYLE EVEN
;
-----------------------------------
CREATE TABLE IF NOT EXISTS dwh_opul.fact_product_sales
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
  ,proration BOOLEAN
  ,auto_renewal  BOOLEAN
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
  ,dwh_created_at  TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,  primary key(subscription_id)
  ,  UNIQUE(k_subscription_id, updated_at)
)
DISTSTYLE EVEN;

-----------------------
CREATE TABLE IF NOT EXISTS dwh_opul.fact_batch_report_summary
(
  ,is_voided varchar(10) ENCODE lzo
  ,sales_id VARCHAR(255)   ENCODE lzo
  ,sales_type VARCHAR(255)   ENCODE lzo
  ,transaction VARCHAR(128)   ENCODE lzo
  ,payment_method VARCHAR(128)   ENCODE lzo
  ,payment_detail VARCHAR(128)   ENCODE lzo
  ,payment_id VARCHAR(MAX)   ENCODE lzo
  ,gx_customer_id VARCHAR(MAX)   ENCODE lzo
  ,gx_provider_id VARCHAR(MAX)   ENCODE lzo
  ,original_sales_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,staff_user_id VARCHAR(255) ENCODE lzo
  ,device_id VARCHAR(255)   ENCODE lzo
  ,sales_amount NUMERIC(18,0)   ENCODE lzo
  ,gratuity_amount NUMERIC(18,0)   ENCODE lzo
  ,epoch_sales_created_at BIGINT ENCODE lzo
  ,epoch_original_sales_created_at BIGINT ENCODE lzo
  ,category VARCHAR(4) ENCODE lzo
  ,created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,updated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
			,  primary key(sales_id)
			,  UNIQUE(sales_id, updated_at)
)
DISTSTYLE EVEN;

--------------------------
CREATE TABLE IF NOT EXISTS dwh_opul.fact_batch_report_details
(
	subscription_name VARCHAR(MAX) ENCODE lzo
  ,user_type INTEGER ENCODE lzo
  ,is_voided VARCHAR(10) ENCODE lzo
  ,sales_id VARCHAR(255)   ENCODE lzo
  ,transaction VARCHAR(128)   ENCODE lzo
  ,payment_method VARCHAR(128)   ENCODE lzo
  ,card_brand VARCHAR(255)   ENCODE lzo
  ,payment_detail VARCHAR(128)   ENCODE lzo
  ,description VARCHAR(MAX) ENCODE lzo
  ,payment_id VARCHAR(MAX)   ENCODE lzo
  ,gx_customer_id VARCHAR(255)   ENCODE lzo
  ,gx_provider_id  VARCHAR(255)   ENCODE lzo,
  ,sales_created_at  TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,original_sales_created_at  TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,staff_user_id VARCHAR(255) ENCODE lzo
  ,device_id VARCHAR(255)   ENCODE lzo
  ,tokenization VARCHAR(255)   ENCODE lzo
  ,sales_amount NUMERIC(18,0)   ENCODE lzo
  ,gratuity_amount NUMERIC(18,0)   ENCODE lzo
  ,card_holder_name VARCHAR(MAX) ENCODE lzo
  ,epoch_sales_created_at  TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,epoch_original_sales_created_at  TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,category VARCHAR(4) ENCODE lzo
  ,firstname VARCHAR(255)   ENCODE lzo
  ,lastname VARCHAR(255)   ENCODE lzo
  ,created_at  TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,updated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE lzo
		,  primary key(sales_id)
		,  UNIQUE(sales_id, updated_at)
)

DROP TABLE IF EXISTS internal_reporting_hint.ddl_invoice_payment;

CREATE TABLE IF NOT EXISTS internal_reporting_hint.ddl_invoice_payment
(
  id VARCHAR(255) ENCODE raw
,pay_date TIMESTAMP WITHOUT TIME ZONE ENCODE raw
,invoice BIGINT ENCODE raw
,subscription_id BIGINT ENCODE raw
,units INTEGER ENCODE raw
,unit_type VARCHAR(255) ENCODE raw
,price_unit NUMERIC(18,2) ENCODE raw
,subscription_cycle INTEGER ENCODE raw
,total_price NUMERIC(18,2) ENCODE raw
,recurring_payment BIGINT ENCODE raw
,invoice_amount NUMERIC(18,2) ENCODE raw
,discounted_price NUMERIC(18,2) ENCODE raw
,tax_charged NUMERIC(18,2) ENCODE raw
,taxable_amount NUMERIC(18,2) ENCODE raw
,item_discount NUMERIC(18,2) ENCODE raw
,discount_reason VARCHAR(65535) ENCODE raw
,grand_total NUMERIC(18,2) ENCODE raw
,gx_subscription_id VARCHAR(255) ENCODE raw
,gx_customer_id VARCHAR(255) ENCODE raw
,gx_provider_id VARCHAR(255) ENCODE raw
,count_of_invoice_item BIGINT ENCODE raw
,invoice_actual_amount NUMERIC(18,2) ENCODE raw
,invoice_credit NUMERIC(18,2) ENCODE raw
,count_distinct_brand BIGINT ENCODE raw
,brand VARCHAR(MAX) ENCODE raw
,count_distinct_product BIGINT ENCODE raw
,product_service VARCHAR(255) ENCODE raw
,count_distinct_sku BIGINT ENCODE raw
,sku VARCHAR(MAX) ENCODE raw
,dwh_created_at TIMESTAMP ENCODE raw
  ,primary key(id)
  ,UNIQUE(id)

)

DISTKEY(gx_customer_id)
SORTKEY(gx_customer_id);
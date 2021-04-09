DROP TABLE IF EXISTS public.product_sales;

CREATE TABLE IF NOT EXISTS public.product_sales
(
   primary_product_id VARCHAR(255) ENCODE raw
  ,subscription_id BIGINT  ENCODE raw
  ,k_subscription_id VARCHAR(32) ENCODE raw
  ,quantity NUMERIC(18,2)   ENCODE raw
  ,unit_name VARCHAR(max) ENCODE raw
  ,remaining_payment NUMERIC(18,2)   ENCODE raw
  ,balance NUMERIC(18,2)   ENCODE raw
  ,discount_percentages NUMERIC(18,2)   ENCODE raw
  ,discount_amts NUMERIC(18,2)   ENCODE raw
  ,coupons NUMERIC(18,2)   ENCODE raw
  ,credits NUMERIC(18,2)   ENCODE raw
  ,payments NUMERIC(18,2)   ENCODE raw
  ,total_installment NUMERIC(18,2)   ENCODE raw
  ,tax NUMERIC(18,2)   ENCODE raw
  ,subtotal NUMERIC(18,2)   ENCODE raw
  ,total NUMERIC(18,2)   ENCODE raw
  ,START_date  TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,END_date TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,end_count INTEGER ENCODE raw
  ,END_unit VARCHAR(max) ENCODE raw
  ,proration BOOLEAN
  ,auto_renewal  BOOLEAN
  ,renewal_count INTEGER ENCODE raw
  ,subscription_name VARCHAR(max) ENCODE raw
  ,subscription_created TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,subscription_updated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,subscription_canceled_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,plan_id BIGINT   ENCODE raw
  ,k_plan_id VARCHAR(32)   ENCODE raw
  ,customer_id BIGINT   ENCODE raw
  ,k_customer_id VARCHAR(32)   ENCODE raw
  ,provider_id BIGINT   ENCODE raw
  ,k_provider_id VARCHAR(32)   ENCODE raw
  ,loaded_at  TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,sales_id
      ,primary key(primary_product_id)
      ,UNIQUE(primary_product_id)
)
DISTKEY (subscription_id)
SORTKEY (subscription_id)
;

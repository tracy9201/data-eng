CREATE TABLE IF NOT EXISTS dwh_opul.fact_product_sales
(
  subscription_id BIGINT  ENCODE raw
  ,k_subscription_id VARCHAR(32) ENCODE raw
  ,quantity INTEGER ENCODE raw
  ,unit_name VARCHAR(max) ENCODE raw
  ,remaining_payment INTEGER ENCODE raw
  ,balance INTEGER ENCODE raw
  ,discount_percentages INTEGER ENCODE raw
  ,discount_amts INTEGER ENCODE raw
  ,coupons INTEGER ENCODE raw
  ,credits INTEGER ENCODE raw
  ,payments INTEGER ENCODE raw
  ,total_installment INTEGER ENCODE raw
  ,tax INTEGER ENCODE raw
  ,subtotal INTEGER ENCODE raw
  ,total INTEGER ENCODE raw
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
  ,dwh_created_at  TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,primary key(subscription_id)
  ,UNIQUE(k_subscription_id, updated_at)
)
DISTKEY (k_customer_id)
SORTKEY (k_customer_id)
;

DROP TABLE IF EXISTS dwh_hint${environment}.product_sales;
CREATE TABLE IF NOT EXISTS dwh_hint${environment}.product_sales (
  subscription_id bigint ENCODE RAW,
  k_subscription_id varchar(32) ENCODE RAW,
  quantity numeric ENCODE RAW,
  unit_name varchar(65535) ENCODE RAW,
  remaining_payment numeric ENCODE RAW,
  balance numeric ENCODE RAW,
  discount_percentages numeric ENCODE RAW,
  discount_amts numeric ENCODE RAW,
  coupons numeric ENCODE RAW,
  credits numeric ENCODE RAW,
  payments numeric ENCODE RAW,
  total_installment numeric ENCODE RAW,
  tax numeric ENCODE RAW,
  subtotal numeric ENCODE RAW,
  total numeric ENCODE RAW,
  start_date timestamp without time zone ENCODE RAW,
  end_date timestamp without time zone ENCODE RAW,
  end_count integer ENCODE RAW,
  end_unit varchar(65535) ENCODE RAW,
  proration boolean,
  auto_renewal boolean,
  renewal_count integer ENCODE RAW,
  subscription_name varchar(65535) ENCODE RAW,
  subscription_created timestamp without time zone ENCODE RAW,
  subscription_updated_at timestamp without time zone ENCODE RAW,
  subscription_canceled_at timestamp without time zone ENCODE RAW,
  plan_id bigint ENCODE RAW,
  k_plan_id varchar(32) ENCODE RAW,
  customer_id bigint ENCODE RAW,
  k_customer_id varchar(32) ENCODE RAW,
  provider_id bigint ENCODE RAW,
  k_provider_id varchar(32) ENCODE RAW,
  loaded_at timestamp without time zone ENCODE RAW
) DISTKEY(gx_provider_id, provider_id);

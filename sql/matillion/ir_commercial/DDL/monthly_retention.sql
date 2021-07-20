DROP TABLE IF EXISTS ir_commercial.monthly_retention;

CREATE TABLE IF NOT EXISTS ir_commercial.monthly_retention
(
  created DATE ENCODE raw,
  gx_customer_id BIGINT ENCODE raw,
  cancelled_month int   ENCODE raw,
  created_month TIMESTAMP WITHOUT TIME ZONE   ENCODE raw,
  currently_remaning_customer BIGINT ENCODE raw,
  Total_Customer_Per_Month BIGINT ENCODE raw,
  customer_index BIGINT ENCODE raw,
  primary key(gx_customer_id)
)
;
DROP TABLE IF EXISTS ir_commercial.monthly_retention;

CREATE TABLE IF NOT EXISTS ir_commercial.monthly_retention
(
  created DATE ENCODE raw,
  gx_customer_id BIGINT ENCODE raw,
  cancelled_month int   ENCODE raw,
  created_month TIMESTAMP WITHOUT TIME ZONE   ENCODE raw,
  total BIGINT ENCODE raw,
  sum BIGINT ENCODE raw,
  agg_total BIGINT ENCODE raw,
  primary key(gx_customer_id)
)
;
DROP TABLE IF EXISTS ir_commercial.member_date;

CREATE TABLE IF NOT EXISTS ir_commercial.member_date
(
  gx_customer_id VARCHAR(64)   ENCODE raw
  ,created DATE   ENCODE raw
  ,cancelled DATE  ENCODE raw
  ,cancelled_month bigint  ENCODE raw
  ,primary key(gx_customer_id)
)
;
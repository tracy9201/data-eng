DROP TABLE IF EXISTS ir_commercial.platform_recurring_revenue;

CREATE TABLE IF NOT EXISTS ir_commercial.platform_recurring_revenue
(
    id BIGINT   ENCODE raw,
  practice_name VARCHAR(MAX)   ENCODE raw
  ,transaction_date date   ENCODE raw
  ,membership_fee NUMERIC(18,2)   ENCODE raw
  ,platform_fee NUMERIC(18,2)   ENCODE raw
  ,organization_product_fee NUMERIC(18,2)   ENCODE raw
  ,total NUMERIC(18,2)   ENCODE raw
)
DISTKEY (id)
SORTKEY (id, transaction_date, practice_name)
;
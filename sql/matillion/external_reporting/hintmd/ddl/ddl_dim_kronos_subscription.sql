DROP TABLE IF EXISTS dwh_hint.dim_kronos_subscription;

CREATE TABLE IF NOT EXISTS dwh_hint.dim_kronos_subscription
(
  subscription_id BIGINT ENCODE raw
  ,status INTEGER ENCODE raw
  ,cycles  INTEGER  ENCODE raw
  ,quantity  INTEGER  ENCODE raw
  ,is_subscription  boolean
  ,period_unit INTEGER ENCODE raw
  ,period  INTEGER  ENCODE raw
  ,gx_subscription_id VARCHAR(255)  ENCODE raw
  ,plan_id  BIGINT  ENCODE raw
  ,offering_id  BIGINT  ENCODE raw
  ,subscription_type  INTEGER   ENCODE raw
  ,ad_hoc_offering_id BIGINT ENCODE raw
    ,primary key(subscription_id)
    ,UNIQUE(subscription_id)
)
DISTKEY (subscription_id)
SORTKEY (subscription_id)
;

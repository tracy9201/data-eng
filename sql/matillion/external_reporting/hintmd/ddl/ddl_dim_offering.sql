DROP TABLE IF EXISTS dwh_hint.dim_offering;

CREATE TABLE IF NOT EXISTS dwh_hint.dim_offering
(
gx_subscription_id VARCHAR(255)  ENCODE raw
,plan_id BIGINT ENCODE raw
,subscription_status INTEGER ENCODE raw
,product_service VARCHAR(255)  ENCODE raw
,brand VARCHAR(255)  ENCODE raw
,sku VARCHAR(MAX) ENCODE raw
  ,primary key(gx_subscription_id)
  ,UNIQUE(gx_subscription_id)
)
DISTKEY (gx_subscription_id)
SORTKEY (gx_subscription_id)
;

create table if not exists dwh.dim_offering
(
  gx_subscription_id varchar(32),
  product_service varchar(255),
  subscription_status INTEGER,
  brand varchar(max),
  sku varchar(max),
  	primary key(gx_subscription_id),
    unique(gx_subscription_id)
)
DISTSTYLE EVEN;
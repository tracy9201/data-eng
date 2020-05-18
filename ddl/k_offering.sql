create table IF NOT EXISTS rds_data.k_offering
(
id	BIGINT	,
created_at	TIMESTAMP WITHOUT TIME ZONE	,
updated_at	TIMESTAMP WITHOUT TIME ZONE	,
deprecated_at	TIMESTAMP WITHOUT TIME ZONE	,
status	INTEGER	,
name	VARCHAR(255)	,
pay_in_full_price	BIGINT	,
subscription_price	BIGINT	,
service_tax	INTEGER	,
organization_id	BIGINT	,
catalog_item_id	BIGINT	,
recurring	VARCHAR(1)	,
reward_id	BIGINT	,
pay_over_time_price	BIGINT	,
  primary key(id)
 )
DISTSTYLE EVEN
;
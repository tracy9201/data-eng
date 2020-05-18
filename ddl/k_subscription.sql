create table IF NOT EXISTS rds_data.k_subscription
(
id	BIGINT	,
created_at	TIMESTAMP WITHOUT TIME ZONE	,
updated_at	TIMESTAMP WITHOUT TIME ZONE	,
deprecated_at	TIMESTAMP WITHOUT TIME ZONE	,
status	INTEGER	,
cycles	INTEGER	,
quantity	INTEGER	,
is_subscription	VARCHAR(1)	,
period_unit	INTEGER	,
period	INTEGER	,
gx_subscription_id	VARCHAR(32)	,
plan_id	BIGINT	,
offering_id	BIGINT	,
type	INTEGER	,
ad_hoc_offering_id	BIGINT	,
amount_off	INTEGER	,
percentage_off	INTEGER	,
discount_note	VARCHAR(256)	,
  primary key(id)
 )
DISTSTYLE EVEN
;
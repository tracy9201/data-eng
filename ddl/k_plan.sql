create table IF NOT EXISTS rds_data.k_plan
(
id	BIGINT	,
created_at	TIMESTAMP WITHOUT TIME ZONE	,
updated_at	TIMESTAMP WITHOUT TIME ZONE	,
deprecated_at	TIMESTAMP WITHOUT TIME ZONE	,
status	INTEGER	,
gx_plan_id	VARCHAR(32)	,
user_id	BIGINT	,
  primary key(id)
 )
DISTSTYLE EVEN
;
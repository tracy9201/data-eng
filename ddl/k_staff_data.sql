create table IF NOT EXISTS rds_data.k_staff_data
(
id	BIGINT	,
created_at	TIMESTAMP WITHOUT TIME ZONE	,
updated_at	TIMESTAMP WITHOUT TIME ZONE	,
deprecated_at	TIMESTAMP WITHOUT TIME ZONE	,
status	INTEGER	,
user_id	BIGINT	,
commission	INTEGER	,
  primary key(id)
 )
DISTSTYLE EVEN
;
 create table IF NOT EXISTS rds_data.k_brand
(
id	BIGINT	,
created_at	TIMESTAMP WITHOUT TIME ZONE	,
updated_at	TIMESTAMP WITHOUT TIME ZONE	,
deprecated_at	TIMESTAMP WITHOUT TIME ZONE	,
name	VARCHAR(255)	,
thumbnail	VARCHAR(255)	,
status	INTEGER	,
  primary key(id)
 )
DISTSTYLE EVEN
;
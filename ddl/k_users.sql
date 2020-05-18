 create table IF NOT EXISTS rds_data.k_users
(
id	BIGINT	,
created_at	TIMESTAMP WITHOUT TIME ZONE	,
updated_at	TIMESTAMP WITHOUT TIME ZONE	,
deprecated_at	TIMESTAMP WITHOUT TIME ZONE	,
status	INTEGER	,
title	VARCHAR(32)	,
firstname	VARCHAR(255)	,
lastname	VARCHAR(255)	,
password	VARCHAR(255)	,
salt	VARCHAR(255)	,
last_login_attempt_at	BIGINT	,
last_login_at	BIGINT	,
role	INTEGER	,
email	VARCHAR(255)	,
mobile	VARCHAR(255)	,
organization_id	BIGINT	,
thumbnail	VARCHAR(255)	,
color	VARCHAR(8)	,
firebase_token	VARCHAR(255)	,
  primary key(id)
 )
DISTSTYLE EVEN
;
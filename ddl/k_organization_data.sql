 create table IF NOT EXISTS rds_data.k_organization_data
(
id	BIGINT	,
created_at	TIMESTAMP WITHOUT TIME ZONE	,
updated_at	TIMESTAMP WITHOUT TIME ZONE	,
deprecated_at	TIMESTAMP WITHOUT TIME ZONE	,
status	INTEGER	,
gx_provider_id	VARCHAR(32)	,
currency	VARCHAR(4)	,
rate	INTEGER	,
per_member_rate	INTEGER	,
address_id	BIGINT	,
signer_id	BIGINT	,
merchant_id	BIGINT	,
timezone	VARCHAR(32)	,
gx_org_customer_id	VARCHAR(32)	,
activated_at	TIMESTAMP WITHOUT TIME ZONE	,
suppressed_messages	BIGINT	,
feature_flags_json	VARCHAR(MAX)	,
name	VARCHAR(255)	,
account_id	BIGINT	,
live	VARCHAR(1)	,
  primary key(id)
 )
DISTSTYLE EVEN
;

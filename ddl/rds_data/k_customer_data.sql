create table IF NOT EXISTS rds_data.k_customer_data
(
id	BIGINT	,
created_at	TIMESTAMP WITHOUT TIME ZONE	,
updated_at	TIMESTAMP WITHOUT TIME ZONE	,
deprecated_at	TIMESTAMP WITHOUT TIME ZONE	,
status	INTEGER	,
user_id	BIGINT	,
gender	INTEGER	,
birth_date_utc	TIMESTAMP WITHOUT TIME ZONE	,
billing_address_id	BIGINT	,
agreement	VARCHAR(16)	,
gx_customer_id	VARCHAR(32)	,
gx_card_id	VARCHAR(32)	,
shipping_address_id	BIGINT	,
type	INTEGER	,
  primary key(id)
 )
DISTSTYLE EVEN
;
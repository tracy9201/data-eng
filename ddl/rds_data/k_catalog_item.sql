create table IF NOT EXISTS rds_data.k_catalog_item
(
id	BIGINT	,
created_at	TIMESTAMP WITHOUT TIME ZONE	,
updated_at	TIMESTAMP WITHOUT TIME ZONE	,
deprecated_at	TIMESTAMP WITHOUT TIME ZONE	,
status	INTEGER	,
name	VARCHAR(max)	,
thumbnail	VARCHAR(max)	,
type	INTEGER	,
unit_type	INTEGER	,
unit_range_top	INTEGER	,
unit_range_bottom	INTEGER	,
brand_id	BIGINT	,
sku	VARCHAR(max)	,
wholesale_price	BIGINT	,
period	INTEGER	,
period_unit	INTEGER	,
description	VARCHAR(max)	,
instructions	VARCHAR(max)	,
ingredients	VARCHAR(max)	,
bd_status	INTEGER	,
  primary key(id)
 )
DISTSTYLE EVEN
;
DROP TABLE IF EXISTS internal_reporting_hint.ddl_brand_catalog_category;

CREATE TABLE IF NOT EXISTS internal_reporting_hint.ddl_brand_catalog_category
(
  brand VARCHAR(255) ENCODE raw
,catalog VARCHAR(255) ENCODE raw
,category VARCHAR(255) ENCODE raw
,dw_created_at timestamp
)
;
DROP TABLE IF EXISTS ir_cs.ddl_brand_catalog_category;

CREATE TABLE IF NOT EXISTS ir_cs.ddl_brand_catalog_category
(
  brand VARCHAR(255) ENCODE raw
,catalog VARCHAR(255) ENCODE raw
,category VARCHAR(255) ENCODE raw
)
;
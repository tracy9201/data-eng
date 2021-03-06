DROP TABLE IF EXISTS dwh_opul${environment}.dim_brand_catalog_offering;

CREATE TABLE IF NOT EXISTS dwh_opul${environment}.dim_brand_catalog_offering
(
  offering_id BIGINT   ENCODE raw
  ,offering_name VARCHAR(MAX)   ENCODE raw
  ,catalog_name VARCHAR(MAX)   ENCODE raw
  ,catalog_id BIGINT   ENCODE raw
  ,factory_name VARCHAR(max)   ENCODE raw
  ,factory_id BIGINT   ENCODE raw
  ,offering_pay_in_full_price NUMERIC(18,2)   ENCODE raw
  ,offering_subscription_price NUMERIC(18,2)  ENCODE raw
  ,offering_pay_over_time_price NUMERIC(18,2)   ENCODE raw
  ,offering_service_tax NUMERIC(18,2)   ENCODE raw
  ,offering_status integer   ENCODE raw
  ,organization_id BIGINT   ENCODE raw
  ,catalog_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,catalog_status integer  ENCODE raw
  ,catalog_wholesale_price  NUMERIC(18,2) ENCODE raw
  ,bd_status integer  ENCODE raw
  ,sku VARCHAR(MAX)   ENCODE raw
  ,brand_created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,updated_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,primary key(offering_id)
  ,UNIQUE(offering_id, updated_at)
)
DISTSTYLE ALL
SORTKEY (offering_id,organization_id)
;
DROP TABLE IF  EXISTS dwh_opul_{environment}.dim_practice;

CREATE TABLE IF NOT EXISTS dwh_opul_{environment}.dim_practice
(
  k_practice_id BIGINT  ENCODE raw
  ,gx_provider_id VARCHAR(32) ENCODE raw
  ,practice_activated_at TIMESTAMP WITHOUT time zone ENCODE raw
  ,practice_time_zone VARCHAR(50) ENCODE raw
  ,practice_name VARCHAR(MAX) ENCODE raw
  ,practice_city VARCHAR(50) ENCODE raw
  ,practice_state VARCHAR(20) ENCODE raw
  ,practice_zip VARCHAR(MAX) ENCODE raw
  ,merchant_id BIGINT  ENCODE raw
  ,created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,updated_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,primary key(k_practice_id)
  ,UNIQUE(gx_provider_id, updated_at)
)
DISTSTYLE ALL
SORTKEY (gx_provider_id,k_practice_id)
;
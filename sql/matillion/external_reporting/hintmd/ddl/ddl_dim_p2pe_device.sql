DROP TABLE IF EXISTS dwh_hint.dim_p2pe_device;

CREATE TABLE IF NOT EXISTS dwh_hint.dim_p2pe_device
(
  device_id BIGINT ENCODE raw
  ,organization_id BIGINT   ENCODE raw
  ,merchant_id VARCHAR(100)   ENCODE raw
  ,label VARCHAR(255)   ENCODE raw
  ,status VARCHAR(30) ENCODE raw
  ,device_uuid VARCHAR(37)   ENCODE raw
    ,primary key(device_id)
    ,UNIQUE(device_uuid)
)
DISTSTYLE ALL
SORTKEY (device_uuid,label,status)
;

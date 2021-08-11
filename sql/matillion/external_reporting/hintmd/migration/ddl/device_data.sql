DROP TABLE IF EXISTS dwh_hint${environment}.device_data;
CREATE TABLE IF NOT EXISTS dwh_hint${environment}.device_data (
  device_id bigint ENCODE RAW,
  organization_id bigint ENCODE RAW,
  merchant_id varchar(100) ENCODE RAW,
  label varchar(255) ENCODE RAW,
  status varchar(30) ENCODE RAW,
  device_uuid varchar(37) ENCODE RAW
) DISTKEY(organization_id);

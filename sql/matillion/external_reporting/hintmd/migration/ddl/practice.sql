DROP TABLE IF EXISTS dwh_hint${environment}.practice;
CREATE TABLE IF NOT EXISTS dwh_hint${environment}.practice (
  k_practice_id bigint ENCODE RAW,
  gx_provider_id varchar(32) ENCODE RAW,
  practice_activated_at timestamp without time zone ENCODe RAW,
  practice_time_zone varchar(50) ENCODE RAW,
  practice_name varchar(64) ENCODE RAW,
  practice_city varchar(50) ENCODE RAW,
  practice_state varchar(20) ENCODE RAW,
  practice_zip varchar(20) ENCODE RAW,
  merchant_id bigint ENCODE RAW
) DISTKEY(k_practice_id);

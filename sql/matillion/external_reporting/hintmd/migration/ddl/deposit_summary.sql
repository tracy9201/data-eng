DROP TABLE IF EXISTS dwh_hint${environment}.deposit_summary;
CREATE TABLE IF NOT EXISTS dwh_hint${environment}.deposit_summary (
  gx_provider_id varchar(255) ENCODE RAW,
  funding_master_id varchar(255) ENCODE RAW,
  fees numeric ENCODE RAW,
  adjustments numeric ENCODE RAW,
  net_sales numeric ENCODE RAW,
  total_funding numeric ENCODE RAW,
  funding_date timestamp without time zone ENCODE RAW,
  date_added timestamp without time zone ENCODE RAW,
  chargebacks numeric ENCODE RAW,
  status integer ENCODE RAW,
  funding_id bigint ENCODE RAW
) DISTKEY(gx_provider_id);

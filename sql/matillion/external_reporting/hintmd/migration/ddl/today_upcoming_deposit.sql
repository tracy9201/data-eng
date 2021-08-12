DROP TABLE IF EXISTS dwh_hint${environment}.today_upcoming_deposit;
CREATE TABLE IF NOT EXISTS dwh_hint${environment}.today_upcoming_deposit (
  id bigint ENCODE RAW,
  gx_provider_id varchar(64) ENCODE RAW,
  unique_date date ENCODE RAW,
  total_fund numeric ENCODE RAW,
  total_tran numeric ENCODE RAW,
  sum_tran_to_date1 numeric ENCODE RAW,
  sum_fund_to_date1 numeric ENCODE RAW
) DISTKEY(gx_provider_id);

DROP TABLE IF EXISTS dwh_hint${environment}.kronos_subscription;
CREATE TABLE IF NOT EXISTS dwh_hint${environment}.kronos_subscription (
  subscription_id bigint ENCODE RAW,
  status integer ENCODE RAW,
  cycles integer ENCODE RAW,
  quantity integer ENCODE RAW,
  is_subscription boolean,
  period_unit integer ENCODE RAW,
  period integer ENCODE RAW,
  gx_subscription_id varchar(255) ENCODE RAW,
  plan_id bigint ENCODE RAW,
  offering_id bigint ENCODE RAW,
  subscription_type integer ENCODE RAW,
  ad_hoc_offering_id bigint ENCODE RAW
) DISTKEY(id);

DROP TABLE IF EXISTS dwh_hint${environment}.subscription;

CREATE TABLE IF NOT EXISTS dwh_hint${environment}.subscription
(
  id                  bigint NOT NULL ENCODE RAW,
  created_at          timestamp without time zone ENCODE RAW,
  updated_at          timestamp without time zone ENCODE RAW,
  deprecated_at       timestamp without time zone ENCODE RAW,
  status              integer ENCODE RAW,
  cycles              integer ENCODE RAW,
  quantity            integer ENCODE RAW,
  is_subscription     boolean,
  period_unit         integer ENCODE RAW,
  period              integer ENCODE RAW,
  gx_subscription_id  varchar(32) ENCODE RAW,
  plan_id             bigint ENCODE RAW,
  offering_id         bigint ENCODE RAW,
  type                integer ENCODE RAW,
  ad_hoc_offering_id  bigint ENCODE RAW,
  amount_off          integer ENCODE RAW,
  percentage_off      integer ENCODE RAW,
  discount_note       varchar(256) ENCODE RAW,
  tax_percentage      integer ENCODE RAW
) DISTKEY(id);

DROP TABLE IF EXISTS dwh_hint${environment}.payment_summary;

CREATE TABLE IF NOT EXISTS dwh_hint${environment}.payment_summary
(
  id                bigint NOT NULL  ENCODE RAW,
  plan_id           bigint  ENCODE RAW,
  subscription_id   bigint  ENCODE RAW,
  fulfillment_id    bigint  ENCODE RAW,
  amount            integer  ENCODE RAW,
  balance           integer  ENCODE RAW,
  currency          varchar(8) ENCODE  RAW,
  name              varchar(65535) ENCODE  RAW,
  type              varchar(125) ENCODE  RAW,
  use_type          varchar(125) ENCODE  RAW,
  canceled_at       timestamp without time zone  ENCODE RAW,
  deleted_at        timestamp without time zone  ENCODE RAW,
  status            smallint  ENCODE RAW,
  created_at        timestamp without time zone  ENCODE RAW,
  updated_at        timestamp without time zone  ENCODE RAW,
  encrypted_ref_id  varchar(65535) ENCODE  RAW,
  created_by        varchar(255) ENCODE  RAW,
  updated_by        varchar(255) ENCODE  RAW,
  card_brand        varchar(255) ENCODE  RAW
) DISTKEY(id);

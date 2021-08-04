CREATE TABLE IF NOT EXISTS dwh_hint${environment}.credit
(
  id                bigint NOT NULL ENCODE az64,
  plan_id           bigint ENCODE az64,
  subscription_id   bigint ENCODE az64,
  fulfillment_id    bigint ENCODE az64,
  amount            integer ENCODE az64,
  balance           integer ENCODE az64,
  currency          varchar(8) ENCODE lzo,
  name              varchar(65535) ENCODE lzo,
  type              varchar(125) ENCODE lzo,
  use_type          varchar(125) ENCODE lzo,
  canceled_at       timestamp without time zone ENCODE az64,
  deleted_at        timestamp without time zone ENCODE az64,
  status            smallint ENCODE az64,
  created_at        timestamp without time zone ENCODE az64,
  updated_at        timestamp without time zone ENCODE az64,
  encrypted_ref_id  varchar(65535) ENCODE lzo,
  created_by        varchar(255) ENCODE lzo,
  updated_by        varchar(255) ENCODE lzo,
  card_brand        varchar(255) ENCODE lzo
) DISTKEY(id)
;

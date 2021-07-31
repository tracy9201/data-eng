CREATE TABLE IF NOT EXISTS ${schema}${environment}.credit
(
  id                bigint NOT NULL,
  plan_id           bigint,
  subscription_id   bigint,
  fulfillment_id    bigint,
  amount            integer,
  balance           integer,
  currency          varchar(8),
  name              varchar(65535),
  type              varchar(125),
  use_type          varchar(125),
  canceled_at       timestamp without time zone,
  deleted_at        timestamp without time zone,
  status            smallint,
  created_at        timestamp without time zone,
  updated_at        timestamp without time zone,
  encrypted_ref_id  varchar(65535),
  created_by        varchar(255),
  updated_by        varchar(255),
  card_brand        varchar(255)
) DISTKEY(id)
;

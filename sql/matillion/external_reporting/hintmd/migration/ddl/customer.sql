DROP TABLE IF EXISTS dwh_hint${environment}.customer;

CREATE TABLE IF NOT EXISTS dwh_hint${environment}.customer
(
  id	                 bigint ENCODE RAW,
  provider_id	         bigint ENCODE RAW,
  name	               varchar(65535) ENCODE RAW,
  email	               varchar(65535) ENCODE RAW,
  mobile_number	       varchar(255) ENCODE RAW,
  addr_validate	       varchar(255) ENCODE RAW,
  status	             smallint ENCODE RAW,
  created_at	         timestamp without time zone ENCODE RAW,
  updated_at	         timestamp without time zone ENCODE RAW,
  canceled_at	         timestamp without time zone ENCODE RAW,
  deleted_at	         timestamp without time zone ENCODE RAW,
  shipping_address_id  bigint ENCODE RAW,
  encrypted_ref_id     varchar(27) ENCODE RAW
) DISTKEY(id)

DROP TABLE IF EXISTS dwh_hint${environment}.staff_details;
CREATE TABLE IF NOT EXISTS dwh_hint${environment}.staff_details (
  id bigint ENCODE RAW,
  created_at timestamp without time zone ENCODE RAW,
  updated_at timestamp without time zone ENCODE RAW,
  deprecated_at timestamp without time zone ENCODE RAW,
  status integer ENCODE RAW,
  user_id bigint ENCODE RAW,
  commission integer ENCODE RAW,
  title varchar(32) ENCODE RAW,
  firstname varchar(65535) ENCODE RAW,
  lastname varchar(65535) ENCODE RAW,
  role integer ENCODE RAW,
  email varchar(65535) ENCODE RAW,
  mobile varchar(65535) ENCODE RAW,
  organization_id bigint ENCODE RAW
) DISTKEY(id);

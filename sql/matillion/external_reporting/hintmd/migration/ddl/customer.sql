DROP TABLE IF EXISTS dwh_hint${environment}.customer;
CREATE TABLE IF NOT EXISTS dwh_hint${environment}.customer (
  k_customer_id bigint ENCODE RAW,
  member_on_boarding_date timestamp without time zone ENCODE RAW,
  member_cancel_date timestamp without time zone ENCODE RAW,
  customer_email varchar(255) ENCODE RAW,
  customer_mobile varchar(255) ENCODE RAW,
  customer_gender smallint ENCODE RAW,
  customer_birth_year numeric ENCODE RAW,
  gx_customer_id varchar(255) ENCODE RAW,
  member_type varchar(16) ENCODE RAW,
  customer_city varchar(64) ENCODE RAW,
  customer_state varchar(64) ENCODE RAW,
  customer_zip varchar(16) ENCODE RAW,
  user_type integer ENCODE RAW,
  customer_type varchar(14) ENCODE RAW,
  firstname varchar(255) ENCODE RAW,
  lastname varchar(255) ENCODE RAW
) DISTKEY(k_customer_id);

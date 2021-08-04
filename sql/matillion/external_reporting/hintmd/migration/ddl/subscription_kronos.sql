CREATE TABLE IF NOT EXISTS dwh_hint${environment}.subscription
(
id bigint NOT NULL ENCODE az64,
created_at timestamp without time zone ENCODE az64,
updated_at timestamp without time zone ENCODE az64,
deprecated_at timestamp without time zone ENCODE az64,
status integer ENCODE az64,
cycles integer ENCODE az64,
quantity integer ENCODE az64,
is_subscription boolean,
period_unit integer ENCODE az64,
period integer ENCODE az64,
gx_subscription_id varchar(32) ENCODE lzo,
plan_id bigint ENCODE az64,
offering_id bigint ENCODE az64,
type integer ENCODE az64,
ad_hoc_offering_id bigint ENCODE az64,
amount_off integer ENCODE az64,
percentage_off integer ENCODE az64,
discount_note varchar(256) ENCODE lzo,
tax_percentage integer ENCODE az64
) DISTKEY(id)
;

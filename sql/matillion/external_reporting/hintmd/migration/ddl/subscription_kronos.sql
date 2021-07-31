CREATE TABLE IF NOT EXISTS $schema}$environment}.subscription
(
id bigint NOT NULL,
created_at timestamp without time zone,
updated_at timestamp without time zone,
deprecated_at timestamp without time zone,
status integer,
cycles integer,
quantity integer,
is_subscription boolean,
period_unit integer,
period integer,
gx_subscription_id varchar(32),
plan_id bigint,
offering_id bigint,
type integer,
ad_hoc_offering_id bigint,
amount_off integer,
percentage_off integer,
discount_note varchar(256),
tax_percentage integer
) DISTKEY(id)
;

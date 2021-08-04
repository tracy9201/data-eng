CREATE TABLE IF NOT EXISTS dwh_hint${environment}.organization_data
(
id bigint NOT NULL ENCODE az64,
created_at timestamp without time zone ENCODE az64,
updated_at timestamp without time zone ENCODE az64,
deprecated_at timestamp without time zone ENCODE az64,
status integer ENCODE az64,
gx_provider_id varchar(32) ENCODE lzo,
currency varchar(4) ENCODE lzo,
rate integer ENCODE az64,
per_member_rate integer ENCODE az64,
address_id bigint ENCODE az64,
signer_id bigint ENCODE az64,
merchant_id bigint ENCODE az64,
timezone varchar(32) ENCODE lzo,
gx_org_customer_id varchar(32) ENCODE lzo,
activated_at timestamp without time zone ENCODE az64,
suppressed_messages bigint ENCODE az64,
feature_flags_json varchar(65535) ENCODE lzo,
name varchar(255) ENCODE lzo,
account_id bigint ENCODE az64,
live boolean,
payfac boolean,
organization_tax_percentage integer ENCODE az64,
onboarding_page_status varchar(255) ENCODE lzo,
owner_option varchar(10) ENCODE lzo
) DISTKEY(id)
;

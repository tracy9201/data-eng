CREATE TABLE IF NOT EXISTS $schema}$environment}.organization_data
(
id bigint NOT NULL,
created_at timestamp without time zone,
updated_at timestamp without time zone,
deprecated_at timestamp without time zone,
status integer,
gx_provider_id varchar(32),
currency varchar(4),
rate integer,
per_member_rate integer,
address_id bigint,
signer_id bigint,
merchant_id bigint,
timezone varchar(32),
gx_org_customer_id varchar(32),
activated_at timestamp without time zone,
suppressed_messages bigint,
feature_flags_json varchar(65535),
name varchar(255),
account_id bigint,
live boolean,
payfac boolean,
organization_tax_percentage integer,
onboarding_page_status varchar(255),
owner_option varchar(10)
) DISTKEY(id)
;

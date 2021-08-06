DROP TABLE IF EXISTS dwh_hint${environment}.practice;

CREATE TABLE IF NOT EXISTS dwh_hint${environment}.practice
(
id                          bigint NOT NULL ENCODE RAW,
created_at                  timestamp without time zone ENCODE RAW,
updated_at                  timestamp without time zone ENCODE RAW,
deprecated_at               timestamp without time zone ENCODE RAW,
status                      integer ENCODE RAW,
gx_provider_id              varchar(32) ENCODE RAW,
currency                    varchar(4) ENCODE RAW,
rate                        integer ENCODE RAW,
per_member_rate             integer ENCODE RAW,
address_id                  bigint ENCODE RAW,
signer_id                   bigint ENCODE RAW,
merchant_id                 bigint ENCODE RAW,
timezone                    varchar(32) ENCODE RAW,
gx_org_customer_id          varchar(32) ENCODE RAW,
activated_at                timestamp without time zone ENCODE RAW,
suppressed_messages         bigint ENCODE RAW,
feature_flags_json          varchar(65535) ENCODE RAW,
name                        varchar(255) ENCODE RAW,
account_id                  bigint ENCODE RAW,
live                        boolean,
payfac                      boolean,
organization_tax_percentage integer ENCODE RAW,
onboarding_page_status      varchar(255) ENCODE RAW,
owner_option                varchar(10) ENCODE RAW
) DISTKEY(id);

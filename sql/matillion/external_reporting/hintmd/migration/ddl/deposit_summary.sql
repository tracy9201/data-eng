DROP TABLE IF EXISTS dwh_hint${environment}.deposit_summary;

CREATE TABLE IF NOT EXISTS dwh_hint${environment}.deposit_summary
(
id                      bigint NOT NULL ENCODE RAW,
name                    varchar(65535) ENCODE  RAW,
payment_gateway_id      bigint ENCODE RAW,
authorisation_id        bigint ENCODE RAW,
funding_master_id       varchar(255) ENCODE  RAW,
funding_id              varchar(255) ENCODE  RAW,
net_sales               varchar(1024) ENCODE  RAW,
third_party             varchar(1024) ENCODE  RAW,
adjustment              varchar(1024) ENCODE  RAW,
interchange_fee         varchar(1024) ENCODE  RAW,
service_charge          varchar(1024) ENCODE  RAW,
fee                     varchar(1024) ENCODE  RAW,
reversal                varchar(1024) ENCODE  RAW,
other_adjustment        varchar(1024) ENCODE  RAW,
total_funding           varchar(1024) ENCODE  RAW,
funding_date            timestamp without time zone ENCODE RAW,
currency                varchar(8) ENCODE  RAW,
dda_number              varchar(255) ENCODE  RAW,
aba_number              varchar(255) ENCODE  RAW,
date_changed            timestamp without time zone ENCODE RAW,
date_added              timestamp without time zone ENCODE RAW,
deposit_trancode        varchar(255) ENCODE  RAW,
deposit_ach_tracenumber varchar(255) ENCODE  RAW,
status                  smallint ENCODE RAW,
created_at              timestamp without time zone ENCODE RAW,
updated_at              timestamp without time zone ENCODE RAW,
canceled_a              timestamp without time zone ENCODE RAW,
deleted_at              timestamp without time zone ENCODE RAW,
encrypted_ref_id        varchar(65535) ENCODE  RAW
) DISTKEY(id);

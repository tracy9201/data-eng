DROP TABLE IF EXISTS dwh_hint.kronos_status_hint;

CREATE TABLE IF NOT EXISTS dwh_hint.kronos_status_hint (
status_key INTEGER ENCODE raw
, status_definition VARCHAR(255) ENCODE raw
);

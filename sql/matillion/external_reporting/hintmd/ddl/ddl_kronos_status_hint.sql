DROP TABLE IF EXISTS dwh_hint.kronos_status_hint;

CREATE TABLE IF NOT EXISTS dwh_hint.kronos_status_hint (
id INTEGER ENCODE raw
, status VARCHAR(255) ENCODE raw
, description VARCHAR(255) ENCODE raw
)
diststyle all;

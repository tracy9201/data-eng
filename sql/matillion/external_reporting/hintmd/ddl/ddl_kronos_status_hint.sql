DROP TABLE IF EXISTS dwh_hint${environment}.kronos_status_hint;

CREATE TABLE IF NOT EXISTS dwh_hint${environment}.kornos_status_hint 
(
    ID BIGINT ENCODE raw,
    status VARCHAR(255) ENCODE raw,
    Description VARCHAR(255) ENCODE raw,
    UNIQUE(ID)
)
diststyle all;
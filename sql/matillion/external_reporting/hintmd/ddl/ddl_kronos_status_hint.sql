DROP TABLE IF EXISTS dwh_hint${environment}.kronos_status_hint;

CREATE TABLE IF NOT EXISTS dwh_hint${environment}.kronos_status_hint 
(
    ID BIGINT ENCODE raw,
    status VARCHAR(255) ENCODE raw,
    Description VARCHAR(255) ENCODE raw,
    primary key(ID)
)
diststyle all;
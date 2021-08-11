DROP TABLE IF EXISTS dwh_hint${environment}.p2pe_status_hint;

CREATE TABLE IF NOT EXISTS dwh_hint${environment}.p2pe_status_hint 
(
    id BIGINT ENCODE raw,
    status VARCHAR(255) ENCODE raw,
    description VARCHAR(255) ENCODE raw,
    primary key(id)
)
diststyle all;
DROP TABLE IF EXISTS ir_metadata.gaia_status_hint;

CREATE TABLE IF NOT EXISTS ir_metadata.gaia_status_hint
(
    id BIGINT ENCODE raw,
    status VARCHAR(255) ENCODE raw,
    description VARCHAR(255) ENCODE raw,
    primary key(id)
)
diststyle all;
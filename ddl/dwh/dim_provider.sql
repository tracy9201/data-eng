create table IF NOT EXISTS dwh.dim_provider
(
  k_practice_id BIGINT,
  gx_provider_id VARCHAR(32),
  practice_activated_at TIMESTAMP WITHOUT TIME ZONE,
  practice_time_zone VARCHAR(32),
  practice_name VARCHAR(MAX),
  practice_city VARCHAR(64),
  practice_state VARCHAR(64),
  practice_zip VARCHAR(64),
  	primary key(k_practice_id),
    unique(gx_provider_id)
)
DISTSTYLE EVEN;
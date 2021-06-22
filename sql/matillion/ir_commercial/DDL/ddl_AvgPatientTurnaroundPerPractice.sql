DROP TABLE IF EXISTS ir_commercial.AvgPatientTurnaround;

CREATE TABLE IF NOT EXISTS ir_commercial.AvgPatientTurnaround
(
  business_name VARCHAR(256)    ENCODE raw,
  practice_id BIGINT ENCODE raw,
  avg_days int   ENCODE raw,
  primary key(practice_id)
)
;
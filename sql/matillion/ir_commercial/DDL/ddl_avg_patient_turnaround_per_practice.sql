DROP TABLE IF EXISTS ir_commercial.avg_patient_turnaround_per_practice;

CREATE TABLE IF NOT EXISTS ir_commercial.avg_patient_turnaround_per_practice
(
  business_name VARCHAR(256)    ENCODE raw,
  practice_id BIGINT ENCODE raw,
  avg_days int   ENCODE raw,
  primary key(practice_id)
)
;
DROP TABLE IF EXISTS ir_commercial.avg_patient_turnaround_per_practice;

CREATE TABLE IF NOT EXISTS ir_commercial.avg_patient_turnaround_per_practice
(
  business_name VARCHAR(256)    ENCODE raw,
  gx_provider_id BIGINT ENCODE raw,
  category VARCHAR(256)    ENCODE raw,
  AverageDays int   ENCODE raw,
  primary key(gx_provider_id)
)
;
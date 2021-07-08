DROP TABLE IF EXISTS ir_commercial.fulfillment_patient;

CREATE TABLE IF NOT EXISTS ir_commercial.fulfillment_patient
(
  gx_customer_id BIGINT ENCODE raw,
  patient_type VARCHAR(255)   ENCODE raw,
  gx_provider_id BIGINT ENCODE raw,
  patient_created DATE ENCODE raw,
  fulfillment_created_at DATE ENCODE raw,
  status VARCHAR(255)   ENCODE raw,
  next_service_date DATE ENCODE raw,
  service_date DATE ENCODE raw,
  type VARCHAR(255)   ENCODE raw,
  name VARCHAR(255)   ENCODE raw,
  fulfillment_id VARCHAR(255)   ENCODE raw,
  offering_id BIGINT ENCODE raw,
  days_since_patient_creation BIGINT ENCODE raw,
  primary key(gx_customer_id)
)
;
With PatientInfo As
(
   SELECT
      ir_commercial.patient.gx_customer_id,
      ir_commercial.patient.patient_type,
      ir_commercial.patient.gx_provider_id,
      DATE(ir_commercial.patient.created_at) AS patient_created,
      DATE(ir_commercial.fulfillment.created_at) AS fulfillment_created_at,
      ir_commercial.fulfillment.status,
      DATE(ir_commercial.fulfillment.next_service_date) AS next_service_date,
      DATE(ir_commercial.fulfillment.service_date) AS service_date,
      ir_commercial.fulfillment.type,
      ir_commercial.fulfillment.name,
      ir_commercial.fulfillment.fulfillment_id,
      ir_commercial.fulfillment.offering_id,
      DATEDIFF(day, patient_created, service_date) as days_since_patient_creation
   FROM
      ir_commercial.patient
      JOIN
         ir_commercial.fulfillment
         on ir_commercial.fulfillment.gx_customer_id = ir_commercial.patient.gx_customer_id
         AND ir_commercial.fulfillment.status = 'Completed'
   WHERE
      days_since_patient_creation >- 1
   ORDER BY
      days_since_patient_creation
)
Select
   *
from
   PatientInfo
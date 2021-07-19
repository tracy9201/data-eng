With PatientInfo As
(
   SELECT
      patient.gx_customer_id,
      patient.patient_type,
      patient.gx_provider_id,
      DATE(patient.created_at) AS patient_created,
      DATE(fulfillment.created_at) AS fulfillment_created_at,
      fulfillment.status,
      DATE(fulfillment.next_service_date) AS next_service_date,
      DATE(fulfillment.service_date) AS service_date,
      fulfillment.type,
      fulfillment.name,
      fulfillment.fulfillment_id,
      fulfillment.offering_id,
      DATEDIFF(day, patient_created, service_date) as days_since_patient_creation
   FROM
      ir_commercial.patient
      JOIN
         ir_commercial.fulfillment on fulfillment.gx_customer_id = patient.gx_customer_id 
         AND fulfillment.status = 'Completed'
   WHERE
      days_since_patient_creation >- 1
   ORDER BY
      days_since_patient_creation
)
Select
   *
from
   PatientInfo
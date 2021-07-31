SELECT
  id AS device_id,
  organization_id,
  merchant_id,
  label,
  status,
  device_uuid
FROM
  ${schema}${environment}.p2pe_device;

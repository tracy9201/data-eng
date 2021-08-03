SELECT
  id AS device_id,
  organization_id,
  merchant_id,
  label,
  status,
  device_uuid
FROM
  p2pe_hint${environment}.p2pe_device;

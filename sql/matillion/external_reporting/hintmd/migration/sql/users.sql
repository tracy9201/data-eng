SELECT
  id AS user_id,
  status,
  title,
  firstname,
  lastname,
  role,
  email,
  organization_id,
  created_at,
  deprecated_at,
  updated_at
FROM
  kronos_hint${environment}.users u
WHERE
  role IN (1, 2, 4, 6, 10)
;

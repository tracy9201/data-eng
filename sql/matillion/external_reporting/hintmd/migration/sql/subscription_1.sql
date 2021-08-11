SELECT
  id AS subscription_id,
  status,
  cycles,
  quantity,
  is_subscription,
  period_unit,
  period,
  gx_subscription_id,
  plan_id,
  offering_id,
  type AS subscription_type
FROM
  kronos_hint${environment}.subscription

WITH cataloged AS (
  SELECT
  DISTINCT
  IR.catalog,
  IR.category,
  IO.offering_id
  FROM
  ir_cs.brand_catalog_category IR
  INNER JOIN
  ir_commercial.offering IO
  ON (IO.factory_name = IR.brand)
  AND
  (
   IO.catalog_name = IR.catalog
  )
  WHERE
  category = {%parameter parameter_category%}
),

subs AS (
  SELECT
  ad_hoc_offering_id,
  amount_off,
  created_at,
  cycles,
  deprecated_at,
  discount_note,
  gx_subscription_id,
  id,
  is_subscription,
  IKHS.offering_id,
  percentage_off,
  period,
  period_unit,
  plan_id,
  quantity,
  status,
  tax_percentage,
  type,
  updated_at,
  cataloged.category,
  cataloged.catalog
  FROM
  internal_kronos_hint.subscription AS IKHS
  JOIN
  cataloged ON IKHS.offering_id = cataloged.offering_id
  WHERE
  type != 0 ORDER BY id
),

subscription AS (
  SELECT
  DISTINCT plan_id,
  category,
  catalog,
  cast(to_char(created_at,'MON-DD-YYYY') AS date) AS created_date,
  id AS sub_id,
  CASE
  WHEN (type=2) THEN
  (CASE
     WHEN (deprecated_at IS NOT null) THEN (cast(to_char(deprecated_at,'MON-DD-YYYY') AS date))
     ELSE (cast(to_char(DATEADD(month, 1*(period), created_at) ,'MON-DD-YYYY') AS date)) END )
     ELSE (cast(to_char(deprecated_at,'MON-DD-YYYY') AS date))
     END AS deprecated_date,
     CASE WHEN (type=2 OR type=1) THEN 1 ELSE 0 END AS isMember
     FROM subs subscription
),

customer AS (
  SELECT
  DISTINCT customer.user_id,
  sub_id,
  customer.status,
  subscription.created_date,
  subscription.deprecated_date,
  subscription.catalog,
  subscription.category,
  getdate(),
  isMember,
  CASE
  WHEN ismember = 0 THEN 0
  WHEN ismember = 1 AND to_timestamp(deprecated_date,'MM-DD-YYYY') < getdate() THEN 0
  WHEN ismember =1 AND to_timestamp(deprecated_date,'MM-DD-YYYY') >= getdate() THEN 1
  WHEN ismember = 1 and deprecated_date is NULL THEN 1
  END AS isMember2,
  gx_customer_id
  FROM internal_kronos_hint.customer_data customer
  JOIN
  internal_kronos_hint.plan plan
  ON customer.user_id = plan.user_id
  JOIN subscription
  ON plan.id = subscription.plan_id
  WHERE  ISmember =1
  ORDER BY user_id
),

final AS (
  SELECT
  user_id,
  created_date,
  deprecated_date,
  getdate(),
  ISmember,
  ismember2,
  sum(ismember2) OVER (PARTITION by USER_id) AS ISmember3,
  gx_customer_id,
  gx_provider_id,
  catalog,
  category
  FROM customer
  JOIN
  internal_kronos_hint.users users
  ON users.id = customer.user_id
  JOIN
  internal_kronos_hint.organization_data organization_data
  ON users.organization_id = organization_data.id
  WHERE
  (organization_data.name NOT like 'zz%'
   OR organization_data.name NOT like 'zzz%'
   OR organization_data.name NOT like 'Hint%' )
  ),

finalstatus AS (
  SELECT
   gx_customer_id,
   catalog, 
   category,
   MIN(CASE WHEN ISmember = 1 THEN created_date END) AS created_date,
    CASE
    WHEN ISmember3 = 0 THEN MAX(deprecated_date)
    WHEN ISmember3> 0 THEN NULL
    END AS updated_date,
    CASE WHEN ISmember3>0 THEN 'active' ELSE 'inactive' END AS status,
    gx_provider_id
    FROM final
    GROUP BY
    gx_customer_id,
    user_id,
    ismember3,
    gx_provider_id, catalog, category
    ORDER BY
    created_date,
    user_id
),
              
main AS (
  SELECT
    ROW_NUMBER() OVER () AS id,
    *
    FROM finalstatus
    )
              
SELECT * FROM main
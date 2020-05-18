
----- dim_offering ---------------------

BEGIN;

DELETE FROM DWH.dim_offering;

INSERT INTO dwh.dim_offering
(
  SELECT
  gx_subscription_id
  ,offering.name as product_service
  ,subscription.status as subscription_status
  ,catalog_item.name as brand
  ,sku
  FROM rds_data.k_subscription subscription
  LEFT JOIN rds_data.k_offering offering on offering_id = offering.id
  LEFT JOIN rds_data.k_catalog_item catalog_item on catalog_item.id = catalog_item_id
  WHERE subscription.status in (0,7)
);

COMMIT;

-----dim_customer --------------

BEGIN;

DELETE FROM  DWH.dim_customer;

INSERT INTO  dwh.dim_customer
(
   SELECT customer_data.id AS k_customer_id
   ,member_on_boarding_date
   ,member_cancel_date, email AS customer_email
   ,CASE WHEN mobile IS NULL or mobile = '' then mobile else '(' || substring(mobile,3,3) || ') ' || substring(mobile,6,3) || '-' || substring(mobile,9,4)  END as customer_mobile
   ,gender AS customer_gender
   ,extract(YEAR FROM birth_date_utc) AS customer_birth_year
   ,gx_customer_id
   ,CASE WHEN customer_data.type = 1 THEN 'Guest' WHEN member_on_boarding_date IS NULL THEN  'Non-Subscriber' ELSE 'Subscriber'  END as customer_type
   ,city AS customer_city
   ,state AS customer_state
   ,zip AS customer_zip
   ,customer_data.type AS user_type
   ,firstname, lastname
    FROM rds_data.k_users users
    JOIN rds_data.k_customer_data customer_data ON users.id = user_id
    LEFT JOIN rds_data.k_plan plan ON plan.user_id = users.id
    LEFT JOIN
        (
          SELECT plan_id
          ,to_char(min(CASE WHEN subscription.type =1  THEN subscription.created_at WHEN subscription.type=2 THEN subscription.created_at ELSE NULL end), 'yyyy-mm-dd') AS member_on_boarding_date
          ,to_char(max(CASE WHEN subscription.type =1  THEN subscription.deprecated_at WHEN subscription.type=2 THEN subscription.deprecated_at ELSE NULL end), 'yyyy-mm-dd') AS member_cancel_date
          FROM rds_data.k_subscription subscription 
          WHERE  subscription.status=0 
          GROUP BY plan_id
        ) AS sub ON plan_id = plan.id
    LEFT JOIN rds_data.k_address address ON billing_address_id = address.id
    WHERE role=8 
    AND users.status=0
 );

COMMIT;

----------- dim_provider ------------------
BEGIN;

DELETE FROM  DWH.dim_provider;

INSERT INTO  dwh.dim_provider
(
      SELECT organization_data.id AS k_practice_id, gx_provider_id, activated_at AS practice_activated_at, timezone AS practice_time_zone, lastname AS practice_name, city AS practice_city, state AS practice_state, zip AS practice_zip
      FROM rds_data.k_organization_data organization_data
      JOIN rds_data.k_users users ON organization_data.id = organization_id
      JOIN rds_data.k_address address ON address.id = address_id
      WHERE role = 7
  );

COMMIT;
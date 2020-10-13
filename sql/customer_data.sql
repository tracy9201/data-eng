----- Data Pipeline: v4_customer2 ---------------------
----- Redshift Table: customer_data ---------------------
----- Looker View: customer_data ---------------------


select users.id as user_id,
  customer_data.id as customer_id,
  gx_customer_id,
  shipping_address_id,
  customer_data.status,
  customer_data.created_at,
  customer_data.updated_at,
  customer_data.deprecated_at,
  firstname,
  right(mobile, 4) as mobile,
  users.organization_id,
  gender,
  date_part('year', birth_date_utc) as birth_year,
  lastname,
  email
from customer_data
  join users on user_id = users.id
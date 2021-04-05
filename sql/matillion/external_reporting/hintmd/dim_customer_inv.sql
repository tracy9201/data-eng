with customer as
 (
   SELECT
   customer_data.id AS k_customer_id
   ,member_on_boarding_date
   ,member_cancel_date
   ,email AS customer_email
   ,CASE WHEN mobile IS NULL or mobile = '' then mobile else '(' || substring(mobile,3,3) || ') ' || substring(mobile,6,3) || '-' || substring(mobile,9,4)  END as customer_mobile
   ,gender AS customer_gender
   ,extract(YEAR FROM birth_date_utc) AS customer_birth_year
   ,gx_customer_id
   ,CASE WHEN customer_data.type = 1 THEN 'Guest' WHEN member_on_boarding_date IS NULL THEN  'Non-Subscriber' ELSE 'Subscriber'  END as customer_type
   ,city AS customer_city
   ,state AS customer_state
   ,zip AS customer_zip
   ,customer_data.type AS user_type
   ,firstname
   ,lastname
    FROM kronos.users users
    JOIN kronos.customer_data customer_data ON users.id = user_id
    LEFT JOIN kronos.plan plan ON plan.user_id = users.id
    LEFT JOIN
        (SELECT
          plan_id
          ,to_char(min(CASE WHEN subscription.type =1  THEN subscription.created_at WHEN subscription.type=2 THEN subscription.created_at ELSE NULL end), 'yyyy-mm-dd') AS member_on_boarding_date
          ,to_char(max(CASE WHEN subscription.type =1  THEN subscription.deprecated_at WHEN subscription.type=2 THEN subscription.deprecated_at ELSE NULL end), 'yyyy-mm-dd') AS member_cancel_date
          FROM kronos.subscription subscription
          WHERE  subscription.status=0
          GROUP BY plan_id
          ) AS sub ON plan_id = plan.id
    LEFT JOIN kronos.address address ON billing_address_id = address.id
    WHERE role=8
    AND users.status=0
 )
select * from customer

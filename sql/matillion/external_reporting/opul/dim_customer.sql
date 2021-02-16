WITH sub_plan AS 
(SELECT
    plan_id,
    to_char(min(CASE WHEN subscription.type in (1,2) THEN subscription.created_at ELSE NULL END),'yyyy-mm-dd') AS member_on_boarding_date,
    to_char(max(CASE WHEN subscription.type in (1,2) THEN subscription.deprecated_at ELSE NULL END),'yyyy-mm-dd') AS member_cancel_date  
FROM
    kronos_opul.subscription as subscription
WHERE
    subscription.status=0  
GROUP BY
    plan_id 
), 

customer AS 
( SELECT
    customer_data.id AS k_customer_id,
    member_on_boarding_date,
    member_cancel_date,
    email AS customer_email,
    mobile AS customer_mobile,
    gender AS customer_gender,
    extract(YEAR  FROM birth_date_utc) AS customer_birth_year,
    gx_customer_id,
    CASE          
        WHEN member_on_boarding_date IS NULL THEN 'non-member'          
        ELSE 'member'      
    END AS member_type,
    city AS customer_city,
    state AS customer_state,
    zip AS customer_zip,
    customer_data.type AS user_type,
    firstname,
    lastname  
FROM kronos_opul.users  users
JOIN kronos_opul.customer_data customer_data ON users.id = user_id  
LEFT JOIN kronos_opul.plan plan ON plan.user_id = users.id  
LEFT JOIN sub_plan ON plan_id = plan.id  
LEFT JOIN kronos_opul.address address ON billing_address_id = address.id 
) ,

main as
(   
    SELECT
    k_customer_id,
    member_on_boarding_date,
    member_cancel_date,
    customer_email,
    coalesce(CASE WHEN customer_mobile IS NULL or customer_mobile = '' THEN customer_mobile else '(' || substring(customer_mobile,3,3) || ') ' || substring(customer_mobile,6,3) || '-' || substring(customer_mobile,9,4)  END, ' ') AS customer_mobile,
    customer_gender,
    customer_birth_year,
    gx_customer_id,
    member_type,
    customer_city,
    customer_state,
    customer_zip,
    user_type,
    coalesce(CASE WHEN customer.user_type = 1 THEN 'Guest' 
                  WHEN customer.user_type =0 THEN (CASE WHEN customer.member_type = 'member'  THEN 'Subscriber' ELSE 'Non-Subscriber' END) 
                  END,' ') AS customer_type,
    firstname,
    lastname  
    FROM customer
)


SELECT * FROM main

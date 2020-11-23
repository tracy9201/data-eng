WITH sub_plan AS 
(SELECT
    plan_id,
    to_char(min(CASE WHEN subscription.type in (1,2) THEN subscription.created_at ELSE NULL end),'yyyy-mm-dd') AS member_on_boarding_date,
    to_char(max(CASE WHEN subscription.type in (1,2) THEN subscription.deprecated_at ELSE NULL end),'yyyy-mm-dd') AS member_cancel_date  
FROM
    subscription  
WHERE
    subscription.status=0  
GROUP BY
    plan_id 
), 

main AS 
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
FROM
    users  
JOIN
    customer_data          
        ON users.id = user_id  
LEFT JOIN
    plan          
        ON plan.user_id = users.id  
LEFT JOIN
    sub_plan          
        ON plan_id = plan.id  
LEFT JOIN
    address          
        ON billing_address_id = address.id 
) 
SELECT * FROM main;

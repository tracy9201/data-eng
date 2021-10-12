with guest_name as (
SELECT distinct
    cud.gx_customer_id,
    card_holder_name
FROM
    gaia_opul${environment}.payment p
LEFT JOIN
 (SELECT distinct 
  gt.payment_id, 
  card_payment_gateway_id
FROM  gaia_opul${environment}.gateway_transaction gt
WHERE 
  card_payment_gateway_id IS NOT NULL and card_payment_gateway_id != 0
  and gt.payment_id is not null) gt
        ON gt.payment_id = p.id
LEFT JOIN
    gaia_opul${environment}.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul${environment}.card card
        ON cpg.card_id = card.id
left join 
    gaia_opul${environment}.plan plan
        on p.plan_id = plan.id
left join 
    gaia_opul${environment}.customer cus
        on cus.id = plan.customer_id
left join 
    kronos_opul${environment}.customer_data cud
        on cus.encrypted_ref_id = cud.gx_customer_id
WHERE
    p.id IS NOT NULL
    AND p.status  in (1,-3)
    AND p.type = 'credit_card'
    AND cud.type = 1
 ),
 
sub_plan AS 
(SELECT
    plan_id,
    to_date(min(CASE WHEN subscription.type in (1,2) THEN subscription.created_at ELSE NULL END),'yyyy-mm-dd') AS member_on_boarding_date,
    to_date(max(CASE WHEN subscription.type in (1,2) THEN subscription.deprecated_at ELSE NULL END),'yyyy-mm-dd') AS member_cancel_date  
FROM
    kronos_opul${environment}.subscription as subscription
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
    customer_data.gx_customer_id,
    CASE          
        WHEN member_on_boarding_date IS NULL THEN 'non-member'          
        ELSE 'member'      
    END AS member_type,
    city AS customer_city,
    state AS customer_state,
    zip AS customer_zip,
    customer_data.type AS user_type,
    firstname,
    lastname,
    guest_name.card_holder_name as full_name,
    users.created_at,
    users.updated_at,
    current_timestamp::timestamp as dwh_created_at
FROM kronos_opul${environment}.users  users
JOIN kronos_opul${environment}.customer_data customer_data ON users.id = customer_data.user_id  
LEFT JOIN kronos_opul${environment}.plan plan ON plan.user_id = users.id  
LEFT JOIN sub_plan ON sub_plan.plan_id = plan.id  
LEFT JOIN kronos_opul${environment}.address address ON billing_address_id = address.id 
LEFT JOIN guest_name on customer_data.gx_customer_id = guest_name.gx_customer_id
) ,

main as
(   
    SELECT
    k_customer_id,
    member_on_boarding_date,
    member_cancel_date,
    customer_email,
    coalesce(CASE WHEN customer_mobile IS NULL or customer_mobile = '' THEN customer_mobile else '(' || substring(customer_mobile,3,3) || ') ' || substring(customer_mobile,6,3) || '-' || substring(customer_mobile,9,4)  END, 'N/A') AS customer_mobile,
    customer_gender,
    customer_birth_year,
    gx_customer_id,
    member_type,
    customer_city,
    customer_state,
    customer_zip,
    user_type,
    coalesce(CASE WHEN user_type = 1 THEN 'Guest' 
                  WHEN user_type =0 THEN (CASE WHEN member_type = 'member'  THEN 'Subscriber' ELSE 'Non-Subscriber' END) 
                  END,' ') AS customer_type,
    firstname,
    lastname,
    case when user_type = 0 then firstname||' '||lastname else full_name end as full_name,
    created_at,
    updated_at,
    dwh_created_at  
    FROM customer
)


SELECT * FROM main 



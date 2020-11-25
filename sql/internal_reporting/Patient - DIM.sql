select
    gx_customer_id,
    case when customer_data.type = 1 then 'guest_checkout' else 'customer' end as patient_type,
    case 
        when gender = 0 then 'unknown'
        when gender = 1 then 'male'
        when gender = 2 then 'female'
        end as gender,
    organization_id,
    left (firstname, 2) ||'****' as firstname,
    user_id,
    to_char(birth_date_utc, 'yyyy') as birth_year,
    city,
    state,
    created_at,
    deprecated_at
from customer_data 
inner join 
    users 
        on users.id = user_id
inner join 
    v4_k_address add
        on billing_address_id = add.id
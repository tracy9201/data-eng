WITH main AS(
select
    customer_data.gx_customer_id,
    case 
      when customer_data.type = 1 then 'guest_checkout' 
      else 'customer' 
      end as patient_type,
    case 
        when customer_data.gender = 0 then 'unknown'
        when customer_data.gender = 1 then 'male'
        when customer_data.gender = 2 then 'female'
        end as gender,
    users.organization_id,
    customer_data.user_id,
    cast(to_char(customer_data.birth_date_utc, 'yyyy') as integer) as birth_year,
    add.city,
    add.state,
    customer_data.created_at,
    customer_data.deprecated_at
from kronos.customer_data 
inner join 
    kronos.users 
        on users.id = customer_data.user_id
left join 
    kronos.address add
        on customer_data.billing_address_id = add.id
)
SELECT * FROM main
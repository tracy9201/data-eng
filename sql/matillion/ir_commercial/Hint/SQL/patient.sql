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
    org.gx_provider_id,
    cast(to_char(customer_data.birth_date_utc, 'yyyy') as integer) as birth_year,
    add.city,
    add.state,
    customer_data.created_at,
    customer_data.deprecated_at,
    least(customer_data.updated_at,users.updated_at,add.updated_at,org.updated_at) as updated_at,
    current_timestamp::timestamp as dwh_created_at
from internal_kronos_hint.customer_data 
inner join 
    internal_kronos_hint.users 
        on users.id = customer_data.user_id
left join 
    internal_kronos_hint.address add
        on customer_data.billing_address_id = add.id
left join 
    internal_kronos_hint.organization_data org
        on users.organization_id = org.id
)
SELECT * FROM main
WITH main as (
select 
    ful.id as fulfillment_id, 
    ful.created_at, 
    ful.deleted_at as deprecated_at, 
    ful.canceled_at, 
    ful.status, 
    round(cast(ful.quantity_rendered as numeric)/100,2) as quantity_rendered,
    ful.next_service_date, 
    ful.service_date, 
    round(cast(sub.subtotal as numeric)/100,2) as value,
    round(cast(sub.tax as numeric)/100,2) as tax_value,
    round(cast(ful.shipping_cost as numeric)/100,2) as shipping_cost,
    ful.type, 
    ful.name, 
    sub.offering_id,
    cus.gx_customer_id,
    org.gx_provider_id,
    sub.encrypted_ref_id as gx_subscription_id,
    least(ful.updated_at,sub.updated_at,plan.updated_at,cus.updated_at,users.updated_at,org.updated_at) as updated_at,
    current_timestamp::timestamp as dwh_created_at
from internal_gaia_opul.fulfillment ful
left join 
    internal_gaia_opul.subscription sub 
        on ful.subscription_id = sub.id
left join 
    internal_gaia_opul.plan plan
        on sub.plan_id = plan.id
left join 
    internal_kronos_opul.customer_data cus
        on cus.user_id = plan.customer_id
left join 
    internal_kronos_opul.users users
        on plan.customer_id = users.id
left join 
    internal_kronos_opul.organization_data org
        on org.id = users.organization_id
)
SELECT * FROM main
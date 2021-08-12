WITH main as (
select 
    ful.id as fulfillment_id, 
    ful.created_at, 
    ful.deprecated_at, 
    ful.cancelled_at, 
    ful.status, 
    round(cast(ful.quantity_rendered as numeric)/100,2) as quantity_rendered,
    ful.next_service_date, 
    ful.service_date, 
    round(cast(ful.value as numeric)/100,2) as value,
    round(cast(ful.tax_value as numeric)/100,2) as tax_value,
    round(cast(ful.shipping_cost as numeric)/100,2) as shipping_cost,
    ful.type, 
    ful.name, 
    sub.offering_id,
    cus.gx_customer_id,
    org.gx_provider_id,
    sub.gx_subscription_id
from internal_kronos_hint.cached_gx_fulfillment ful
left join 
    internal_kronos_hint.subscription sub 
        on ful.gx_subscription_id = sub.gx_subscription_id
left join 
    internal_kronos_hint.plan plan
        on sub.plan_id = plan.id
left join 
    internal_kronos_hint.customer_data cus
        on cus.user_id = plan.user_id
left join 
    internal_kronos_hint.users users
        on plan.user_id = users.id
left join 
    internal_kronos_hint.organization_data org
        on org.id = users.organization_id
)
SELECT * FROM main
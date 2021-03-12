WITH main as (
select 
    ful.id, 
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
    plan.user_id
from kronos.cached_gx_fulfillment ful
left join 
    kronos.subscription sub 
        on ful.gx_subscription_id = sub.gx_subscription_id
left join 
    kronos.plan plan
        on sub.plan_id = plan.id
)
SELECT * FROM main
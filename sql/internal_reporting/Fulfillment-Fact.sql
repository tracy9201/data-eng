select 
    ful.id, 
    ful.created_at, 
    ful.deprecated_at, 
    ful.cancelled_at, 
    ful.status, 
    ful.quantity_rendered, 
    ful.next_service_date, 
    ful.service_date, 
    ful.value, 
    ful.tax_value, 
    shipping_cost, 
    ful.type, 
    ful.name, 
    offering_id
from cached_gx_fulfillment ful
left join 
    v4_k_subscription sub 
        on ful.gx_subscription_id = sub.gx_subscription_id
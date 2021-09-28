WITH main as (
select  
    offering.id as offering_id, 
    offering.name as offering_name, 
    catalog_item.name as catalog_name, 
    catalog_item_id as catalog_id, 
    brand.name as factory_name, 
    catalog_item.brand_id as factory_id, 
    round(cast(offering.pay_in_full_price as numeric )/100,2) as offering_pay_in_full_price, 
    round(cast(offering.subscription_price as numeric )/100,2) as offering_subscription_price, 
    round(cast(offering.pay_over_time_price as numeric )/100,2) as offering_pay_over_time_price, 
    round(cast(offering.service_tax as numeric )/100,2) as offering_service_tax, 
    offering.status as offering_status, 
    org.gx_provider_id, 
    offering.created_at as offering_created_at, 
    catalog_item.created_at as catalog_created_at, 
    catalog_item.status as catalog_status, 
    round(cast(catalog_item.wholesale_price as numeric )/100,2) as catalog_wholesale_price, 
    catalog_item.bd_status, 
    brand.created_at as brand_created_at,
    least(offering.updated_at,catalog_item.updated_at,brand.updated_at,org.updated_at) as updated_at,
    current_timestamp::timestamp as dwh_created_at
from  internal_kronos_opul.offering offering
left join 
    internal_kronos_opul.catalog_item catalog_item
        on offering.catalog_item_id = catalog_item.id
left join  
    internal_kronos_opul.brand brand
        on catalog_item.brand_id = brand.id
left join
    internal_kronos_opul.organization_data org
        on org.id = offering.organization_id
)
SELECT * FROM main
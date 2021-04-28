WITH main as (
select  
    offering.id as offering_id, 
    offering.name as offering_name, 
    catalog_item.name as catalog_name, 
    offering.catalog_item_id as catalog_id, 
    brand.name as factory_name, 
    catalog_item.brand_id as factory_id, 
    round(cast(offering.pay_in_full_price as numeric )/100,2) as offering_pay_in_full_price, 
    round(cast(offering.subscription_price as numeric )/100,2) as offering_subscription_price, 
    round(cast(offering.pay_over_time_price as numeric )/100,2) as offering_pay_over_time_price, 
    round(cast(offering.service_tax as numeric )/100,2) as offering_service_tax, 
    offering.status as offering_status, 
    offering.organization_id, 
    offering.created_at as offering_created_at, 
    catalog_item.created_at as catalog_created_at, 
    catalog_item.status as catalog_status, 
    round(cast(catalog_item.wholesale_price as numeric )/100,2) as catalog_wholesale_price, 
    catalog_item.bd_status, 
    catalog_item.sku,
    brand.created_at as brand_created_at,
    offering.created_at,
    offering.updated_at,
    current_timestamp::timestamp as dwh_created_at
from  kronos_opul${environment}.offering offering
left join 
    kronos_opul${environment}.catalog_item catalog_item
        on offering.catalog_item_id = catalog_item.id
left join  
    kronos_opul${environment}.brand brand
        on catalog_item.brand_id = brand.id
)
SELECT * FROM main
select  
    offering.id as offering_id, 
    offering.name as offering_name, 
    catalog_item.name as catalog_name, 
    catalog_item_id as catalog_id, 
    brand.name as factory_name, 
    brand_id as factory_id, 
    pay_in_full_price as offering_pay_in_full_price, 
    subscription_price as offering_subscription_price, 
    pay_over_time_price as offering_pay_over_time_price, 
    service_tax as offering_service_tax, 
    offering.status as offering_status, 
    offering.organization_id, 
    offering.created_at as offering_created_at, 
    catalog_item.created_at as catalog_created_at, 
    catalog_item.status as catalog_status, 
    catalog_item.wholesale_price as catalog_wholesale_price, 
    bd_status, 
    brand.created_at as brand_created_at
from  kronos.offering offering
left join 
    kronos.catalog_item catalog_item
        on catalog_item_id = catalog_item.id
left join  
    kronos.brand brand
        on brand_id = brand.id
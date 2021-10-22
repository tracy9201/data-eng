WITH main as (
select  
    practice_catalog_item.id as offering_id, 
    practice_catalog_item.name as offering_name, 
    master_catalog_item.name as catalog_name, 
    practice_catalog_item.master_catalog_item_id as catalog_id, 
    brand.name as factory_name, 
    master_catalog_item.brand_id as factory_id, 
    round(cast(practice_catalog_item.pay_in_full_price as numeric )/100,2) as offering_pay_in_full_price, 
    round(cast(practice_catalog_item.subscription_price as numeric )/100,2) as offering_subscription_price, 
    round(cast(practice_catalog_item.tax_rate as numeric )/100,2) as offering_service_tax, 
    practice_catalog_item.status as offering_status, 
    practice_catalog_item.organization_id, 
    practice_catalog_item.created_at as offering_created_at, 
    master_catalog_item.created_at as catalog_created_at, 
    master_catalog_item.status as catalog_status, 
    round(cast(master_catalog_item.wholesale_price as numeric )/100,2) as catalog_wholesale_price, 
    master_catalog_item.sku,
    master_catalog_item.wholesale_price as master_wholesale_price,
    practice_catalog_item.wholesale_price as practice_wholesale_price,
    master_catalog_item.item_type,
    catalog_item_category.name as item_category,
    brand.created_at as brand_created_at,
    practice_catalog_item.created_at,
    practice_catalog_item.updated_at,
    current_timestamp::timestamp as dwh_created_at
  FROM catalog${environment}.master_catalog_item 
      left join catalog${environment}.brand on master_catalog_item.brand_id = brand.id
      LEFT JOIN catalog${environment}.catalog_item_category  on catalog_item_category.id = master_catalog_item.primary_category_id
      left join catalog${environment}.practice_catalog_item  on master_catalog_item.id = practice_catalog_item.master_catalog_item_id
)
SELECT * FROM main
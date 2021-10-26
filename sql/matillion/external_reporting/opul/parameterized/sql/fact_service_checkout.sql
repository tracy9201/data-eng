WITH main as (
select  
    pci.id as offering_id,
    pci.name as offering_name, 
    mci.name as catalog_name, 
    pci.master_catalog_item_id as catalog_id, 
    brand.name as factory_name, 
    mci.brand_id as factory_id, 
    round(cast(pci.pay_in_full_price as numeric )/100,2) as offering_pay_in_full_price, 
    round(cast(pci.subscription_price as numeric )/100,2) as offering_subscription_price, 
    round(cast(pci.tax_rate as numeric )/100,2) as offering_service_tax, 
    pci.status as offering_status, 
    pci.organization_id, 
    pci.created_at as offering_created_at, 
    mci.created_at as catalog_created_at, 
    mci.status as catalog_status, 
    round(cast(mci.wholesale_price as numeric )/100,2) as master_wholesale_price, 
    mci.sku,
    round(cast(pci.wholesale_price as numeric )/100,2) as practice_wholesale_price,
    mci.item_type,
    cic.name as item_category,
    brand.created_at as brand_created_at,
    pci.created_at,
    pci.updated_at,
    current_timestamp::timestamp as dwh_created_at
  FROM catalog${environment}.master_catalog_item mci
      left join catalog${environment}.brand on mci.brand_id = brand.id
      LEFT JOIN catalog${environment}.catalog_item_category cic on cic.id = mci.primary_category_id
      left join catalog${environment}.practice_catalog_item  pci on mci.id = pci.master_catalog_item_id
  WHERE pci.id is not null
)
SELECT * FROM main
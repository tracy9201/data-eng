with offering as
  (
    SELECT distinct
    gx_subscription_id
    ,plan_id
    ,subscription.status as subscription_status
    ,catalog_item.name as product_service
    ,brand.name as brand
    ,sku
    FROM kronos.subscription subscription
    LEFT JOIN kronos.offering offering on offering_id = offering.id
    LEFT JOIN kronos.catalog_item catalog_item on catalog_item.id = catalog_item_id
    left join kronos.brand brand on brand.id = brand_id
    WHERE subscription.status in (0,7)

)
select * from offering

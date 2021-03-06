----- Data Pipeline: v4_k_offering_catalog_factory ---------------------
----- Redshift Table: v4_k_offering_catalog_factory ---------------------
----- Looker View: offering_catalog_factory ---------------------

select v4_k_subscription.id as subscription_id,
  cached_gx_subscription.name as offering_name,
  v4_k_offering.id as offering_id,
  v4_k_catalog_item.name as catalog_name,
  catalog_item_id as catalog_id,
  v4_k_brand.name as factory_name,
  brand_id as factory_id,
  case when v4_k_brand.name = 'ZO Skin Health' or v4_k_brand.name = 'Alastin Skincare' then 'yes' else 'no' end as is_skin_care,
  pay_in_full_price as offering_pay_in_full_price,
  subscription_price as offering_subscription_price,
  pay_over_time_price as offering_pay_over_time_price,
  service_tax as offering_service_tax,
  v4_k_offering.status as offering_status,
  v4_k_offering.organization_id,
  v4_k_offering.created_at as offering_created_at,
  v4_k_catalog_item.created_at as catalog_created_at,
  v4_k_catalog_item.status as catalog_status,
  v4_k_catalog_item.wholesale_price as catalog_wholesale_price, bd_status,
  v4_k_brand.created_at as brand_created_at
from v4_k_subscription
  join cached_gx_subscription on v4_k_subscription.gx_subscription_id = cached_gx_subscription.id
  left join v4_k_offering on v4_k_subscription.offering_id = v4_k_offering.id
  left join v4_k_catalog_item on catalog_item_id = v4_k_catalog_item.id
  left join v4_k_brand on brand_id = v4_k_brand.id
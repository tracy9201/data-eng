 ----- Data Pipeline: v4_k_fulfillment ---------------------
 ----- Redshift Table: v4_k_fulfillment ---------------------
----- Looker View: fulfillment ---------------------
 
 select id,
   created_at,
   updated_at,
   deprecated_at,
   cancelled_at,
   status,
   gx_subscription_id,
   quantity_balance,
   quantity_rendered,
   next_service_date,
   service_date,
   value,
   tax_value,
   gx_shipping_address_id,
   shipping,
   shipping_cost,
   tracking_id,
   tracking_url,
   type,
   name
 from cached_gx_fulfillment
 ----- Data Pipeline: v4_g_adjustment ---------------------
 ----- Redshift Table: v4_g_adjustment ---------------------
 ----- Looker View: adjustment ---------------------
 
 
 SELECT id,
   name,
   payment_gateway_id,
   authorisation_id,
   funding_adjustment_id,
   funding_master_id,
   category,
   type,
   amount,
   description,
   currency,
   date_changed,
   date_added,
   status,
   created_at,
   updated_at,
   canceled_at,
   deleted_at,
   encrypted_ref_id
 FROM public.adjustment;
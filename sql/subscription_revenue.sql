----- Data Pipeline: v4_ach_revenue ---------------------
----- Redshift Table: v4_ach_revenue ---------------------
----- Looker View: subscription_revenue ---------------------
 
 select transaction_name,
   payment_amount,
   type,
   created_at,
   invoice_id,
   plan_id,
   customer_id,
   name as practice_name
 from v4_g_plantform_revenue
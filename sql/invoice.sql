----- Data Pipeline: v4_g_invoice ---------------------
----- Redshift Table: v4_g_invoice ---------------------
----- Looker View: invoice ---------------------


select id,
  plan_id,
  quantity,
  amount,
  due_date,
  pay_date,
  application_fee,
  attempts,
  amount_paid,
  charge_id,
  total_credit,
  total_discount,
  total_coupon,
  total_payment,
  currency,
  total_tax,
  tax_percentage,
  subtotal,
  total,
  starting_balance,
  ending_balance,
  name,
  canceled_at,
  deleted_at,
  status,
  created_at,
  updated_at,
  encrypted_ref_id
FROM public.v4_g_invoice;
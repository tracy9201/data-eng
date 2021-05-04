With Main as (
select k_sub.id as subscription_id,
  k_sub.plan_id,
  k_sub.created_at,
  k_sub.updated_at,
  k_sub.deprecated_at,
  g_sub.renewal_count as multiple_treatments_times,
  g_sub.quantity as product_quantity,
  g_sub.unit_name as product_unit_name,
  case when k_sub.deprecated_at is null and k_sub.type in (1,2) then 'yes' else 'no' end as subscription_status,
  g_sub.end_count as treatment_period,
  g_sub.auto_renewal as is_subscription,
  case when k_sub.type =0  then 'One Time Treatment'
    when k_sub.type = 2 then 'Multiple Treatments'
    when k_sub.type =1 then 'Recurring Treatments'
    end as subscription_type,
  k_sub.deprecated_at as cancelled_at,
  g_sub.remaining_payment,
  g_sub.balance as payment_balance,
  g_sub.discount_amts ,
  g_sub.tax,
  g_sub.total as total_payment,
  g_sub.start_date as current_period_start_date,
  g_sub.end_date as current_period_end_date,
  k_sub.gx_subscription_id,
  g_sub.offering_id, 
  g_sub.name as subscription_name,
gaia_opul.subscription.status as g_status
from gaia_opul.subscription g_sub
join kronos_opul.subscription k_sub
on k_sub.gx_subscription_id = g_sub.encrypted_ref_id
)
select * from man
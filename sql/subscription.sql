----- Data Pipeline: v4_g_subscription ---------------------
----- Redshift Table: v4_g_subscription ---------------------
----- Looker View: subscription ---------------------

select v4_k_subscription.id as subscription_id,
  v4_k_subscription.plan_id,
  v4_k_subscription.created_at,
  v4_k_subscription.updated_at,
  v4_k_subscription.deprecated_at,
  renewal_count as multiple_treatments_times,
  v4_g_subscription.quantity as product_quantity,
  v4_g_subscription.unit_name as product_unit_name,
  case when v4_k_subscription.deprecated_at is null and v4_k_subscription.type in (1,2) then 'yes' else 'no' end as subscription_status,
  end_count as treatment_period,
  auto_renewal as is_subscription,
  case when v4_k_subscription.type =0  then 'One Time Treatment'
    when v4_k_subscription.type = 2 then 'Multiple Treatments'
    when v4_k_subscription.type =1 then 'Recurring Treatments'
    end as subscription_type,
  v4_k_subscription.deprecated_at as cancelled_at,
  remaining_payment,
  balance as payment_balance,
  discount_amts ,
  tax,
  total as total_payment,
  start_date as current_period_start_date,
  end_date as current_period_end_date,
  gx_subscription_id,
  v4_k_subscription.offering_id, v4_g_subscription.name as subscription_name
from v4_g_subscription
join v4_k_subscription
on gx_subscription_id = v4_g_subscription.encrypted_ref_id

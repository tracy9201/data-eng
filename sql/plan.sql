----- Data Pipeline: v4_k_plan ---------------------
----- Redshift Table: v4_k_plan ---------------------
----- Looker View: plan ---------------------

select plan_id,
  gx_plan_id,
  user_id,
  to_char(min(case when v4_k_subscription.type in (1,2) then v4_k_subscription.created_at else null end), 'yyyy-mm-dd')  as plan_first_date,
  v4_k_plan.created_at,
  v4_k_plan.updated_at,
  v4_k_plan.deprecated_at,
  sum(case when v4_k_subscription.type in (1,2) and v4_k_subscription.deprecated_at is null then 1 else 0 end) as plan_active,
  to_char(max(case when v4_k_subscription.type in (1,2) then v4_k_subscription.deprecated_at  else null end), 'YYYY-MM-DD') as plan_ended_date,
  sum(case when v4_k_subscription.type in (1,2) then 1 else 0 end) as member_recoganize,
  count(v4_k_subscription.id) as num_of_subscription,
  min(case when v4_k_subscription.type in (1,2) then v4_k_subscription.created_at else null end) as on_boarding_date
from v4_k_plan
  join v4_k_subscription on plan_id = v4_k_plan.id
group by plan_id, v4_k_plan.created_at, gx_plan_id, user_id, v4_k_plan.created_at, v4_k_plan.updated_at, v4_k_plan.deprecated_at

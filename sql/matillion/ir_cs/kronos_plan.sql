With Main as (
select plan_id,
            plan.gx_plan_id,
            plan.user_id,
            to_char(min(case when sub.type in (1,2) then sub.created_at else null end), 'yyyy-mm-dd')  as plan_first_date,
            plan.created_at,
            plan.updated_at,
            plan.deprecated_at,
            sum(case when sub.type in (1,2) and sub.deprecated_at is null then 1 else 0 end) as plan_active,
            to_char(max(case when sub.type in (1,2) then sub.deprecated_at  else null end), 'YYYY-MM-DD') as plan_ended_date,
            sum(case when sub.type in (1,2) then 1 else 0 end) as member_recoganize,
            count(sub.id) as num_of_subscription,
            min(case when sub.type in (1,2) then sub.created_at else null end) as on_boarding_date
      from kronos.plan plan
      join kronos.subscription sub
      on sub.plan_id = plan.id
      group by 
        plan_id, 
        plan.created_at, 
        plan.gx_plan_id, 
        plan.user_id, 
        plan.created_at, 
        plan.updated_at, 
        plan.deprecated_at 

)
select * from main
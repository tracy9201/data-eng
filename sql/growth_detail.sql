----- Data Pipeline: v4_growth_detail ---------------------
----- Redshift Table: v4_growth_detail ---------------------
----- Looker View: v4_growth_detail ---------------------


select count (practice_name) over (order by growth_date, practice_name) as id,
  *
from
(
  select case when provider_name1 is null then provider_name2 else provider_name1 end as practice_name,
    case when on_boarding_date is null then cancel_date else on_boarding_date end as growth_date,
    case when daily_created is null then 0 else daily_created end as created,
    case when daily_canceled is null then 0 else daily_canceled end as cancelled,
    case when daily_created is null then 0 else daily_created end - case when daily_canceled is null then 0 else daily_canceled end as active
  from
  (
    select provider_name1,
      on_boarding_date,
      count(user_id) as daily_created
    from
    (
      select v4_k_organization_data.lastname as provider_name1,
        user_id,
        to_char(min(case
            when v4_k_subscription.type =1 then v4_k_subscription.created_at
            when v4_k_subscription.type=2 then v4_k_subscription.created_at else null
            end), 'yyyy-mm-dd') as on_boarding_date
      from v4_k_plan
        join v4_k_subscription on plan_id = v4_k_plan.id
        join v4_k_users on user_id = v4_k_users.id
        join v4_k_organization_data on v4_k_users.organization_id = v4_k_organization_data.id
      where
      v4_k_organization_data.id not in (1,2,3,4,5,7,8,9,10,11,12,70,84)
      and (v4_k_subscription.type =1 or v4_k_subscription.type = 2 )
      and v4_k_subscription.status=0
      group by v4_k_organization_data.lastname, user_id
    ) create_table
    where on_boarding_date is not null
    group by provider_name1, on_boarding_date
  ) create_table2
  full join
  (
    select
    provider_name2,
    cancel_date,
    count(user_id) as daily_canceled
    from
    (
      select
      provider_name2,
      user_id,
      to_char(max(deprecated_at), 'yyyy-mm-dd') as cancel_date
      from
      (
        select
        v4_k_organization_data.lastname as provider_name2,
        v4_k_subscription.id, user_id,
        v4_k_subscription.deprecated_at,
        sum(case when v4_k_subscription.deprecated_at is null then 1 else 0 end) over (partition by user_id) as index
        from v4_k_plan
          join v4_k_subscription on plan_id = v4_k_plan.id
          join v4_k_users on user_id = v4_k_users.id
          join v4_k_organization_data on v4_k_users.organization_id = v4_k_organization_data.id
        where
        v4_k_organization_data.id not in (1,2,3,4,5,7,8,9,10,11,12,70,84)
        and (v4_k_subscription.type = 1 or v4_k_subscription.type = 2 )
        and v4_k_subscription.status=0
      )tabe1
      where
      index=0
      and deprecated_at is not null
      group by provider_name2, user_id
    ) cancel_table
    where cancel_date is not null
    group by provider_name2, cancel_date
  ) cancel_table2
  on provider_name1 = provider_name2 and on_boarding_date = cancel_date
)table1
order by growth_date
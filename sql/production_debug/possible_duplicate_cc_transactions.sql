with sales as (
   SELECT distinct
      'payment_'||p.id::varchar  AS sales_id,
      users.organization_id as organization_id,
      case when kcustomer.type = 1 then 'guest' else null end as customer_type,
      round(cast(p.amount as numeric)/100,2) AS sales_amount,
      p.created_at AS sales_created_at,
      card.last4,
      card.expiry,
      card_holder_name,
      card.last4||card.expiry||substring(cpg.tokenization,2,2)||card_holder_name as new_id
  FROM
      rds_data.g_payment p
  LEFT JOIN
      rds_data.g_subscription sub
          ON sub.id = p.subscription_id
  LEFT JOIN
      rds_data.g_gratuity gratuity
          ON gratuity.id = p.gratuity_id
  LEFT JOIN
   (SELECT distinct 
    gt.payment_id, 
    card_payment_gateway_id
  FROM  rds_data.g_gateway_transaction gt
  WHERE 
    card_payment_gateway_id IS NOT NULL and card_payment_gateway_id != 0
    and gt.payment_id is not null) gt
          ON gt.payment_id = p.id
  LEFT JOIN
      rds_data.g_card_payment_gateway cpg
          ON cpg.id = gt.card_payment_gateway_id
  LEFT JOIN
      rds_data.g_card card
          ON cpg.card_id = card.id
  LEFT JOIN
    rds_data.g_plan plan
        ON p.plan_id = plan.id
    LEFT JOIN
    rds_data.g_customer customer
        ON customer.id = plan.customer_id
    LEFT JOIN
    rds_data.k_customer_data kcustomer
        ON customer.encrypted_ref_id = kcustomer.gx_customer_id
    LEFT JOIN
    rds_data.k_users users
        ON users.id = user_id
  WHERE
      p.id IS NOT NULL
      AND p.status   = 1
      and p.type = 'credit_card'
      and p.created_at >= '2021-02-27 16:00:00'
      --and card_holder_name !=' '
      and device_id is not null
),
count_sale as(
    select 
        *, 
        count(sales_id) over (partition by new_id, sales_amount ) as cou
    from sales 
),
lag_sales as (
    select 
        *, 
        lag(sales_created_at) over(partition by new_id, sales_amount order by sales_created_at asc ) as previous_sales_created
    from count_sale 
    where 
        cou>1 
    order by 
        cou desc, 
        card_holder_name, 
        sales_created_at asc
),
time_sale as(
    select 
        *, 
        datediff(minute, (case when previous_sales_created is null then sales_created_at else previous_sales_created end), sales_created_at) as time_diff_by_minutes
from lag_sales
)
select 
    *, 
    convert_timezone('PST', sales_created_at) as pst_sales_created, 
    convert_timezone('PST', previous_sales_created) as pst_previous_sales_created
from time_sale 
where 
    time_diff_by_minutes>0 
    and time_diff_by_minutes<=60
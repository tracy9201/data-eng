with cte_product_sales as
(
select
 prod.subscription_id
, k_subscirption_id as k_subscription_id
, quantity
, unit_name
, remaining_payment
, balance
, discount_percentages
, discount_Amts
, coupons
, credits
, payments
, total_installment
, tax
, subtotal
, total
, Start_date
, end_date
, end_count
, end_unit
, proration
, auto_renewal
, renewal_count
, subscription_name
, subscription_created
, subscription_updated_at
, subscription_canceled_at
, Plan_id
, k_plan_id
, customer_id
, k_customer_id
, provider_id
, k_provider_id
, loaded_at
, 0::NUMERIC(20,9) as ps_amount
, NULL:: VARCHAR as sales_id
from product_sales prod
)

, payment_summary_refund_void as
(
select prod.subscription_id
, k_subscirption_id as k_subscription_id
, quantity
, unit_name
, remaining_payment
, balance
, discount_percentages
, discount_Amts
, coupons
, credits
, payments
, total_installment
, tax
, subtotal
, case when ps.sales_amount < 0 then ps.sales_amount else (-1 * ps.sales_amount) end as total
, Start_date
, end_date
, end_count
, end_unit
, proration
, auto_renewal
, renewal_count
, subscription_name
, subscription_created
, subscription_updated_at
, subscription_canceled_at
, Plan_id
, k_plan_id
, customer_id
, k_customer_id
, provider_id
, k_provider_id
, loaded_at
, prod.total as prod_amount
, ps.sales_id
from product_sales prod
join payment_summary ps on ps.gx_subscription_id = prod.k_subscirption_id and (ps.sales_id like '%void%' or ps.sales_id like '%refund%')
)
,  union_qry as
(
  select * from cte_product_sales
  UNION
  select * from payment_summary_refund_void
)
, main as
(
select case when sales_id IS NOT NULL then 'sub_'||subscription_id::varchar||'_'||sales_id else 'sub_'||subscription_id::varchar end as primary_product_id,
union_qry.*
from union_qry
)
select * from main 
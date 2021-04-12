WITH prod_sales as
(
  select
    prod.subscription_id
    , prod.k_subscirption_id as k_subscription_id
    , prod.quantity
    , prod.unit_name
    , prod.remaining_payment
    , prod.balance
    , prod.discount_percentages
    , prod.discount_Amts
    , prod.coupons
    , prod.credits
    , prod.payments
    , prod.total_installment
    , prod.tax
    , prod.subtotal
    , prod.total
    , prod.start_date
    , prod.end_date
    , prod.end_count
    , prod.end_unit
    , prod.proration
    , prod.auto_renewal
    , prod.renewal_count
    , prod.subscription_name
    , prod.subscription_created
    , prod.subscription_updated_at
    , prod.subscription_canceled_at
    , prod.plan_id
    , prod.k_plan_id
    , prod.customer_id
    , prod.k_customer_id
    , prod.provider_id
    , prod.k_provider_id
    , prod.loaded_at
    , NULL:: VARCHAR as sales_id
from public.product_sales prod
)
, payment_summary_void_refund as
(
  select
    pmt.sales_id
    , pmt.sales_name
    , pmt.sales_amount
    , pmt.sales_type
    , pmt.sales_status
    , pmt.sales_created_at
    , pmt.gx_customer_id
    , pmt.gx_provider_id
    , pmt.transaction_id
    , pmt.payment_id
    , pmt.gx_subscription_id
    , pmt.gratuity_amount
    , pmt.is_voided
  from payment_summary pmt
    where pmt.sales_id like 'void3%' or pmt.sales_id like 'refund%' or pmt.sales_id like 'void4%'
)
, payment_summary_product_sales as
(
  select
    prod.subscription_id
    , prod.k_subscription_id
    , prod.quantity
    , prod.unit_name
    , prod.remaining_payment
    , prod.balance
    , prod.discount_percentages
    , prod.discount_Amts
    , prod.coupons
    , prod.credits
    , prod.payments
    , prod.total_installment
    , 0::Numeric(18,2) as tax
    , case when ps.sales_amount < 0 then ps.sales_amount else (-1 * ps.sales_amount) end as subtotal
    , case when ps.sales_amount < 0 then ps.sales_amount else (-1 * ps.sales_amount) end as total
    , prod.start_date
    , prod.end_date
    , prod.end_count
    , prod.end_unit
    , prod.proration
    , prod.auto_renewal
    , prod.renewal_count
    , prod.subscription_name
    , prod.subscription_created
    , prod.subscription_updated_at
    , prod.subscription_canceled_at
    , prod.plan_id
    , prod.k_plan_id
    , prod.customer_id
    , prod.k_customer_id
    , prod.provider_id
    , prod.k_provider_id
    , prod.loaded_at
    , ps.sales_id
  from prod_sales prod
  inner join payment_summary_void_refund ps
        on ps.gx_subscription_id = prod.k_subscription_id
        and prod.renewal_count = 1
)
,  union_qry as
(
  select * from prod_sales
  UNION ALL
  select * from payment_summary_product_sales
)
, main as
(
  select case when sales_id IS NOT NULL then 'sub_'||subscription_id::varchar||'_'||sales_id else 'sub_'||subscription_id::varchar end as primary_product_id,
  union_qry.*
  from union_qry
)

select * from main
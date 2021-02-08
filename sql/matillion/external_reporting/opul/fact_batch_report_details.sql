WITH sub_cus as
(
    select subscription_name, 
    customer2.gx_customer_id as gx_cus_id, 
    user_type,
    count(subscription_created) over (partition by product_sales.k_customer_id order by subscription_created desc rows between unbounded preceding and unbounded following) as sub_created
    from dwh_opul.fact_product_sales product_sales
    join dwh_opul.dim_customer customer2 on product_sales.k_customer_id = customer2.gx_customer_id
    where user_type=1
),
batch_report_details as
(
  select payment_summary.*, 
  subscription_name, 
  user_type
  from dwh_opul.fact_payment_summary payment_summary
  left join sub_cus as sc on payment_summary.gx_customer_id = sc.gx_cus_id
  where sc.sub_created = 1
)
select * from batch_report_details

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
  select 
  subscription_name, 
  user_type,
  is_voided,
  sales_id,
  case when sales_id like 'refund%' then 'Refund'
      when sales_id like 'credit%'  and  sales_type in ('reward', 'credit') and sales_name = 'BD Payment' then 'Offer Redemption'
      when sales_id like 'credit%'  and  sales_type = 'provider credit' then 'Deposit From Patient'
      when sales_id like 'credit%' then 'Redemption'
      when sales_id like 'void%' then 'Void'
      else 'Sale'
      end as transaction,
  case when sales_type = 'cash' and (sales_id like 'payment%' or sales_id like 'refund%') then 'Cash'
      when sales_type = 'check' and (sales_id like 'payment%' or sales_id like 'refund%') then 'Check'
      when sales_type = 'credit_card' and (sales_id like 'payment%' or sales_id like 'refund%') then 'Credit Card'
      when sales_type in ('wallet', 'provider credit') and (sales_id like 'credit%' or sales_id like 'refund%' or sales_id like 'payment%') then 'Practice Credit'
      when sales_type in ('reward', 'credit') and sales_name = 'BD Payment' and (sales_id like 'credit%' or sales_id like 'refund%') then 'BD'
      when sales_type in ('credit', 'reward') and (sales_id like 'credit%' or sales_id like 'refund%') then 'Other'
      when sales_type ='credit_card' and sales_id like 'tran%' then 'Recurring Pmt'
      when sales_id like 'void%' or tokenization is not null then 'Credit Card'
      end as payment_method,
  card_brand,
  case when sales_type = 'cash'  then 'Cash'
      when sales_type = 'check'  then 'Check'
      when sales_type = 'credit_card'  and token_substr like '4%' then 'Visa'
      when sales_type = 'credit_card'  and (token_substr like '34%' or token_substr like '37%') then 'Amex'
      when sales_type = 'credit_card'  and (token_substr like '51%' or token_substr like '52%' or token_substr like '53%' or token_substr like '54%' or token_substr like '55%' or token_substr like '2%') then 'Mastercard'
      when sales_type = 'credit_card'  and (token_substr like '60%' or token_substr like '65%' ) then 'Discover'
      when sales_type = 'credit_card'  then 'Other Credit Card'
      when sales_type = 'reward' then 'Reward'
      when sales_type in ('wallet', 'provider credit') then 'Practice Credit'
      when sales_type = 'adjustment' then 'Adjustment'
      when sales_type = 'credit' then 'Coupon'
      when sales_type in ('reward', 'credit') and sales_name = 'BD Payment' and (sales_id like 'credit%' or sales_id like 'refund%') then 'BD'
      end 
  as payment_detail,
  case 
      when user_type=1 and (sales_id like 'payment%' or sales_id like 'credit%') and subscription_name is not null then subscription_name
      when sales_type = 'check' then null
      when sales_type = 'credit_card' and (sales_id like 'payment%' or sales_id like 'refund%') then null
      when sales_type in ('reward', 'credit') and sales_name = 'BD Payment' and (sales_id like 'credit%' or sales_id like 'refund%') then null
      when sales_type ='credit_card' and sales_id like 'tran%' then null
      when sales_type = 'Recurring Pmt' and sales_type = 'credit_card' then null
      else payment_id end
  as description,
  case 
       when sales_type = 'check' then payment_id
       when sales_type ='credit_card' and ( sales_id like 'tran%' or sales_id like 'payment%' or sales_id like 'refund%' )then CONCAT('**** ',cast(payment_id as VARCHAR))
       when transaction = 'Void' then CONCAT('**** ',cast(right(tokenization,4) as VARCHAR))
       else null end 
  as payment_id,
  gx_customer_id,
  gx_provider_id,
  transaction_id, 
  case when (sales_id like 'void1%' or sales_id like 'void2%')  then sales_created_at + INTERVAL '1 DAY' 
      else sales_created_at END  as sales_created_at,
  sales_created_at as original_sales_created_at,
  staff_user_id,
  device_id,
  tokenization,
  case 
      when sales_id like 'refund%' then coalesce((-1*sales_amount)/100,0)
      when sales_id like 'void%' then coalesce((-1*sales_amount)/100,0)
      else coalesce(sales_amount/100,0) end
  as sales_amount,
  coalesce((gratuity_amount)/100,0) as gratuity_amount,
  card_holder_name,
  inv_id,
  inv_status,
  created_at,
  updated_at
  from dwh_opul.fact_payment_summary payment_summary
  left join (select * from sub_cus where sub_created = 1) as sc on payment_summary.gx_customer_id = sc.gx_cus_id
  
),

batch_report_details_formatting as
(
    select
    subscription_name, 
    user_type,
    is_voided,
    sales_id,
    transaction,
    payment_method,
    card_brand,
    case when trim(payment_detail) = '' then  NULL else payment_detail end as payment_detail ,
    case when trim(description) = '' then  NULL else description end as description ,
    case when trim(payment_id) = '' then  NULL else payment_id end as payment_id ,
    gx_customer_id,
    gx_provider_id,
    transaction_id,
    sales_created_at,
    original_sales_created_at,
    staff_user_id,
    device_id,
    tokenization,
    sales_amount,
    gratuity_amount,
    card_holder_name,
    inv_id,
    inv_status,
    created_at,
  	updated_at
    from batch_report_details
),

main as
(
  select 
  subscription_name, 
  user_type,
  is_voided,
  sales_id,
  transaction,
  coalesce(payment_method,'N/A') as payment_method,
  card_brand,
  case when payment_method = 'Credit Card' then coalesce(card_brand,payment_detail)
       when payment_detail is NULL  then 'N/A'
       else payment_detail  end as payment_detail,
  case when user_type = 1 and transaction='Refund' and  description is  null and upper(payment_id) <> lower(payment_id) then payment_id
       when user_type = 1 and transaction='Refund' and description is not null then description
       when payment_method = 'Check' and transaction='Refund' and payment_id is not null and  description is null then payment_id
       when transaction='Refund'  and  description is null and upper(payment_id) <> lower(payment_id)  then payment_id
       when description is NULL then 'N/A'
       else description end AS description,
  coalesce(case when transaction='Refund'  and payment_method = 'Check' then 'N/A'
                when upper(payment_id) = lower(payment_id) then payment_id
                when payment_id is NULL  then 'N/A'
                else payment_id
       end,'N/A') AS payment_id,
  gx_customer_id,
  gx_provider_id,
  transaction_id,
  sales_created_at,
  original_sales_created_at,
  staff_user_id,
  device_id,
  tokenization,
  sales_amount,
  gratuity_amount,
  card_holder_name,
  extract (epoch from sales_created_at) as epoch_sales_created_at,
  extract (epoch from original_sales_created_at) as epoch_original_sales_created_at,
  case when (sales_id like 'void1%' or sales_id like 'void2%') and is_voided = 'Yes' then 'BAD'
       when payment_method= 'adjustment' then 'BAD'
       when inv_status = -3 and payment_method != 'Credit Card' then 'BAD'
       else 'GOOD' end  category,
  substring(card_holder_name, 1, OCTETINDEX(' ', card_holder_name)) as firstname,
  substring(card_holder_name, OCTETINDEX(' ', card_holder_name)+1, len(card_holder_name)) as lastname,
  created_at,
  updated_at,
  current_timestamp::timestamp as dwh_created_at
  from batch_report_details_formatting
)
select * from main
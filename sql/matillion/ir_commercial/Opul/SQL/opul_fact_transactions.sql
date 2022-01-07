WITH batch_report_details as
(
  select
  cd.type as user_type,
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
       when sales_type = 'check' then payment_id
       when sales_type ='credit_card' and ( sales_id like 'tran%' or sales_id like 'payment%' or sales_id like 'refund%' )then CONCAT('**** ',cast(payment_id as VARCHAR))
       when transaction = 'Void' then CONCAT('**** ',cast(right(tokenization,4) as VARCHAR))
       else null end
  as payment_id,
  payment_summary.gx_customer_id,
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
  case
      when sales_id like 'refund%' then coalesce((-1*gratuity_amount)/100,0)
      when sales_id like 'void%' then coalesce((-1*gratuity_amount)/100,0)
      else coalesce(gratuity_amount/100,0) end
  as gratuity_amount,
  card_holder_name,
  inv_id,
  inv_status,
  payment_summary.created_at,
  payment_summary.updated_at,
  sales_status
  from ir_opul.fact_payment_summary payment_summary
  left join kronos_opul.customer_data as cd on payment_summary.gx_customer_id = cd.gx_customer_id

),

batch_report_details_formatting as
(
    select
    user_type,
    is_voided,
    sales_id,
    transaction,
    payment_method,
    card_brand,
    case when trim(payment_detail) = '' then  NULL else payment_detail end as payment_detail ,
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
    updated_at,
    sales_status
    from batch_report_details
),

main as
(
  select
  sales_id as transaction_id,
  sales_status as status,
  gx_customer_id,
  coalesce(payment_method,'N/A') as payment_method,
  transaction,
  sales_amount as amount,
  device_id,
  created_at,
  updated_at,
  staff_user_id as staff_id,
  gratuity_amount,
  case when user_type =  1 then 'Subscriber'
       else 'Non-Subscriber'  end as customer_type,
  case when payment_method = 'Credit Card' then coalesce(card_brand,payment_detail)
       when payment_detail is NULL  then 'N/A'
       else payment_detail  end as payment_detail,
  gx_provider_id,
  transaction_id as clover_transaction_id,
  case
      when payment_method = 'Credit Card' and transaction = 'Void' then 'CNP'
      when payment_method = 'Credit Card' and transaction = 'Refund' then 'CNP'
      when payment_method = 'Credit Card' and device_id is not null then 'CP'
      when payment_method = 'Credit Card' and device_id is null then 'CNP'
  else 'N/A'
  end as cp_or_cnp,
  current_timestamp::timestamp as dwh_created_at
  from batch_report_details_formatting
)
select * from main

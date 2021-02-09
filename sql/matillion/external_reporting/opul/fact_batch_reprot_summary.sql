WITH batch_report_summary as
(
  select 
  is_voided,
  sales_id,
  case when sales_id like 'refund%' then 'Refund'
      when sales_id like 'credit%'  and  sales_type in ('reward', 'credit') and sales_name = 'BD Payment' then 'Offer Redemption'
      when sales_id like 'credit%'  and  sales_type = 'provider credit' then 'Deposit From Patient'
      when sales_id like 'void%' then 'Void'
      else 'Sale'
      end as transaction,
  case when sales_type = 'cash' and (sales_id like 'payment%' or sales_id like 'refund%') then 'Cash'
      when sales_type = 'check' and (sales_id like 'payment%' or sales_id like 'refund%') then 'Check'
      when sales_type = 'credit_card' and (sales_id like 'payment%' or sales_id like 'refund%') then 'Credit Card'
      when sales_type = 'provider credit' and (sales_id like 'credit%' or sales_id like 'refund%') then 'Practice Credit'
      when sales_type in ('reward', 'credit') and sales_name = 'BD Payment' and (sales_id like 'credit%' or sales_id like 'refund%') then 'BD'
      when sales_type in ('credit', 'reward') and (sales_id like 'credit%' or sales_id like 'refund%') then 'Other'
      when sales_type ='credit_card' and sales_id like 'tran%' then 'Recurring Pmt'
      when sales_id like 'void%' or tokenization is not null then 'Credit Card'
      end as payment_method,
  case when sales_type = 'cash'  then 'Cash'
      when sales_type = 'check'  then 'Check'
      when sales_type = 'credit_card'  and token_substr like '4%' then 'Visa'
      when sales_type = 'credit_card'  and (token_substr like '34%' or token_substr like '37%') then 'Amex'
      when sales_type = 'credit_card'  and (token_substr like '51%' or token_substr like '52%' or token_substr like '53%' or token_substr like '54%' or token_substr like '55%') then 'Mastercard'
      when sales_type = 'credit_card'  and (token_substr like '60%' or token_substr like '65%' ) then 'Discover'
      when sales_type = 'credit_card'  then 'Other Credit Card'
      when sales_type = 'reward' then 'Reward'
      when sales_type = 'provider credit' then 'Practice Credit'
      when sales_type = 'adjustment' then 'Adjustment'
      when sales_type = 'credit' then 'Coupon'
      when sales_type in ('reward', 'credit') and sales_name = 'BD Payment' and (sales_id like 'credit%' or sales_id like 'refund%') then 'BD'
      end 
  as payment_detail,
  case 
      when user_type=1 then subscription_name
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
       else null end 
  as payment_id,
  gx_customer_id,
  gx_provider_id,
  case when (sales_id like 'void1%' or sales_id like 'void2%')  then sales_created_at + INTERVAL '1 DAY' 
      else sales_created_at END  as sales_created_at,
  sales_created_at as original_sales_created_at,
  staff_user_id,
  device_id,
  case 
      when sales_id like 'refund%' then coalesce((-1*sales_amount)/100,0)
      when sales_id like 'void%' then coalesce((-1*sales_amount)/100,0)
      else coalesce(sales_amount/100,0) end
  as sales_amount,
  coalesce((gratuity_amount)/100,0) as gratuity_amount
  from dwh_opul.fact_payment_summary payment_summary
),
main as
(
  select *,
  extract (epoch from sales_created_at) as epoch_sales_created_at,
  extract (epoch from original_sales_created_at) as epoch_original_sales_created_at,
  case when (sales_id like 'void1%' or sales_id like 'void2%') and is_voided = 'Yes' then 'BAD'
       when payment_method= 'adjustment' then 'BAD'
       else 'GOOD' end  category
  from batch_report_summary
)
select * from main
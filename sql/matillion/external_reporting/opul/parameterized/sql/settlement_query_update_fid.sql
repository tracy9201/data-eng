WITH transaction_details as 
(
SELECT 
     ft.merchant_id
     ,fi.status as fi_status
     ,ft.status as ft_status
    ,fi.mid
    ,ft.funding_instruction_id
    ,ft.transaction_id
    ,case when ft.transaction_type = 'PAYMENT' then 'Sales' 
          when ft.transaction_type = 'REFUND' then  'Refunds'
          when ft.transaction_type = 'CHARGEBACK' then 'Chargebacks'
          when ft.transaction_type = 'ADJUSTMENT' then  'Adjustments'
          end as transaction_type
    ,ft.amount
    ,ft.cp_or_cnp
    ,ft.exchange_added_date
    ,fi.created_at::date as funding_date
    ,ft.settled_at::date as settled_at_date
    ,case when ft.card_brand in ('00001','00085','00086','00087','00088','00092') then 'MasterCard'
          when ft.card_brand in ('00002','00079','00080','00081','00082','00083','00084') then 'Visa'
          when ft.card_brand = '00003' then 'Discover'
          when ft.card_brand in ('00006','00008') then 'Amex'
          else 'Other' end as card_brand
    ,ft.percent_fee as ft_percent_fee
    ,fi.fee as fi_fees
FROM 
    odf.fiserv_transaction ft
JOIN 
    odf.funding_instruction fi on ft.funding_instruction_id = fi.id
-- WHERE (fi.status = 'SETTLED' or ft.status = 'SETTLED')

),

last_trans_for_each_funding_id as
(
SELECT
     funding_instruction_id
    ,max(transaction_id) as last_transaction_id
FROM
    transaction_details
GROUP BY 
    1
),


transaction_details_with_correct_fee as 
(
SELECT
     a.merchant_id
     ,a.fi_status
     ,a.ft_status
    ,a.mid
    ,a.funding_instruction_id
    ,a.transaction_id
    ,a.transaction_type
    ,a.amount
    ,a.cp_or_cnp
    ,a.exchange_added_date
    ,a.funding_date
    ,a.settled_at_date
    ,a.card_brand
    ,a.ft_percent_fee
    ,a.fi_fees
    ,CASE WHEN b.last_transaction_id IS NOT NULL then a.fi_fees END as correct_fi_fees
    ,CASE WHEN b.last_transaction_id IS NOT NULL then 'Y' END as is_fee_record
    ,'Non-Member' as subscriber
    ,c.gx_customer_id
    ,c.payment_id
FROM
    transaction_details a
LEFT JOIN
    last_trans_for_each_funding_id  b on a.transaction_id = b.last_transaction_id 
    and a.funding_instruction_id=b.funding_instruction_id 
LEFT JOIN
    dwh_opul.fact_batch_report_details c on a.transaction_id = c.transaction_id 
),


all_transactions as
(
SELECT  
     merchant_id
      ,fi_status
     ,ft_status
    ,mid
    ,funding_instruction_id
    ,transaction_id
    ,transaction_type
    ,amount as transaction_amount
    ,cp_or_cnp
    ,exchange_added_date
    ,funding_date
    ,settled_at_date
    ,card_brand
    ,subscriber
    ,gx_customer_id
    ,payment_id
FROM
    transaction_details_with_correct_fee
),

fee as
(
SELECT  
     merchant_id
       ,fi_status
     ,ft_status
    ,mid
    ,funding_instruction_id
    ,NULL AS transaction_id
    ,case when cp_or_cnp = 'CP' then 'CP Fees'
          when cp_or_cnp = 'CNP' then 'CNP Fees' end as transaction_type
    ,correct_fi_fees as transaction_amount
    ,cp_or_cnp
    ,exchange_added_date
    ,funding_date
    ,settled_at_date
    ,card_brand
    ,subscriber
    ,gx_customer_id
    ,payment_id
FROM
    transaction_details_with_correct_fee
WHERE 
    is_fee_record = 'Y'
),

main as 
(
    SELECT * FROM all_transactions
    UNION ALL
    SELECT * FROM fee
),

main1 as
(

SELECT
    b.created_at::date as transaction_date,
    a.*,
    extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',a.funding_date)) as epoch_funding_date,
    extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',a.settled_at_date))  as epoch_settled_at_date,
    current_timestamp::timestamp as dwh_created_at
FROM main a
JOIN odf.payment_transaction b on a.transaction_id = b.transaction_id

where ft_status = 'FAILED' and fi_status <> 'SETTLED'
and b.created_at::date >= '2021-04-01'
),

main1_0 as
(
 select distinct mid,transaction_id,funding_date,funding_instruction_id,transaction_amount
 from main1
),

main2 as
(
 select  mid,funding_date,funding_instruction_id,sum(transaction_amount) as tran_amount
 from main1_0 
 group by 1,2,3
),

instruction_detail as
(
select a.settlement_request_date,a.merchant_id,d.*
from odf.settlement_info a
join odf.instruction_received b on a.id = b.settlement_id
join odf.settlement_instruction c on b.id = c.instruction_received_id
join odf.instruction_detail d on c.id = d.settlement_instruction_id
-- where a.merchant_id = '700100000000513'
-- and a.created_at::date >= '2021-06-11'
--and a.settlement_request_date::Date = '2021-06-12'

),

id2 as
(
  select merchant_id as mid,settlement_request_date::Date as funding_date,item_description as funding_instruction_id, sum(item_amount) as item_amount
  from instruction_detail
  group by 1,2,3
),

id3 as
(
select a.* 
from main2 a 
left join id2 b  on a.mid =b.mid and a.funding_date = b.funding_date and a.tran_amount = b.item_amount
where b.mid is null
)

select a.* ,b.*,a.tran_amount - b.item_amount as diff
from main2 a 
left join id2 b  on a.mid =b.mid and a.funding_date = b.funding_date
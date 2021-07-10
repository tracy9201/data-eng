WITH transaction_details as 
(
SELECT 
    fi.mid as merchant_id
    ,ft.funding_instruction_id
    ,ft.transaction_id
    ,pt.created_at as transaction_date
    ,case when ft.transaction_type = 'PAYMENT' then 'Sales' 
          when ft.transaction_type = 'REFUND' then  'Refunds'
          when ft.transaction_type = 'CHARGEBACK' then 'Chargebacks'
          when ft.transaction_type = 'ADJUSTMENT' then  'Adjustments'
          end as transaction_type
    ,ft.amount
    ,ft.cp_or_cnp
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
    odf${environment}.fiserv_transaction ft
JOIN 
    odf${environment}.funding_instruction fi on ft.funding_instruction_id = fi.id
JOIN 
    odf${environment}.payment_transaction pt on ft.transaction_id = pt.transaction_id
WHERE fi.status = 'SETTLED'

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
    ,a.funding_instruction_id
    ,a.transaction_id
    ,a.transaction_date
    ,a.transaction_type
    ,a.amount
    ,a.cp_or_cnp
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
    ,funding_instruction_id
    ,transaction_id
    ,transaction_date
    ,transaction_type
    ,amount/100.0 as transaction_amount
    ,cp_or_cnp
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
    ,funding_instruction_id
    ,'N/A' AS transaction_id
    ,transaction_date
    ,case when cp_or_cnp = 'CP' then 'CP Fees'
          when cp_or_cnp = 'CNP' then 'CNP Fees' end as transaction_type
    ,correct_fi_fees/100.0 as transaction_amount
    ,cp_or_cnp
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
)

SELECT 
    *
    ,extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',transaction_date)) as epoch_transaction_date
    ,extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',funding_date)) as epoch_funding_date
    ,extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',settled_at_date))  as epoch_settled_at_date
    ,current_timestamp::timestamp as dwh_created_at
FROM main
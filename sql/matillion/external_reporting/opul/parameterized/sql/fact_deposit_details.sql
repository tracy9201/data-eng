WITH transaction_details as 
(
SELECT 
    ft.merchant_id
    ,fi.mid
    ,ft.funding_instruction_id
    ,ft.transaction_id
    ,ft.transaction_type
    ,ft.amount
    ,case when ft.transaction_type = 'PAYMENT' then ft.amount  end as charges
    ,case when ft.transaction_type = 'REFUND' then  coalesce(ft.amount,0)  end as refunds
    ,case when ft.transaction_type = 'CHARGEBACK' then coalesce(ft.amount,0) end as chargebacks
    ,case when ft.transaction_type = 'ADJUSTMENT' then  coalesce(ft.amount,0) end as adjustments
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
    ,a.mid
    ,a.funding_instruction_id
    ,a.transaction_id
    ,a.transaction_type
    ,a.amount
    ,a.charges
    ,a.refunds
    ,a.chargebacks
    ,a.adjustments
    ,a.cp_or_cnp
    ,a.funding_date
    ,a.settled_at_date
    ,a.card_brand
    ,a.ft_percent_fee
    ,a.fi_fees
    ,CASE WHEN b.last_transaction_id IS NOT NULL then a.fi_fees END as correct_fi_fees
    ,CASE WHEN b.last_transaction_id IS NOT NULL then 'Y' END as is_fee_record
FROM
    transaction_details a
LEFT JOIN
    last_trans_for_each_funding_id  b on a.transaction_id = b.last_transaction_id 
    and a.funding_instruction_id=b.funding_instruction_id 
),

charges as
(
SELECT  
     merchant_id
    ,mid
    ,funding_instruction_id
    ,transaction_id
    ,transaction_type
    ,amount as transaction_amount
    ,cp_or_cnp
    ,funding_date
    ,settled_at_date
    ,card_brand
FROM
    transaction_details_with_correct_fee
WHERE 
    transaction_type = 'PAYMENT'
),

refunds as
(
SELECT  
     merchant_id
    ,mid
    ,funding_instruction_id
    ,transaction_id
    ,transaction_type
    ,refunds as transaction_amount
    ,cp_or_cnp
    ,funding_date
    ,settled_at_date
    ,card_brand
FROM
    transaction_details_with_correct_fee
WHERE 
    transaction_type = 'REFUND'
),

chargebacks as
(
SELECT  
     merchant_id
    ,mid
    ,funding_instruction_id
    ,transaction_id
    ,transaction_type
    ,chargebacks as transaction_amount
    ,cp_or_cnp
    ,funding_date
    ,settled_at_date
    ,card_brand
FROM
    transaction_details_with_correct_fee
WHERE 
    transaction_type = 'CHARGEBACK'
),

adjustments as
(
SELECT  
     merchant_id
    ,mid
    ,funding_instruction_id
    ,transaction_id
    ,transaction_type
    ,adjustments as transaction_amount
    ,cp_or_cnp
    ,funding_date
    ,settled_at_date
    ,card_brand
FROM
    transaction_details_with_correct_fee
WHERE 
    transaction_type = 'ADJUSTMENT'
),

fee as
(
SELECT  
     merchant_id
    ,mid
    ,funding_instruction_id
    ,NULL AS transaction_id
    ,'FEE' as transaction_type
    ,correct_fi_fees as transaction_amount
    ,NULL AS cp_or_cnp
    ,funding_date
    ,settled_at_date
    ,card_brand
FROM
    transaction_details_with_correct_fee
WHERE 
    is_fee_record = 'Y'
),

main as 
(
    SELECT * FROM charges
    UNION ALL
    SELECT * FROM refunds
    UNION ALL
    SELECT * FROM chargebacks
    UNION ALL
    SELECT * FROM adjustments
    UNION ALL
    SELECT * FROM fee
)

SELECT 
    *,
    extract(epoch from funding_date) as epoch_funding_date,
    extract(epoch from settled_at_date) as epoch_settled_at_date,
    current_timestamp::timestamp as dwh_created_at
FROM main;

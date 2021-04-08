WITH deposits_transaction_details as 
(
SELECT 
    fi.mid as merchant_id
    ,ft.funding_instruction_id
    ,ft.transaction_id
    ,ft.transaction_type
    ,ft.transaction_date
    ,1 as transactions
    ,case when ft.transaction_type = 'PAYMENT' then ft.amount/100.0  end as charges
    ,case when ft.transaction_type = 'REFUND' then  coalesce(ft.amount/100.0,0)  end as refunds
    ,case when ft.transaction_type = 'CHARGEBACK' then coalesce(ft.amount/100.0,0) end as chargebacks
    ,case when ft.transaction_type = 'ADJUSTMENT' then  coalesce(ft.amount/100.0,0) end as adjustments
    ,case when ft.transaction_type = 'PAYMENT' and  ft.cp_or_cnp = 'CP' then 0.0199*ft.amount/100
         when ft.transaction_type = 'PAYMENT' and  ft.cp_or_cnp = 'CNP' then 0.0219*ft.amount/100
         else 0 end as fees
    ,ft.cp_or_cnp
    ,case when ft.card_brand = '00001' then 'MasterCard'
         when ft.card_brand = '00002' then 'Visa'
         when ft.card_brand = '00008' then 'Amex'
         else 'N/A' end as card_brand
    ,case when ft.cp_or_cnp = 'CP' then 1.99 
         when ft.cp_or_cnp = 'CNP' then 2.19 
         end as percent_fee
    ,ft.percent_fee as ft_percent_fee
    ,ft.settled_at::date as funding_date
    ,to_date(settled_at,'YYYY-MM-01') as funding_month
    ,extract (epoch from ft.settled_at::date) as epoch_funding_date
    ,extract (epoch from to_date(settled_at,'YYYY-MM-01')) as epoch_funding_month
    ,current_timestamp::timestamp as dwh_created_at
FROM 
    odf.fiserv_transaction ft
JOIN 
    odf.funding_instruction fi on ft.funding_instruction_id = fi.id
WHERE fi.status = 'SETTLED'
)

SELECT  * FROM deposits_transaction_details
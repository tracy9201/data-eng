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
    ,round(ft.percent_fee/100.0*ft.amount/100.0,2) as fees
    ,ft.cp_or_cnp
    ,case when ft.card_brand in ('00001','00085','00086','00087','00088','00092') then 'MasterCard'
          when ft.card_brand in ('00002','00079','00080','00081','00082','00083','00084') then 'Visa'
          when ft.card_brand = '00003' then 'Discover'
          when ft.card_brand in ('00006','00008') then 'Amex'
          else 'Other' end as card_brand
    ,case when ft.cp_or_cnp = 'CP' then 1.99 
          when ft.cp_or_cnp = 'CNP' then 2.19 
          end as percent_fee
    ,ft.percent_fee as ft_percent_fee 
    ,ft.settled_at::date as funding_date
    ,to_date(settled_at,'YYYY-MM-01') as funding_month
    ,extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',ft.settled_at::date))::bigint * 1000 as epoch_funding_date
    ,extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',to_date(settled_at,'YYYY-MM-01')))::bigint * 1000 as epoch_funding_month
    ,current_timestamp::timestamp as dwh_created_at
FROM 
    odf${environment}.fiserv_transaction ft
JOIN 
    odf${environment}.funding_instruction fi on ft.funding_instruction_id = fi.id
WHERE fi.status = 'SETTLED'
)

SELECT  * FROM deposits_transaction_details
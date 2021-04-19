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
    ,ft.settled_at::date as settled_at
    ,ft.card_brand as card_brand1
    ,case when ft.card_brand in ('00001','00085','00086','00087','00088','00092') then 'MasterCard'
          when ft.card_brand in ('00002','00079','00080','00081','00082','00083','00084') then 'Visa'
          when ft.card_brand = '00003' then 'Discover'
          when ft.card_brand in ('00006','00008') then 'Amex'
          else 'Other' end as card_brand
    ,case when ft.cp_or_cnp = 'CP' then 1.99 
          when ft.cp_or_cnp = 'CNP' then 2.19 
          end as percent_fee
    ,case when ft.transaction_type = 'PAYMENT' and  ft.cp_or_cnp = 'CP' then 0.0199*ft.amount
          when ft.transaction_type = 'PAYMENT' and  ft.cp_or_cnp = 'CNP' then 0.0219*ft.amount
          else 0 end as fees
    ,ft.percent_fee as ft_percent_fee
    ,ft.fixed_fee
    ,ft.total_fee
FROM 
    odf${environment}.fiserv_transaction ft
JOIN 
    odf${environment}.funding_instruction fi on ft.funding_instruction_id = fi.id
WHERE fi.status = 'SETTLED'

),

transaction_details_daily_summary as
(
SELECT
    mid
    ,funding_instruction_id
    ,settled_at
    ,cp_or_cnp
    ,percent_fee
    ,to_date(settled_at,'YYYY-MM-01') as settled_month
    ,count(1) as transactions
    ,sum(charges)/100.0 as charges
    ,sum(refunds)/100.0 as refunds
    ,sum(chargebacks)/100.0 as chargebacks
    ,sum(adjustments)/100.0 as adjustments
    ,sum(fees)/100.0 AS ft_fees
FROM
    transaction_details
GROUP BY 1,2,3,4,5,6
),

transaction_details_daily_summary_computed_fee as
(
SELECT
    mid
    ,funding_instruction_id
    ,settled_at
    ,settled_month
    ,sum(transactions) transactions
    ,sum(charges) charges
    ,sum(refunds) refunds
    ,sum(chargebacks) chargebacks
    ,sum(adjustments) adjustments
    ,sum(ft_fees) ft_fees
    ,sum((charges - coalesce(refunds,0))*percent_fee/100) as computed_fees
FROM
    transaction_details_daily_summary
GROUP BY 
    1,2,3,4
),


main as
(
SELECT 
    a.mid as merchant_id
    ,a.funding_instruction_id
    ,a.settled_at as funding_date
    ,a.settled_month as funding_month
    ,a.transactions
    ,a.charges
    ,coalesce(a.refunds,0) as refunds
    ,coalesce(a.chargebacks,0) as chargebacks
    ,coalesce(a.adjustments,0) as adjustments
    ,coalesce(b.fee,0) as fees
    ,coalesce(b.revenue,0) as revenue
    ,extract (epoch from settled_at) as epoch_funding_date
    ,extract (epoch from settled_month) as epoch_funding_month
    ,current_timestamp::timestamp as dwh_created_at
FROM 
    transaction_details_daily_summary a
JOIN 
    odf${environment}.funding_instruction b 
    on a.funding_instruction_id = b.id
)

SELECT * FROM main
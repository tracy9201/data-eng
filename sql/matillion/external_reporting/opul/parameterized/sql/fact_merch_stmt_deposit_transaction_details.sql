WITH refunds as
(
  SELECT *
  FROM 
      odf${environment}.fiserv_transaction
  WHERE
      transaction_type = 'REFUND'
),

payment as
(
  SELECT *
  FROM 
      odf${environment}.fiserv_transaction
  WHERE
      transaction_type = 'PAYMENT'
),

refund_fee as
(
  SELECT distinct a.*,b.percent_fee as percent_fee_calc
  FROM
      refunds a
  JOIN 
      payment b on a.transaction_id = b.transaction_id
),

calc_fee as
(
  SELECT * FROM refund_fee
  UNION ALL
  SELECT *, percent_fee as percent_fee_calc 
  FROM 
      odf${environment}.fiserv_transaction
  WHERE
      transaction_type <> 'REFUND'
),

deposits_transaction_details as 
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
    ,case when ft.transaction_type = 'PAYMENT' then ft.percent_fee/10000.0*ft.amount/100.0
          when ft.transaction_type = 'REFUND'  then 0 - ft.percent_fee_calc/10000.0*ft.amount/100.0  end as fees
    ,ft.cp_or_cnp
    ,case when ft.card_brand in ('00001','00085','00086','00087','00088','00092') then 'MasterCard'
          when ft.card_brand in ('00002','00079','00080','00081','00082','00083','00084') then 'Visa'
          when ft.card_brand = '00003' then 'Discover'
          when ft.card_brand in ('00006','00008') then 'Amex'
          else 'Other' end as card_brand
    ,ft.percent_fee_calc/100.0 as percent_fee
    ,ft.percent_fee as ft_percent_fee 
    ,ft.settled_at::date as funding_date
    ,to_date(settled_at,'YYYY-MM-01') as funding_month
    ,extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',ft.settled_at::date))::bigint * 1000 as epoch_funding_date
    ,extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',to_date(settled_at,'YYYY-MM-01')))::bigint * 1000 as epoch_funding_month
    ,current_timestamp::timestamp as dwh_created_at
FROM 
    calc_fee ft
JOIN 
    odf${environment}.funding_instruction fi on ft.funding_instruction_id = fi.id
WHERE fi.status = 'SETTLED'
)

SELECT  * FROM deposits_transaction_details
WITH instruction_settled_date AS
(
   SELECT 
     funding_instruction_id,
     settled_at 
   FROM odf${environment}.fiserv_transaction
   WHERE settled_at is not null
   GROUP BY 1,2
),

transaction_details as 
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
WHERE  (fi.status = 'SETTLED' or ft.status = 'SETTLED')

),

device_fee AS
(
  SELECT   
    fee.chained_mid as mid
    ,isd.settled_at
    ,fee.funding_instruction_id
    ,to_date(isd.settled_at,'YYYY-MM-01') as settled_month
    ,0 as charges
    ,0 as refunds
    ,0 as chargebacks
    ,0 as adjustments
    ,0 as fees
    ,fee.amount AS non_transaction_fee
    ,0 as chargeback_fees
  FROM odf${environment}.non_transactional_fee fee
  INNER JOIN
      instruction_settled_date isd ON isd.funding_instruction_id = fee.funding_instruction_id
  WHERE fee.transaction_type = 'DEVICE_ORDER'
),

device_fee_sum AS
(
  SELECT   
    fee.mid
    ,funding_instruction_id
    ,settled_at
    ,settled_month
    ,0 as transactions
    ,sum(charges)/100.0 as charges
    ,sum(refunds)/100.0 as refunds
    ,sum(chargebacks)/100.0 as chargebacks
    ,sum(adjustments)/100.0 as adjustments
    ,sum(non_transaction_fee)/100.0 AS fees
  FROM device_fee fee
  GROUP BY 1,2,3,4
),

transaction_details_daily_summary as
(
SELECT
    a.mid
    ,a.funding_instruction_id
    ,a.settled_at
    ,to_date(a.settled_at,'YYYY-MM-01') as settled_month
    ,count(1) as transactions
    ,sum(a.charges)/100.0 as charges
    ,sum(a.refunds)/100.0 as refunds
    ,sum(a.chargebacks)/100.0 as chargebacks
    ,sum(a.adjustments)/100.0 as adjustments
    ,sum(fi.transactional_fee)/100.0 AS fees
FROM
    transaction_details a
JOIN odf${environment}.funding_instruction fi on a.funding_instruction_id = fi.id
GROUP BY 1,2,3,4
),


chargebacks as
(
SELECT
    fi.mid
    ,fi.id as funding_instruction_id
    ,ft.settled_at::date AS settled_at
    ,to_date(ft.settled_at,'YYYY-MM-01') as settled_month
    ,0 as transactions
    ,0 as charges
    ,0 as refunds
    ,fi.chargeback_amount/100.0 as chargebacks
    ,0 as adjustments
    ,fi.chargeback_fee/100.0  AS fees
FROM
     odf${environment}.funding_instruction fi 
LEFT JOIN 
     odf${environment}.fiserv_transaction ft  on  fi.id = ft.funding_instruction_id     
WHERE 
    (fi.status = 'SETTLED' or ft.status = 'SETTLED') 
)
,

transaction_details_daily_summary_new as
(
    SELECT * from transaction_details_daily_summary
    UNION
    SELECT * from device_fee_sum
    UNION
    SELECT * from chargebacks
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
    ,coalesce(a.fees) as fees
    ,coalesce(b.revenue,0) as revenue
    ,extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',settled_at))::bigint * 1000 as epoch_funding_date
    ,extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',settled_month))::bigint * 1000 as epoch_funding_month
    ,current_timestamp::timestamp as dwh_created_at
FROM 
    transaction_details_daily_summary_new a
JOIN 
    odf${environment}.funding_instruction b 
    on a.funding_instruction_id = b.id
)

SELECT * FROM main
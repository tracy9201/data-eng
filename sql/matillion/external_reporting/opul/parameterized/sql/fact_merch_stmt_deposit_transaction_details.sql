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
      payment b ON a.transaction_id = b.transaction_id
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
    fi.mid as merchant_id,
    ft.funding_instruction_id,
    ft.transaction_id,
    ft.transaction_type,
    ft.transaction_date,
    1 as transactions,
    case when ft.transaction_type = 'PAYMENT' then ft.amount/100.0  end as charges,
    case when ft.transaction_type = 'REFUND' then  coalesce(ft.amount/100.0,0)  end as refunds,
    0 as chargebacks,
    0 as adjustments,
    case when ft.transaction_type = 'PAYMENT' then ft.percent_fee/10000.0*ft.amount/100.0
         when ft.transaction_type = 'REFUND'  then 0 
         end as fees,
    ft.cp_or_cnp,
    case when ft.card_brAND in ('00001','00085','00086','00087','00088','00092') then 'MasterCard'
         when ft.card_brAND in ('00002','00079','00080','00081','00082','00083','00084') then 'Visa'
         when ft.card_brAND = '00003' then 'Discover'
         when ft.card_brAND in ('00006','00008') then 'Amex'
         else 'Other' end as card_brand,
    ft.percent_fee_calc/100.0 as percent_fee,
    ft.percent_fee as ft_percent_fee,
    ft.settled_at::date as funding_date,
    to_date(settled_at,'YYYY-MM-01') as funding_month,
    'N/A' as last4
FROM 
    calc_fee ft
JOIN 
    odf${environment}.funding_instructiON fi ON ft.funding_instruction_id = fi.id
WHERE fi.status = 'SETTLED'
),

instruction_settled_date AS
(
   SELECT 
     funding_instruction_id,
     settled_at AS settled_at_date
   FROM odf${environment}.fiserv_transaction
   WHERE status = 'SETTLED'
   GROUP BY 1,2
),

device_fee AS
(
  SELECT 
    fee.chained_mid AS merchant_id,
    fee.funding_instruction_id,
    fee.external_id AS transaction_id,
    'Equipment' AS transaction_type,
    NULL AS transaction_date,
    1 as transactions,
    0.0 as charges,
    0.0 as refunds,
    0.0 as chargebacks,
    0.0 as adjustments,
    fee.amount/100.0 AS fees,
    'N/A' cp_or_cnp,
    'N/A' card_brand,
    0.0 as percent_fee,
    0.0 as ft_percent_fee,
    isd.settled_at_date::date as funding_date,
    to_date(isd.settled_at_date,'YYYY-MM-01') as funding_month,
    'N/A' as last4
  FROM odf${environment}.non_transactional_fee fee
  INNER JOIN
      instruction_settled_date isd ON isd.funding_instruction_id = fee.funding_instruction_id
  WHERE fee.funding_instruction_id IS NOT NULL
  AND fee.transaction_type = 'DEVICE_ORDER'
),

chargeback as
(
SELECT 
  ntf.chained_mid as merchant_id,
  ntf.funding_instruction_id,
  payment.transaction_id,
  'chargeback' as transaction_type,
  ntf.created_at as transaction_date,
  1 as transactions,
  0.0 as charges,
  0.0 as refunds,
  round(cast(ntf.deduction_amount as numeric)/100,2) as chargebacks,
  0 as adjustments,
  round(cast(ntf.amount as numeric)/100,2) as fees,
  case 
    when mid_type ='CARD_PRESENT' then 'CP' 
    when mid_type = 'CARD_NOT_PRESENT' then 'CNP' 
    end as cp_or_cnp,
  payment.card_brand,
  5.5 as percent_fee,
  0.0 as ft_percent_fee,
  ft.settled_at::date as funding_date,
  to_date(settled_at,'YYYY-MM-01') as funding_month,
  payment.account_number as last4
FROM odf${environment}.non_transactional_fee ntf
LEFT JOIN 
    odf${environment}.funding_instructiON fi 
      ON ntf.funding_instruction_id = fi.id
LEFT JOIN
    odf${environment}.fiserv_transactiON ft
      ON ntf.funding_instruction_id = ft.funding_instruction_id
INNER JOIN 
  chargeback${environment}.dispute_transactions dt
    ON ntf.external_id = dt.id
INNER JOIN 
  gaia_opul${environment}.payment payment
    ON dt.transaction_id = payment.external_id
INNER JOIN 
  gaia_opul${environment}.plan plan
    ON payment.plan_id = plan.id
INNER JOIN 
  gaia_opul${environment}.customer customer
    ON plan.customer_id = customer.id
WHERE 
  dt.mid_type = 'CARD_PRESENT'
  AND ntf.funding_instruction_id is not null
  AND fi.status = 'SETTLED'

UNION ALL 

SELECT 
  ntf.chained_mid as merchant_id,
  ntf.funding_instruction_id,
  payment.transaction_id,
  'chargeback' as transaction_type,
  ntf.created_at as transaction_date,
  1 as transactions,
  0.0 as charges,
  0.0 as refunds,
  round(cast(ntf.deduction_amount as numeric)/100,2) as chargebacks,
  0.0 as adjustments,
  round(cast(ntf.amount as numeric)/100,2) as fees,
  case 
    when mid_type ='CARD_PRESENT' then 'CP' 
    when mid_type = 'CARD_NOT_PRESENT' then 'CNP' 
    end as cp_or_cnp,
  payment.card_brand,
  5.5 as percent_fee,
  0.0 as ft_percent_fee,
  ft.settled_at::date as funding_date,
  to_date(settled_at,'YYYY-MM-01') as funding_month,
  payment.account_number as last4
FROM odf${environment}.non_transactional_fee ntf
LEFT JOIN 
    odf${environment}.funding_instructiON fi 
      ON ntf.funding_instruction_id = fi.id
LEFT JOIN
    odf${environment}.fiserv_transactiON ft
      ON ntf.funding_instruction_id = ft.funding_instruction_id
INNER JOIN
  chargeback${environment}.dispute_transactions dt
    ON ntf.external_id = dt.id
INNER JOIN 
  gaia_opul${environment}.payment payment
    ON dt.transaction_id = payment.external_id
INNER JOIN 
  gaia_opul${environment}.plan plan
    ON payment.plan_id = plan.id
INNER JOIN 
  gaia_opul${environment}.customer customer
    ON plan.customer_id = customer.id
WHERE dt.mid_type = 'CARD_NOT_PRESENT'
  AND ntf.funding_instruction_id is not null
  AND fi.status = 'SETTLED'
),


main as 
(
    SELECT * FROM deposits_transaction_details
    UNION ALL
    SELECT * FROM device_fee
    UNION ALL
    SELECT * FROM chargeback

)

SELECT 
    *,
    extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',funding_date))::bigint * 1000  as epoch_funding_date,
    extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',funding_month))::bigint * 1000   as epoch_funding_month,
    current_timestamp::timestamp as dwh_created_at
FROM main

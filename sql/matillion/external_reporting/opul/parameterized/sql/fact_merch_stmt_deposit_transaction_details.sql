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

instruction_settled_date AS
(
   SELECT 
     funding_instruction_id,
     settled_at AS settled_at_date
   FROM odf${environment}.fiserv_transaction
   GROUP BY 1,2
),

device_fee AS
(
  SELECT 
    fee.mid AS merchant_id
    , fee.funding_instruction_id
    , NULL AS transaction_id
    , NULL AS transaction_date
    ,'Equipment' AS transaction_type
    ,fee.amount/100.0 AS transaction_amount
    ,'N/A' cp_or_cnp
    , NULL funding_date
    , isd.settled_at_date
    ,'N/A' card_brand
    ,'N/A' subscriber
    ,'N/A' gx_customer_id
    ,'N/A' payment_id
  FROM odf${environment}.non_transactional_fee fee
  INNER JOIN
      instruction_settled_date isd ON isd.funding_instruction_id = fee.funding_instruction_id
),

transaction_details as 
(
SELECT 
    fi.mid as merchant_id
    ,ft.funding_instruction_id
    ,ft.transaction_id
    ,pt.created_at as transaction_date
    ,case when ft.transaction_type = 'PAYMENT' then 'Sales' 
          when ft.transaction_type = 'REFUND' then  'Refunds'
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
    ,case when ft.transaction_type = 'PAYMENT' then ft.percent_fee/10000.0*ft.amount/100.0
          when ft.transaction_type = 'REFUND'  then 0 - ft.percent_fee_calc/10000.0*ft.amount/100.0  end as ft_fees
FROM 
    calc_fee ft
JOIN 
    odf${environment}.funding_instruction fi on ft.funding_instruction_id = fi.id
JOIN 
    odf${environment}.payment_transaction pt on ft.transaction_id = pt.transaction_id 
    and ft.transaction_type = pt.transaction_type
    and ft.amount = pt.amount
WHERE (fi.status = 'SETTLED' or ft.status = 'SETTLED')

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
    ,'Non-Member'::varchar as subscriber
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
SELECT  DISTINCT
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


fee_at_cp_cnp_level as
(
SELECT  
     merchant_id
    ,funding_instruction_id
    ,cp_or_cnp
    ,settled_at_date
    ,round(sum(ft_fees),2) as transaction_amount
FROM
    transaction_details
GROUP BY 1,2,3,4
),


fee as
(
SELECT  
     merchant_id
    ,NULL AS funding_instruction_id
    ,'N/A' AS transaction_id
    ,NULL AS transaction_date
    ,case when cp_or_cnp = 'CP' then 'CP Fees'
          when cp_or_cnp = 'CNP' then 'CNP Fees' end as transaction_type
    ,transaction_amount
    ,cp_or_cnp
    ,NULL AS funding_date
    ,settled_at_date
    ,'N/A' AS card_brand
    ,'N/A' AS subscriber
    ,'N/A' AS gx_customer_id
    ,'N/A' AS payment_id
FROM
    fee_at_cp_cnp_level
WHERE transaction_amount <> 0 
),

chargeback as
(
SELECT 
  ntf.chained_mid as merchant_id,
  ntf.funding_instruction_id,
  payment.transaction_id,
  ntf.created_at as transaction_date,
  'chargeback' as transaction_type,
  round(cast(ntf.deduction_amount as numeric)/100,2) as transaction_amount,
  case 
    when mid_type ='CARD_PRESENT' then 'CP' 
    when mid_type = 'CARD_NOT_PRESENT' then 'CNP' 
    end as cp_or_cnp,
  fi.created_at::date as funding_date,
  ft.settled_at::date as settled_at_date,
  payment.card_brand,
  'Non-Member' as subscriber,
  customer.encrypted_ref_id as gx_customer_id,
  payment.account_number as payment_id
FROM odf${environment}.non_transactional_fee ntf
left JOIN 
    odf${environment}.funding_instruction fi 
      on ntf.funding_instruction_id = fi.id
left join
    odf${environment}.fiserv_transaction ft
      on ntf.funding_instruction_id = ft.funding_instruction_id
inner join 
  chargeback${environment}.dispute_transactions dt
    on ntf.external_id = dt.id
inner join 
  gaia_opul${environment}.payment payment
    on dt.transaction_id = payment.external_id
inner join 
  gaia_opul${environment}.plan plan
    on payment.plan_id = plan.id
inner join 
  gaia_opul${environment}.customer customer
    on plan.customer_id = customer.id
where 
  dt.mid_type = 'CARD_PRESENT'
  and ntf.funding_instruction_id is not null

union 

SELECT 
  ntf.chained_mid as merchant_id,
  ntf.funding_instruction_id,
  payment.transaction_id,
  ntf.created_at as transaction_date,
  'chargeback' as transaction_type,
  round(cast(ntf.deduction_amount as numeric)/100,2) as transaction_amount,
  case 
    when mid_type ='CARD_PRESENT' then 'CP' 
    when mid_type = 'CARD_NOT_PRESENT' then 'CNP' 
    end as cp_or_cnp,
  fi.created_at::date as funding_date,
  ft.settled_at::date as settled_at_date,
  payment.card_brand,
  'Non-Member' as subscriber,
  customer.encrypted_ref_id as gx_customer_id,
  payment.account_number as payment_id
FROM odf${environment}.non_transactional_fee ntf
left JOIN 
    odf${environment}.funding_instruction fi 
      on ntf.funding_instruction_id = fi.id
left join
    odf${environment}.fiserv_transaction ft
      on ntf.funding_instruction_id = ft.funding_instruction_id
inner join
  chargeback${environment}.dispute_transactions dt
    on ntf.external_id = dt.id
inner join 
  gaia_opul${environment}.payment payment
    on dt.transaction_id = payment.external_id
inner join 
  gaia_opul${environment}.plan plan
    on payment.plan_id = plan.id
inner join 
  gaia_opul${environment}.customer customer
    on plan.customer_id = customer.id
where dt.mid_type = 'CARD_NOT_PRESENT'
  and ntf.funding_instruction_id is not null
),

chargeback_fee as
(
SELECT 
  ntf.chained_mid as merchant_id,
  ntf.funding_instruction_id,
  payment.transaction_id,
  ntf.created_at as transaction_date,
  'chargeback_fee' as transaction_type,
  round(cast(ntf.amount as numeric)/100,2) as transaction_amount,
  case 
    when mid_type ='CARD_PRESENT' then 'CP' 
    when mid_type = 'CARD_NOT_PRESENT' then 'CNP' 
    end as cp_or_cnp,
  fi.created_at::date as funding_date,
  ft.settled_at::date as settled_at_date,
  payment.card_brand,
  'Non-Member' as subscriber,
  customer.encrypted_ref_id as gx_customer_id,
  payment.account_number as payment_id
FROM odf${environment}.non_transactional_fee ntf
left JOIN 
    odf${environment}.funding_instruction fi 
      on ntf.funding_instruction_id = fi.id
left join
    odf${environment}.fiserv_transaction ft
      on ntf.funding_instruction_id = ft.funding_instruction_id
inner join 
  chargeback${environment}.dispute_transactions dt
    on ntf.external_id = dt.id
inner join 
  gaia_opul${environment}.payment payment
    on dt.transaction_id = payment.external_id
inner join 
  gaia_opul${environment}.plan plan
    on payment.plan_id = plan.id
inner join 
  gaia_opul${environment}.customer customer
    on plan.customer_id = customer.id
where 
  dt.mid_type = 'CARD_PRESENT'
  and ntf.funding_instruction_id is not null

union 

SELECT 
  ntf.chained_mid as merchant_id,
  ntf.funding_instruction_id,
  ptt.order_id as transaction_id,
  ntf.created_at as transaction_date,
  'chargeback_fee' as transaction_type,
  round(cast(ntf.amount as numeric)/100,2) as transaction_amount,
  case 
    when mid_type ='CARD_PRESENT' then 'CP' 
    when mid_type = 'CARD_NOT_PRESENT' then 'CNP' 
    end as cp_or_cnp,
  fi.created_at::date as funding_date,
  ft.settled_at::date as settled_at_date,
  payment.card_brand,
  'Non-Member' as subscriber,
  customer.encrypted_ref_id as gx_customer_id,
  payment.account_number as payment_id
FROM odf${environment}.non_transactional_fee ntf
left JOIN 
    odf${environment}.funding_instruction fi 
      on ntf.funding_instruction_id = fi.id
left join
    odf${environment}.fiserv_transaction ft
      on ntf.funding_instruction_id = ft.funding_instruction_id
inner join
  chargeback${environment}.dispute_transactions dt
    on ntf.external_id = dt.id
left JOIN 
    payment${environment}.payment_transaction ptt
      on ptt.id = dt.transaction_id
inner join 
  gaia_opul${environment}.payment payment
    on dt.transaction_id = payment.external_id
inner join 
  gaia_opul${environment}.plan plan
    on payment.plan_id = plan.id
inner join 
  gaia_opul${environment}.customer customer
    on plan.customer_id = customer.id
where dt.mid_type = 'CARD_NOT_PRESENT'
  and ntf.funding_instruction_id is not null
),


main as 
(

    SELECT * FROM all_transactions
    UNION ALL
    SELECT * FROM fee
	  UNION 
    SELECT * FROM device_fee
    UNION 
    SELECT * FROM chargeback
    UNION 
    SELECT * FROM chargeback_fee
)

SELECT 
    *
    ,extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',transaction_date)) as epoch_transaction_date
    ,extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',funding_date)) as epoch_funding_date
    ,extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',settled_at_date))  as epoch_settled_at_date
    ,current_timestamp::timestamp as dwh_created_at
FROM main

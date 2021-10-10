WITH last_revised_record_fiserv_transaction_per_day as
(

    SELECT id, max(rev) as last_revised_record_id
    FROM 
      odf${environment}.fiserv_transaction_aud
    GROUP BY id, created_at::date
),

last_revised_record_payment_transaction_per_day as
(

    SELECT id, max(rev) as last_revised_record_id
    FROM 
      odf${environment}.payment_transaction_aud
    GROUP BY id, created_at::date
),

last_revised_record_non_transactional_fee_per_day as
(

    SELECT id, max(rev) as last_revised_record_id
    FROM 
      odf${environment}.non_transactional_fee_aud
    GROUP BY id, created_at::date
),

fiserv_transaction_with_history as 
(

    SELECT *
    FROM 
      odf${environment}.fiserv_transaction

    UNION 

    SELECT 
      a.id
      , a.merchant_id
      , a.transaction_id
      , a.transaction_type
      , a.transaction_status
      , a.amount
      , a.cp_or_cnp
      , a.api_response
      , a.transaction_date
      , a.transaction_time
      , a.card_brand
      , a.card_identifier
      , a.expiry
      , a.invoice_id
      , a.exchange_added_date
      , a.created_at
      , a.updated_at
      , a.percent_fee
      , a.fixed_fee
      , a.total_fee
      , a.funding_instruction_id
      , a.settled_at
      , a.status
      , a.fiserv_id
      , a.computed_fee
    FROM 
      odf${environment}.fiserv_transaction_aud a    
    JOIN
      last_revised_record_fiserv_transaction_per_day b on a.id = b.id and a.rev = b.last_revised_record_id
),

payment_transaction_with_history as 
(

    SELECT *
    FROM 
      odf${environment}.payment_transaction

    UNION 

    SELECT 
      a.id 
      , a.created_at
      , a.updated_at
      , a.deprecated_at
      , a.processed_at
      , a.transaction_id
      , a.transaction_type
      , a.cp_or_cnp
      , a.merchant_id
      , a.amount
      , a.currency
      , a.status
      , a.issuer
      , a.percent_fee
      , a.fixed_fee
      , a.total_fee
      , a.funding_instruction_id
      , a.settled_at
      , a.external_id
      , a.computed_fee
      , a.transaction_time
    FROM 
      odf${environment}.payment_transaction_aud a    
    JOIN
      last_revised_record_payment_transaction_per_day b on a.id = b.id and a.rev = b.last_revised_record_id
),

non_transactional_fee_with_history as 
(

    SELECT *
    FROM 
      odf${environment}.non_transactional_fee

    UNION 

    SELECT 
      a.id 
      , a.external_id
      , a.funding_instruction_id
      , a.settlement_id
      , a.mid 
      , a.chained_mid 
      , a.currency
      , a.amount
      , a.funding_type
      , a.transaction_type
      , a.transaction_date
      , a.scheduled_funding_date
      , a.created_at
      , a.updated_at
      , a.deprecated_at
      , a.deduction_amount
      , a.order_volume
      , a.amount_per_unit
      , a.settled_at
    FROM 
      odf${environment}.non_transactional_fee_aud a    
    JOIN
      last_revised_record_non_transactional_fee_per_day b on a.id = b.id and a.rev = b.last_revised_record_id
),

refunds as
(
  SELECT *
  FROM 
      fiserv_transaction_with_history
  WHERE
      transaction_type = 'REFUND'
),


payment as
(
  SELECT *
  FROM 
      fiserv_transaction_with_history
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
      fiserv_transaction_with_history
  WHERE
      transaction_type <> 'REFUND'
),

instruction_settled_date AS
(
   SELECT 
     funding_instruction_id,
     settled_at AS settled_at_date
   FROM fiserv_transaction_with_history
   GROUP BY 1,2
),

device_fee AS
(
  SELECT 
    fee.chained_mid AS merchant_id
    , fee.funding_instruction_id
    , fee.id:: VARCHAR(255) AS transaction_id
    , NULL AS transaction_date
    ,'Equipment' AS transaction_type
    ,fee.amount/100.0 AS transaction_amount
    ,'N/A' cp_or_cnp
    , fi.created_at::date as batch_date
    , isd.settled_at_date
    ,'N/A' card_brand
    ,'N/A' subscriber
    ,'N/A' gx_customer_id
    ,'N/A' payment_id
    ,'N/A' as firstname
    ,'N/A' as lastname
  FROM non_transactional_fee_with_history fee
  INNER JOIN
      instruction_settled_date isd ON isd.funding_instruction_id = fee.funding_instruction_id
  INNER JOIN
       odf${environment}.funding_instruction fi on isd.funding_instruction_id = fi.id
  WHERE
      fee.transaction_type = 'DEVICE_ORDER' AND fi.status !='FAILED'

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
    ,fi.created_at::date as batch_date
    ,ft.settled_at::date as settled_at_date
    ,case when ft.card_brand in ('00001','00085','00086','00087','00088','00092') then 'MasterCard'
          when ft.card_brand in ('00002','00079','00080','00081','00082','00083','00084') then 'Visa'
          when ft.card_brand = '00003' then 'Discover'
          when ft.card_brand in ('00006','00008') then 'Amex'
          else 'Other' end as card_brand
    ,ft.percent_fee as ft_percent_fee
    ,fi.fee as fi_fees
    ,case when ft.transaction_type = 'PAYMENT' then ft.percent_fee/10000.0*ft.amount/100.0
          when ft.transaction_type = 'REFUND'  then 0  end as ft_fees
FROM 
    calc_fee ft
JOIN 
    odf${environment}.funding_instruction fi on ft.funding_instruction_id = fi.id
JOIN 
    payment_transaction_with_history pt on ft.transaction_id = pt.transaction_id 
    and ft.transaction_type = pt.transaction_type
    and ft.amount = pt.amount
WHERE (ft.status != 'FAILED' OR ft.status is null) AND fi.status !='FAILED'

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
    ,a.batch_date
    ,a.settled_at_date
    ,a.card_brand
    ,a.ft_percent_fee
    ,a.fi_fees
    ,CASE WHEN b.last_transaction_id IS NOT NULL then a.fi_fees END as correct_fi_fees
    ,CASE WHEN b.last_transaction_id IS NOT NULL then 'Y' END as is_fee_record
    ,'Non-Member'::varchar as subscriber
    ,c.gx_customer_id
    ,c.payment_id
    ,c.firstname
    ,c.lastname
FROM
    transaction_details a
LEFT JOIN
    last_trans_for_each_funding_id  b on a.transaction_id = b.last_transaction_id 
    and a.funding_instruction_id=b.funding_instruction_id 
LEFT JOIN
    dwh_opul${environment}.fact_batch_report_details c on a.transaction_id = c.transaction_id 
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
    ,batch_date
    ,settled_at_date
    ,card_brand
    ,subscriber
    ,gx_customer_id
    ,payment_id
    ,firstname
    ,lastname
FROM
    transaction_details_with_correct_fee
),


fee_at_cp_cnp_level as
(
SELECT  
     merchant_id
    ,funding_instruction_id
    ,cp_or_cnp
    ,batch_date
    ,settled_at_date
    ,round(sum(ft_fees),2) as transaction_amount
FROM
    transaction_details
GROUP BY 1,2,3,4,5
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
    ,batch_date
    ,settled_at_date
    ,'N/A' AS card_brand
    ,'N/A' AS subscriber
    ,'N/A' AS gx_customer_id
    ,'N/A' AS payment_id
    ,'N/A' AS firstname
    ,'N/A' as lastname
FROM
    fee_at_cp_cnp_level
WHERE transaction_amount <> 0 
),

chargeback as 
(
SELECT 
  ntf.chained_mid as merchant_id,
  ntf.funding_instruction_id,
  case 
    when mid_type ='CARD_PRESENT' then payment.transaction_id
    when mid_type = 'CARD_NOT_PRESENT' then ptt.order_id 
    end as transaction_id,
  ntf.created_at as transaction_date,
  'chargeback' as transaction_type,
  round(cast(ntf.deduction_amount as numeric)/100,2) as transaction_amount,
  case 
    when mid_type ='CARD_PRESENT' then 'CP' 
    when mid_type = 'CARD_NOT_PRESENT' then 'CNP' 
    end as cp_or_cnp,
  fi.created_at::date as batch_date,
  ft.settled_at::date as settled_at_date,
  payment.card_brand,
  'Non-Member' as subscriber,
  customer.encrypted_ref_id as gx_customer_id,
  payment.account_number as payment_id
  ,'N/A' AS firstname
    ,'N/A' as lastname
FROM non_transactional_fee_with_history ntf
left JOIN 
    odf${environment}.funding_instruction fi 
      on ntf.funding_instruction_id = fi.id
left join
    fiserv_transaction_with_history ft
      on ntf.funding_instruction_id = ft.funding_instruction_id
left join
  chargeback${environment}.dispute_transactions dt
    on ntf.external_id = dt.id
left JOIN 
    payment${environment}.payment_transaction ptt
      on ptt.id = dt.transaction_id
left join 
  gaia_opul${environment}.payment payment
    on dt.transaction_id = payment.external_id
left join 
  gaia_opul${environment}.plan plan
    on payment.plan_id = plan.id
left join 
  gaia_opul${environment}.customer customer
    on plan.customer_id = customer.id
where ntf.funding_instruction_id is not null 
AND  ntf.transaction_type = 'CHARGEBACK'
AND  ( payment.type = 'credit_card' OR ptt.tender_type = 'CREDIT_CARD' )
AND fi.status !='FAILED'
),

chargeback_fee as
(
SELECT 
  ntf.chained_mid as merchant_id,
  ntf.funding_instruction_id,
  case 
    when mid_type ='CARD_PRESENT' then payment.transaction_id
    when mid_type = 'CARD_NOT_PRESENT' then ptt.order_id 
    end as transaction_id,
  ntf.created_at as transaction_date,
  'chargeback_fee' as transaction_type,
  round(cast(ntf.amount as numeric)/100,2) as transaction_amount,
  case 
    when mid_type ='CARD_PRESENT' then 'CP' 
    when mid_type = 'CARD_NOT_PRESENT' then 'CNP' 
    end as cp_or_cnp,
  fi.created_at::date as batch_date,
  ft.settled_at::date as settled_at_date,
  payment.card_brand,
  'Non-Member' as subscriber,
  'N/A' AS gx_customer_id,
  payment.account_number as payment_id
  ,'N/A' AS firstname
    ,'N/A' as lastname
FROM non_transactional_fee_with_history ntf
left JOIN 
    odf${environment}.funding_instruction fi 
      on ntf.funding_instruction_id = fi.id
left join
    fiserv_transaction_with_history ft
      on ntf.funding_instruction_id = ft.funding_instruction_id
left join
  chargeback${environment}.dispute_transactions dt
    on ntf.external_id = dt.id
left JOIN 
    payment${environment}.payment_transaction ptt
      on ptt.id = dt.transaction_id
left join 
  gaia_opul${environment}.payment payment
    on dt.transaction_id = payment.external_id
left join 
  gaia_opul${environment}.plan plan
    on payment.plan_id = plan.id
left join 
  gaia_opul${environment}.customer customer
    on plan.customer_id = customer.id
where ntf.funding_instruction_id is not null
AND  ntf.transaction_type = 'CHARGEBACK'
AND  ( payment.type = 'credit_card' OR ptt.tender_type = 'CREDIT_CARD' )
AND fi.status !='FAILED'
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
    a.*
    ,extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',a.transaction_date)) as epoch_transaction_date
    ,extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',a.batch_date)) as epoch_batch_date
    ,extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',a.settled_at_date)) as epoch_settled_at_date
    ,current_timestamp::timestamp as dwh_created_at
FROM main a
JOIN dwh_opul${environment}.dim_practice_odf_mapping b on a.merchant_id = b.card_processing_mid

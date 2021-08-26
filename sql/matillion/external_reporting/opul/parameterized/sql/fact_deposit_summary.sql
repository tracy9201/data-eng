with fiserv_transaction as
(
SELECT distinct
    funding_instruction_id,
    status,
    settled_at
FROM odf${environment}.fiserv_transaction
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
    fee.funding_instruction_id  as reference_id
    ,isd.settled_at_date as funding_date
    , isd.settled_at_date
    , fee.mid AS merchant_id
    , 0.0 as adjustments
    , CAST(fee.amount /100.0 as decimal(10,2)) AS fees
    , 0.0 AS net_sales
    , 0.0 as chargebacks
  FROM odf${environment}.non_transactional_fee fee
  INNER JOIN
      instruction_settled_date isd ON isd.funding_instruction_id = fee.funding_instruction_id
  WHERE fee.settlement_id is not null AND fee.transaction_type = 'DEVICE_ORDER'
),

funding_instruction as
(
SELECT
    fi.id as funding_instruction_id,
    fi.mid as merchant_id,
    fi.created_at AS funding_date,
    ft.settled_at::date AS settled_at_date,
    0 as adjustments,
    coalesce(fi.fee,0) as fees,
    coalesce(fi.amount,0) as net_sales,
    coalesce(fi.chargeback_amount,0) as chargebacks,
    current_timestamp::timestamp as dwh_created_at                           
FROM
     odf${environment}.funding_instruction fi 
LEFT JOIN 
     fiserv_transaction ft  on  fi.id = ft.funding_instruction_id     
WHERE 
    (fi.status = 'SETTLED' or ft.status = 'SETTLED')
),

payfac as
(
SELECT 
    funding_instruction_id as reference_id,
    funding_date,
    settled_at_date,
    merchant_id,
    CAST(adjustments/100.0 as decimal(10,2)) as adjustments,
    CAST(fees/100.0 as decimal(10,2)) AS fees,
    CAST(net_sales/100.0 as decimal(10,2)) AS net_sales,
    CAST(chargebacks/100.0 as decimal(10,2)) as chargebacks
FROM funding_instruction
),

main_union AS(
    SELECT * from payfac
    UNION
    SELECT * from device_fee
),

main AS
(
SELECT *, 
    extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',funding_date)) as epoch_funding_date,
    extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',settled_at_date))  as epoch_settled_at_date,
    current_timestamp::timestamp as dwh_created_at
FROM main_union
)

SELECT * FROM main
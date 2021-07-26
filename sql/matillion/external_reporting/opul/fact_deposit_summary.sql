with funding_instruction as
(SELECT
    id as funding_instruction_id,
    mid as merchant_id,
    (created_at)::varchar||merchant_id::varchar as reference_id,
    created_at AS funding_date,
    0 as adjustments,
    coalesce(fee,0) as fees,
    coalesce(amount,0) as net_sales,
    0 as chargebacks,
    extract(epoch from created_at) as epoch_funding_date,
    current_timestamp::timestamp as dwh_created_at                           
FROM
     odf.funding_instruction                        
WHERE 
    status = 'SETTLED' 
),
instruction_settled_date AS
(
   SELECT 
     funding_instruction_id,
     settled_at AS settled_at_date
   FROM odf.fiserv_transaction
   GROUP BY 1,2
),

device_fee AS
(
  SELECT 
    fee.funding_instruction_id  as reference_id
    ,isd.settled_at_date as funding_date
    , fee.mid AS merchant_id
    , 0 as adjustments
    , fee.amount /100.0 AS fees
    , 0 AS net_sales
    , 0 as chargebacks
  FROM odf.non_transactional_fee fee
  INNER JOIN
      instruction_settled_date isd ON isd.funding_instruction_id = fee.funding_instruction_id
  WHERE fee.settlement_id is not null
),
payfac as
(
SELECT 
    funding_instruction_id as reference_id,
    funding_date,
    merchant_id,
    adjustments/100.0 as adjustments,
    fees/100.0 AS fees,
    net_sales/100.0 AS net_sales,
    chargebacks/100.0 as chargebacks
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
    extract(epoch from funding_date) as epoch_funding_date,
    current_timestamp::timestamp as dwh_created_at
FROM main_union
)

SELECT * FROM main
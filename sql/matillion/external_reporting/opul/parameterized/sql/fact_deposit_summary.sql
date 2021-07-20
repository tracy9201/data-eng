with fiserv_transaction as
(
SELECT distinct
    funding_instruction_id,
    settled_at
FROM odf${environment}.fiserv_transaction
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
    0 as chargebacks,
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
    adjustments/100.0 as adjustments,
    fees/100.0 AS fees,
    net_sales/100.0 AS net_sales,
    chargebacks/100.0 as chargebacks
FROM funding_instruction
),

main AS
(
SELECT *, 
    extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',funding_date)) as epoch_funding_date,
    extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',settled_at_date))  as epoch_settled_at_date,
    current_timestamp::timestamp as dwh_created_at
FROM payfac
)

SELECT * FROM main
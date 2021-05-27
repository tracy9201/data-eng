with fiserv_transaction as
(
SELECT distinct
    funding_instruction_id,
    settled_at
FROM odf${environment}.fiserv_transaction
),

funding_instruction as
(SELECT
    fi.id as funding_instruction_id,
    fi.mid as merchant_id,
    fi.created_at AS funding_instruction_date,
    ft.settled_at::date as settled_at_date,
    0 as adjustments,
    coalesce(fi.fee,0) as fees,
    coalesce(fi.amount,0) as net_sales,
    0 as chargebacks,
    extract(epoch from fi.created_at) as epoch_funding_date,
    current_timestamp::timestamp as dwh_created_at                           
FROM
     odf${environment}.funding_instruction fi 
LEFT JOIN 
     fiserv_transaction ft  on  fi.id = ft.funding_instruction_id     
WHERE 
    fi.status = 'SETTLED' 
),

payfac as
(
SELECT 
    funding_instruction_id as reference_id,
    funding_instruction_date,
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
    extract(epoch from funding_instruction_date) as epoch_funding_instruction_date,
    extract(epoch from settled_at_date) as epoch_settled_at_date,
    current_timestamp::timestamp as dwh_created_at
FROM payfac
)

SELECT * FROM main
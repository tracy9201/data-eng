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
    coalesce(fi.chargeback_amount + chargeback_reversal_amount,0) as chargebacks,
    ft.status as status,
    current_timestamp::timestamp as dwh_created_at                           
FROM
     odf${environment}.funding_instruction fi 
LEFT JOIN 
     fiserv_transaction ft  on  fi.id = ft.funding_instruction_id     
WHERE 
    (ft.status != 'FAILED' or ft.status is null) AND fi.status !='FAILED'
),

payfac as
(
SELECT 
    funding_instruction_id as reference_id,
    funding_date as batch_date,
    settled_at_date,
    merchant_id,
    CAST(adjustments/100.0 as decimal(10,2)) as adjustments,
    CAST(fees/100.0 as decimal(10,2)) AS fees,
    CAST(net_sales/100.0 as decimal(10,2)) AS net_sales,
    CAST(chargebacks/100.0 as decimal(10,2)) as chargebacks
FROM funding_instruction
),


main AS
(
SELECT a.*, 
    extract (epoch from CONVERT_TIMEZONE('UTC',b.practice_time_zone,a.batch_date)) as epoch_batch_date,
    extract (epoch from CONVERT_TIMEZONE('UTC',b.practice_time_zone,a.settled_at_date))  as epoch_settled_at_date,
    current_timestamp::timestamp as dwh_created_at
FROM payfac a
JOIN dwh_opul${environment}.dim_practice_odf_mapping b on a.merchant_id = b.card_processing_mid
)

SELECT * FROM main
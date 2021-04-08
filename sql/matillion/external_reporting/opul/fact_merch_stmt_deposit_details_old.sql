WITH funding_instruction as
(
SELECT
    id as funding_instruction_id
    ,mid as merchant_id
    ,(created_at)::varchar||merchant_id::varchar as reference_id
    ,created_at AS funding_date
    ,0 as adjustments
    ,coalesce(fee,0) as fees
    ,coalesce(amount,0) as net_sales
    ,case when amount < 0 then 0 - amount end as refunds
    ,0 as chargebacks                          
FROM
    odf.funding_instruction                        
WHERE 
    status = 'SETTLED' 
),

daily_summary as
(
SELECT 
    funding_date::date as funding_date
    ,to_date(funding_date,'YYYY-MM-01') as funding_month
    ,merchant_id
    ,count(1) as transactions
    ,sum(net_sales/100.0) AS charges
    ,sum(refunds/100.0) as refunds
    ,sum(chargebacks/100.0) as chargebacks
    ,sum(adjustments/100.0) as adjustments
    ,sum(fees/100.0) AS fees   
FROM 
    funding_instruction
GROUP BY 1,2,3
),

main as
(
SELECT *
    ,extract (epoch from funding_date) as epoch_funding_date
    ,extract (epoch from funding_month) as epoch_funding_month
    ,current_timestamp::timestamp as dwh_created_at
FROM 
    daily_summary
)

SELECT * FROM main

with fact_deposit_details as (
select 
  funding_instruction_id as reference_id,
  trunc(settled_at_date) as settled_at_date,
  merchant_id,
  0 as adjustments,
  case when transaction_type in ('CNP Fees', 'CP Fees', 'chargeback_fee', 'Equipment') then transaction_amount end as fees,
  case when transaction_type = 'Sales' then transaction_amount end as sales,
  case when transaction_type = 'Refunds' then transaction_amount end as refunds,
  case when transaction_type in ('chargeback', 'chargeback_reversal') then transaction_amount end as chargebacks
from dwh_opul${environment}.fact_deposit_details
),

deposit_sum as (
select 
  reference_id,
  settled_at_date as funding_date,
  settled_at_date,
  merchant_id,
  coalesce(sum(adjustments),0) as adjustments,
  coalesce(sum(fees),0) as fees,
  coalesce(sum(sales - coalesce(refunds,0)),0) as net_sales,
  coalesce(sum(chargebacks),0) as chargebacks
from fact_deposit_details
group by 1,2,3,4
),

main AS
(
SELECT a.*, 
    extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',a.funding_date)) as epoch_funding_date,
    extract (epoch from CONVERT_TIMEZONE('America/Los_Angeles','UTC',a.settled_at_date)) as epoch_settled_at_date,
    current_timestamp::timestamp as dwh_created_at
FROM deposit_sum a
JOIN dwh_opul${environment}.dim_practice_odf_mapping b on a.merchant_id = b.card_processing_mid
where settled_at_date is not null
)

SELECT * FROM main
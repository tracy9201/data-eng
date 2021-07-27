With Main as (
  SELECT 
    settle.id as settlement_id, 
    settle.transaction_id, 
    settle.type, 
    settle.reason, 
    settle.settlement_status, 
    settle.settlement_date, 
    settle.funding_txn_id, 
    fund.created_at as funding_created_date, 
    fund.funding_date as funding_date, 
    fund.total_funding :: numeric(18, 2), 
    fund.interchange_fee :: numeric(18, 2), 
    fund.net_sales :: numeric(18, 2), 
    fund.other_adjustment :: numeric(18, 2), 
    fund.reversal :: numeric(18, 2), 
    fund.service_charge :: numeric(18, 2), 
    fund.third_party :: numeric(18, 2), 
    fund.date_added as fund_date_added 
  FROM 
    internal_gaia_hint.settlement settle 
    left join internal_gaia_hint.funding fund on settle.funding_txn_id = fund.funding_master_id
) 
select 
  * 
from 
  main

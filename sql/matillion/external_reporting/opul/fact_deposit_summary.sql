WITH adjustments AS 
(                              
SELECT
    'adjustment_'||id AS depost_id,
    reference_id,
    merchant_id,
    amount,
    'Adjustment' AS type,
    transaction_date,
    exchange_date_added::date AS settled_date                                  
FROM
    odf.fiserv_deposit_adjustment                        
), 

transactions AS 
(                            
SELECT
    'transaction_'||id AS depost_id,
    funding_instruction_id::varchar AS reference_id,
    merchant_id,
    amount,
    transaction_type AS type,
    transaction_date,
    settled_at::date AS settled_date                                  
FROM
    odf.fiserv_transaction                            
WHERE
    status = 'SETTLED'
),

chargebacks AS 
(                            
SELECT
    'chargeback_'||id AS depost_id,
    reference_id,
    merchant_id,
    amount,
    'Chargeback' AS type,
    transaction_date,
    exchange_date_added::date AS settled_date                            
FROM
    odf.fiserv_chargeback                        
), 

transaction_fee AS 
(                            
SELECT
    'transaction_fee_'||id AS depost_id,
    funding_instruction_id::varchar AS reference_id,
    merchant_id,
    percent_fee + fixed_fee AS amount,
    transaction_type AS type,
    transaction_date,
    settled_at::date AS settled_date                           
FROM
    odf.fiserv_transaction                            
WHERE 
    status = 'SETTLED'          
), 

payfac_all AS 
(                           
SELECT * FROM transactions  
UNION ALL 
SELECT * FROM chargebacks                  
UNION ALL                         
SELECT * FROM adjustments            
UNION ALL                     
SELECT * FROM transaction_fee            
), 

payfac AS 
(
SELECT
    reference_id,
    merchant_id,
    settled_date ,
    case when type = 'Adjustment' then sum(amount) else 0 end AS adjustments,
    case when type = 'fees' then sum(amount) else 0 end AS fees,
    case when type in ('Charge', 'Refund') then sum(amount) else 0 end AS net_sales,
    case when type = 'Chargeback' then sum(amount) else 0 end AS chargebacks            
FROM payfac_all
GROUP BY
    merchant_id,
    reference_id,
    settled_date,
    type 
),

main AS
(
SELECT *, 
    extract(epoch from settled_date) as epoch_settled_date,
    current_timestamp::timestamp as dwh_created_at
FROM payfac
)

SELECT * FROM main
DROP TABLE dwh.fact_payfac_fee_basis;

CREATE TABLE dwh.fact_payfac_fee_basis as
WITH cp as 
(
    SELECT 
    merchant_id
    ,to_char(settlement_date,'YYYY-MM') as settlement_month
    ,fee_type
    ,sum(CASE WHEN cp_or_cnp = 'cp' and type = 'Charge' THEN amount/100 ELSE 0 end) as basis
    FROM dwh.fact_payfac_deposit
    WHERE fee_type = 'Card Present Fee'
    GROUP BY 1,2,3
),

cnp as
(
    SELECT 
    merchant_id
    ,to_char(settlement_date,'YYYY-MM') as settlement_month
    ,fee_type
    ,sum(CASE WHEN cp_or_cnp = 'cnp' and type = 'Charge' THEN amount/100 ELSE 0 end) as basis
    FROM dwh.fact_payfac_deposit
    WHERE fee_type = 'Card Not Present Fee'
    GROUP BY 1,2,3
),

transactions_fee as
(
    SELECT 
    merchant_id
    ,to_char(settlement_date,'YYYY-MM') as settlement_month
    ,'Transaction Fee' as fee_type
    ,sum(CASE WHEN type = 'Charge' THEN 1 ELSE 0 end) as basis
    FROM dwh.fact_payfac_deposit
    WHERE type = 'Charge'
    GROUP BY 1,2,3
),

Chargeback_fee as
(
    SELECT 
    merchant_id
    ,to_char(settlement_date,'YYYY-MM') as settlement_month
    ,'Chargeback Fee' as fee_type
    ,sum(CASE WHEN type = 'Chargeback' THEN 1 ELSE 0 end) as basis
    FROM dwh.fact_payfac_deposit
    WHERE  type = 'Chargeback' 
    GROUP BY 1,2,3
),

main as 
(
    SELECT * FROM cp
    UNION
    SELECT * FROM cnp
    UNION
    SELECT * FROM transactions_fee
    UNION
    SELECT * FROM Chargeback_fee
)

SELECT 
    *
    ,CASE WHEN fee_type in ('Card Present Fee','Card Not Present Fee') THEN '$'||basis::varchar  ELSE basis::varchar END as basis_display 
FROM main;

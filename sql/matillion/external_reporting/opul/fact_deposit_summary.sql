with adjustments AS (                              
        select
            'adjustment_'||id as deposit_id,
            reference_id,
            merchant_id,
            amount,
            'Adjustment' AS type,
            transaction_date,
            exchange_date_added::date as settled_date                                  
        from
            odf.fiserv_deposit_adjustment                        
            )
            
, transactions AS (                           
        SELECT
            'transaction_'||id as deposit_id,
            funding_instruction_id::varchar as reference_id,
            merchant_id,
            amount,
            transaction_type AS type,
            transaction_date,
            settled_at::date as settled_date                                  
        FROM
            odf.fiserv_transaction                            
        WHERE
            transaction_status = 20
           )
, chargebacks AS (                            
        SELECT
            'chargeback_'||id as deposit_id,
            reference_id,
            merchant_id,
            amount,
            'Chargeback' AS type,
            transaction_date,
            exchange_date_added::date as settled_date                            
        FROM
            odf.fiserv_chargeback                        
             )
, transaction_fee as (                             
        SELECT
            'transaction_fee_'||id as deposit_id,
            funding_instruction_id::varchar as reference_id,
            merchant_id,
            percent_fee  + fixed_fee as amount,
            transaction_type AS type,
            transaction_date,
            settled_at::date as settled_date                           
        FROM
            odf.fiserv_transaction                            
        WHERE
            transaction_status = 20                       
            )
, payfac AS (                         
        SELECT * FROM transactions  
        UNION ALL 
        SELECT * FROM chargebacks                  
        UNION ALL                         
        SELECT * FROM adjustments            
        UNION ALL                     
        SELECT * FROM transaction_fee            
      )                        
, main as (
        SELECT
          reference_id,
          merchant_id,
          settled_date ,
          case when type = 'Adjustment' then sum(amount) else 0 end as adjustments,
          case when type = 'fees' then sum(amount) else 0 end as fees,
          case when type in ('Charge', 'Refund') then sum(amount) else 0 end as net_sales,
          case when type = 'Chargeback' then sum(amount) else 0 end as chargebacks            
      from payfac
      group by
          merchant_id,
          reference_id,
          settled_date,
          type 
        )
select * from main
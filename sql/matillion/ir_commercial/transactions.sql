WITH clover as (
select case when settle.gateway_transaction_id is not null then 'settle_'||settle.transaction_id
          when settle.gateway_transaction_id is null then 'settle_'||settle.id end as transaction_id
          , settle.settlement_status as status
          , null as user_id
          , 'credit_card' as payment_method
          , 'practice_clover_sale' as transaction
          , case when settle.settlement_status = 'Voided' then -1 * cast(settle.amount as numeric) else cast(settle.amount as numeric) end as amount
          , null as device_id 
          , settle.created_at as created_at
          , settle.created_at as updated_at
          , null as created_by
          , 0 as gratuity_amount
          , 'practice_clover_guest' as customer_type
          , null as payment_detail
          , pro.encrypted_ref_id as gx_provider_id
          , settle.transaction_id as clover_transaction_id
          from internal_gaia_hint.settlement settle
          left join 
            internal_gaia_hint.authorisation auth 
                on auth.identifier = settle.authorisation_id
          left join 
            internal_gaia_hint.provider pro 
                on auth.object_id = pro.id
          where 
            settle.settlement_status in ('Accepted', 'Processed', 'Voided')
),
transaction AS (
select 
    transactions.id as transaction_id,
    transactions.status, 
    transactions.user_id, 
    transactions.payment_method,
    transactions.transaction,
    round(cast(transactions.amount as numeric)/100,2) as amount , 
    transactions.device_id,
    transactions.created_at,
    transactions.updated_at, 
    transactions.created_by,
    round(cast(transactions.gratuity_amount as numeric)/100,2) as gratuity_amount, 
    transactions.customer_type,
    transactions.payment_detail,
    org.gx_provider_id, 
    transactions.transaction_id::varchar as clover_transaction_id
from 
    internal_kronos_hint.transactions transactions
left join 
    internal_kronos_hint.users users 
        on transactions.user_id  = users.id
left join 
    internal_kronos_hint.organization_data org 
        on org.id = users.organization_id
),
refund as (
    select 
        distinct gp.gx_transaction_id 
    from internal_kronos_hint.cached_gx_refund gr
    inner join 
        internal_kronos_hint.cached_gx_payment gp 
            on gx_payment_id = gp.id 
    inner join 
        internal_gaia_hint.gateway_transaction gt 
            on gp.gx_transaction_id = gt.transaction_id
    where gr.is_void = 'T'
),
void1 as (
select 
    'settle_'||settlement.id as transaction_id, 
    case when settlement.status = 1 then 'Active' else 'Inactive' end as status,
    user_id,
    'Credit Card' as payment_method,
    'Void' as transaction,
    cast(settlement.tendered as numeric) as amount,
    null as device_id,
    settlement.created_at,
    settlement.updated_at,
    null as created_by,
    0 as gratuity_amount,
    null as customer_type,
    null as payment_detail,
    org.gx_provider_id,
    settlement.transaction_id as clover_transaction_id
from internal_gaia_hint.settlement settlement
inner join 
    internal_gaia_hint.gateway_transaction gt 
        on gateway_transaction_id = gt.id 
left outer join refund
    on gt.transaction_id = refund.gx_transaction_id
inner JOIN 
    internal_gaia_hint.payment payment 
        ON  payment_id = payment.id
inner JOIN 
    internal_gaia_hint.plan gplan 
        ON payment.plan_id = gplan.id
inner join 
    internal_kronos_hint.plan kplan 
       on gplan.encrypted_ref_id = gx_plan_id
left join 
    internal_kronos_hint.users users 
        on kplan.user_id  = users.id
left join 
    internal_kronos_hint.organization_data org 
        on org.id = users.organization_id
where 
    settlement.settlement_status = 'Voided' 
    AND invoice_id IS NULL 
    AND gt.is_voided = 'f' 
    and refund.gx_transaction_id is null
),
void2 as (  
select 
    'settle_'||settlement.id as transaction_id, 
    case when settlement.status = 1 then 'Active' else 'Inactive' end as status,
    user_id,
    'Credit Card' as payment_method,
    'Void' as transaction,
    cast(settlement.tendered as numeric) as amount,
    null as device_id,
    settlement.created_at,
    settlement.updated_at,
    null as created_by,
    0 as gratuity_amount,
    null as customer_type,
    null as payment_detail,
    org.gx_provider_id,
    settlement.transaction_id as clover_transaction_id
from internal_gaia_hint.settlement settlement
inner join 
    internal_gaia_hint.gateway_transaction gt 
        on gateway_transaction_id = gt.id 
left outer join refund
        on gt.transaction_id = refund.gx_transaction_id
    LEFT JOIN 
        internal_gaia_hint.invoice invoice 
            ON gt.invoice_id = invoice.id
    LEFT JOIN 
        internal_gaia_hint.plan gplan 
            ON invoice.plan_id = gplan.id
    inner join 
        internal_kronos_hint.plan kplan 
            on gplan.encrypted_ref_id = gx_plan_id
left join 
    internal_kronos_hint.users users 
        on kplan.user_id  = users.id
left join 
    internal_kronos_hint.organization_data org 
        on org.id = users.organization_id
  where 
    settlement.settlement_status = 'Voided' 
    AND invoice_id IS NOT NULL 
    AND gt.is_voided = 'f' 
    and refund.gx_transaction_id is null
),
Main as (
select * from transaction
union all
select * from void1
union all
select * from void2
)
SELECT * FROM main 
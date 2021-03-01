select 
    id as transaction_id,
    status, 
    user_id, 
    payment_method,
    transaction,
    amount, 
    device_id,
    created_at,
    updated_at, 
    created_by,
    gratuity_amount, 
    customer_type,
    payment_detail
from kronos.transactions

union 

select 
    'settle_'||settlement.id as transaction_id, 
    case when settlement.status = 1 then 'Active' else 'Inactive' end as status,
    user_id,
    'Credit Card' as payment_method,
    'Void' as transaction,
    settlement.tendered*100 as amount,
    null as device_id,
    settlement.created_at,
    settlement.updated_at,
    null as created_by,
    0 as gratuity_amount,
    null as customer_type,
    null as payment_detail
from gaia.settlement settlement
inner join 
    gaia.gateway_transaction gt 
        on gateway_transaction_id = gt.id 
left outer join (
    select 
        distinct gp.gx_transaction_id 
    from kronos.cached_gx_refund gr
    inner join 
        kronos.cached_gx_payment gp 
            on gx_payment_id = gp.id 
    inner join 
        gaia.gateway_transaction gt 
            on gp.gx_transaction_id = gt.transaction_id
    where gr.is_void = 'T'
) tr 
    on gt.transaction_id = tr.gx_transaction_id
inner JOIN 
    gaia.payment payment 
        ON  payment_id = payment.id
inner JOIN 
    gaia.plan gplan 
        ON payment.plan_id = gplan.id
inner join 
    kronos.plan kplan 
        on gplan.encrypted_ref_id = gx_plan_id
where 
    settlement.settlement_status = 'Voided' 
    AND invoice_id IS NULL 
    AND gt.is_voided = 'f' 
    and tr.gx_transaction_id is null

  UNION ALL
  
select 
    'settle_'||settlement.id as transaction_id, 
    case when settlement.status = 1 then 'Active' else 'Inactive' end as status,
    user_id,
    'Credit Card' as payment_method,
    'Void' as transaction,
    settlement.tendered*100 as amount,
    null as device_id,
    settlement.created_at,
    settlement.updated_at,
    null as created_by,
    0 as gratuity_amount,
    null as customer_type,
    null as payment_detail
from gaia.settlement settlement
inner join 
    gaia.gateway_transaction gt 
        on gateway_transaction_id = gt.id 
left outer join (
    select 
        distinct gp.gx_transaction_id 
    from kronos.cached_gx_refund gr
    inner join 
        kronos.cached_gx_payment gp 
            on gx_payment_id = gp.id 
    inner join 
        gaia.gateway_transaction gt 
            on gp.gx_transaction_id = gt.transaction_id
    where gr.is_void = 'T'
    ) tr 
        on gt.transaction_id = tr.gx_transaction_id
    LEFT JOIN 
        gaia.invoice invoice 
            ON gt.invoice_id = invoice.id
    LEFT JOIN 
        gaia.plan gplan 
            ON invoice.plan_id = gplan.id
    inner join 
        kronos.plan kplan 
            on gplan.encrypted_ref_id = gx_plan_id
  where 
    settlement.settlement_status = 'Voided' 
    AND invoice_id IS NOT NULL 
    AND gt.is_voided = 'f' 
    and tr.gx_transaction_id is null
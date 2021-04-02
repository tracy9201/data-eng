with payment as(

select case when item.id IS NOT NULL then t.id ||'_item_'||item.id else t.id end as transaction_to_item_id
, t.id
, t.user_id
, t.payment_method
, t.transaction
, t.amount
, t.created_at
, t.updated_at
, t.customer_type
, gt.invoice_item_id
, ks.type as subscription_type
, ks.offering_id
, ks.ad_hoc_offering_id
, od.id as organization_id
, od.live
, od.name
from kronos.transactions t
left join gaia.payment pmt on pmt.encrypted_ref_id = t.id
left join gaia.gateway_transaction gt on gt.source_object_id = pmt.id and gt.source_object_name = 'payment' and gt.status = 20
left join gaia.invoice_item item on item.id = gt.invoice_item_id
left join gaia.subscription gs on gs.id = item.subscription_id
left join kronos.subscription ks on ks.gx_subscription_id  = gs.encrypted_ref_id
left join kronos.users u on u.id = t.user_id
left join kronos.organization_data od on od.id = u.organization_id
where substring(t.id,1,3) = 'pym'
)
,credit as
(
select case when item.id IS NOT NULL then t.id ||'_item_'||item.id else t.id end as transaction_to_item_id
,t.id
, t.user_id
, t.payment_method
, t.transaction
, t.amount
, t.created_at
, t.updated_at
, t.customer_type
, gt.invoice_item_id
, ks.type as subscription_type
, ks.offering_id
, ks.ad_hoc_offering_id
, od.id as organization_id
, od.live
, od.name
from kronos.transactions t
left join gaia.credit cr on cr.encrypted_ref_id = t.id
left join gaia.gateway_transaction gt on gt.source_object_id = cr.id and gt.source_object_name = 'credit' and gt.status = 20
left join gaia.invoice_item item on item.id = gt.invoice_item_id
left join gaia.subscription gs on gs.id = item.subscription_id
left join kronos.subscription ks on ks.gx_subscription_id  = gs.encrypted_ref_id
left join kronos.users u on u.id = t.user_id
left join kronos.organization_data od on od.id = u.organization_id
where substring(t.id,1,3) = 'cre'
)
, invoice as
(
select case when item.id IS NOT NULL then t.id ||'_item_'||item.id else t.id end as transaction_to_item_id
, t.id
, t.user_id
, t.payment_method
, t.transaction
, t.amount
, t.created_at
, t.updated_at
, t.customer_type
, item.id as invoice_item_id
, ks.type as subscription_type
, ks.offering_id
, ks.ad_hoc_offering_id
, od.id as organization_id
, od.live
, od.name
from kronos.transactions t
left join gaia.invoice inv on inv.encrypted_ref_id = t.id
left join gaia.invoice_item item on item.invoice_id = inv.id
left join gaia.subscription gs on gs.id = item.subscription_id
left join kronos.subscription ks on ks.gx_subscription_id = gs.encrypted_ref_id
left join kronos.users u on u.id = t.user_id
left join kronos.organization_data od on od.id = u.organization_id
where substring(t.id,1,3) = 'inv'
)
,
refund as
(
select case when item.id IS NOT NULL then t.id ||'_item_'||item.id else t.id end as transaction_to_item_id
, t.id
, t.user_id
, t.payment_method
, t.transaction
, t.amount
, t.created_at
, t.updated_at
, t.customer_type
, ref.invoice_item_id
, ks.type as subscription_type
, ks.offering_id
, ks.ad_hoc_offering_id
, od.id as organization_id
, od.live
, od.name
from kronos.transactions t
left join gaia.refund ref on ref.encrypted_ref_id = t.id
left join gaia.invoice_item item on item.id = ref.invoice_item_id
left join gaia.subscription gs on gs.id = ref.subscription_id
left join kronos.subscription ks on ks.gx_subscription_id = gs.encrypted_ref_id
left join kronos.users u on u.id = t.user_id
left join kronos.organization_data od on od.id = u.organization_id
where substring(t.id,1,3) = 'ref'
)
, main as
(
select * from payment
UNION ALL
select * from credit
UNION ALL
select * from invoice
UNION ALL
select * from refund
)

select * from main 
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16


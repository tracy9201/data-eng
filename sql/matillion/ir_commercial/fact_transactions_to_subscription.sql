with pmt as(
select t.id, t.user_id, t.payment_method, t.transaction , t.amount, pmt.amount as pmt_amount, t.created_at
, t.updated_at
,pmt.created_at as pmt_created_as
,pmt.updated_at as pmt_updated_as
,t.customer_type, pmt.id as pmt_id
,  gt.invoice_item_id
, ks.type as subscription_type
, ks.offering_id
, ks.ad_hoc_offering_id
, od.id as od_id
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
select t.id, t.user_id, t.payment_method, t.transaction , t.amount, cr.amount as cre_amount, t.created_at
, t.updated_at
, cr.created_at as cr_created_as
, cr.updated_at as cr_updated_as
, t.customer_type, cr.id as cr_id
,  gt.invoice_item_id
, ks.type as subscription_type
, ks.offering_id
, ks.ad_hoc_offering_id
, od.id as od_id
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
select
t.id, t.user_id, t.payment_method, t.transaction , t.amount, inv.amount as inv_amount, t.created_at
, t.updated_at
, inv.created_at as inv_created_as
, inv.updated_at as inv_updated_as
, t.customer_type, inv.id as inv_id
, item.id as invoice_item_id
, ks.type as subscription_type
, ks.offering_id
, ks.ad_hoc_offering_id
, od.id as od_id
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
select t.id, t.user_id, t.payment_method, t.transaction , t.amount, ref.amount as ref_amount, t.created_at
, t.updated_at
, ref.created_at as ref_created_as
, ref.updated_at as ref_updated_as
, t.customer_type
, ref.id as ref_id
, ref.invoice_item_id
, ks.type as subscription_type
, ks.offering_id
, ks.ad_hoc_offering_id
, od.id as od_id
, od.live
, od.name
from kronos.transactions t
left join gaia.refund ref on ref.encrypted_ref_id = t.id
left join gaia.subscription gs on gs.id = ref.subscription_id
left join kronos.subscription ks on ks.gx_subscription_id = gs.encrypted_ref_id
left join kronos.users u on u.id = t.user_id
left join kronos.organization_data od on od.id = u.organization_id
where substring(t.id,1,3) = 'ref'
)
, combined as
(
select id
, user_id
, payment_method
, transaction
, amount
, created_at
, updated_at
, customer_type
, invoice_item_id
, subscription_type
, offering_id
, ad_hoc_offering_id
, od_id as organization_id
, live
, name
from pmt
UNION ALL
select id
, user_id
, payment_method
, transaction
, amount
, created_at
, updated_at
, customer_type
, invoice_item_id
, subscription_type
, offering_id
, ad_hoc_offering_id
, od_id as organization_id
, live
, name
from credit
UNION ALL
select id
, user_id
, payment_method
, transaction
, amount
, created_at
, updated_at
, customer_type
, invoice_item_id
, subscription_type
, offering_id
, ad_hoc_offering_id
, od_id as organization_id
, live
, name
from invoice
UNION ALL
select id, user_id, payment_method, transaction , amount, created_at
, updated_at
, customer_type
, invoice_item_id
, subscription_type
, offering_id
, ad_hoc_offering_id
, od_id as organization_id
, live
, name
from refund
)
select * from combined c
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

with subscription as (
select
od.id as organization_id
, od.name as practice_name
, ks.type as sub_type
, cd.type as cus_type
, count(gs.id)
 from gaia.subscription gs
 left join gaia.plan gpl on gpl.id = gs.plan_id
 left join gaia.customer gc on gc.id = gpl.customer_id
left join kronos.subscription ks on ks.gx_subscription_id = gs.encrypted_ref_id
left join kronos.customer_data cd on gc.encrypted_ref_id = cd.gx_customer_id
left join kronos.users u on u.id = cd.user_id
left join kronos.organization_data od on od.id = u.organization_id
where od.live = true
group by 1,2,3,4
)
, sub_category as
( select s.organization_id
, s.practice_name
,case when s.sub_type in (1,2) then 'Subscription' else 'Non-Subscription' end as category
, sum(s.Count) as count_by_category
from subscription s
group by 1,2,3
)
,offer as
( select distinct organization_id
from ir_commercial.offering o
)
, catalog_organizations as
( select sub_category.* from sub_category
join offer on offer.organization_id = sub_category.organization_id
)

select * from catalog_organizations
order by 1

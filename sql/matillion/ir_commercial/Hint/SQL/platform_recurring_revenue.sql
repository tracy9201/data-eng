WITH rev as (
  select 
    gt.name as transaction_name, 
    round(gt.amount) as payment_amount, 
    gt.created_at as transaction_created_at, 
    gt.invoice_id, 
    invoice.plan_id as plan_id1, 
    gt.type, 
    provider.id as provide_id,
    least(gt.updated_at,invoice.updated_at,authorisation.updated_at,provider.updated_at) as updated_at 
  from 
    internal_gaia_hint.gateway_transaction gt 
    inner join internal_gaia_hint.invoice on invoice.id = gt.invoice_id 
    inner join internal_gaia_hint.authorisation on gt.destination_object_id = authorisation.id 
    inner join internal_gaia_hint.provider on authorisation.object_id = provider.id 
  where 
    gt.destination_object_name = 'authorisation' 
    and gt.destination_object_id = 2 
    and authorisation.object_id = 1 
    and authorisation.object = 'provider' 
    and gt.status = 20
), 
revenue as (
  SELECT 
    rev.transaction_name, 
    rev.payment_amount, 
    rev.type, 
    rev.transaction_created_at as created_at, 
    rev.invoice_id, 
    rev.plan_id1 as plan_id, 
    plan.customer_id as customer_id, 
    rev.provide_id, 
    customer.name as name,
    least(rev.updated_at,plan.updated_at,customer.updated_at) as updated_at 
  from 
    rev 
    inner join internal_gaia_hint.plan on rev.plan_id1 = plan.id 
    inner join internal_gaia_hint.customer on plan.customer_id = customer.id
), 
sub_revenue as (
  select 
    revenue.transaction_name, 
    revenue.customer_id, 
    to_char(
      revenue.created_at, 'MM/DD/YYYY'
    ) as transaction_dates, 
    case when revenue.transaction_name like '%Membershi%' then payment_amount / 595 else 0 end as number_of_members, 
    case when revenue.transaction_name like '%Membershi%' then round(
      cast (payment_amount as numeric)/ cast(100 as numeric), 
      2
    ) else 0 end as membership, 
    case when revenue.transaction_name like '%Platform%' then round(
      cast (payment_amount as numeric)/ cast(100 as numeric), 
      2
    ) else 0 end as platform, 
    name as practice_name, 
    case when revenue.transaction_name like '%Organization%' then round(
      cast (payment_amount as numeric)/ cast(100 as numeric), 
      2
    ) else 0 end as organization_product,
    updated_at 
  from 
    revenue 
  where 
    revenue.name not like '%zztest%'
), 
main as (
  select 
    ROW_NUMBER() OVER () AS id, 
    case when sub_revenue.practice_name = 'Ness Plastic Surgery' then 'Omni Cosmetic' when sub_revenue.practice_name like 'Beaty Facial%' then 'Beaty Facial Plastic Surgery' when sub_revenue.practice_name like 'Modern Dermatology%' then 'Modern Dermatology of Connecticut' when sub_revenue.practice_name = 'Premier Plastic Surgery Arts' then 'William Franckle MD FACS' when sub_revenue.practice_name = 'Serenity MedSpa' then 'Serenity MedSpa (Burlingame)' when sub_revenue.practice_name = 'Maffi Clinic' then 'Maffi Clinics' when sub_revenue.practice_name = 'Saltz Plastic Surgery' then 'Saltz Plastic Surgery & Saltz Spa Vitória' when sub_revenue.practice_name = 'OrangeTwist (Forth Worth)' then 'OrangeTwist (Fort Worth)' when sub_revenue.practice_name = 'HintMD Internal Beauty (New)' then 'HintMD Internal Beauty' when sub_revenue.practice_name = 'Platinum Care LA' then 'Self Care LA' when sub_revenue.practice_name like 'Dr. Haena Kim%' then 'Dr. Haena Kim Facial Plastic & Reconstructive Surgery' else sub_revenue.practice_name end as practice_name, 
    to_date(
      sub_revenue.transaction_dates, 'MM/DD/YYYY'
    ) as transaction_date, 
    sum(sub_revenue.membership) as membership_fee, 
    sum(sub_revenue.platform) as platform_fee, 
    sum(
      sub_revenue.organization_product
    ) as organization_product_fee, 
    sum(
      sub_revenue.membership + sub_revenue.platform + sub_revenue.organization_product
    ) as total,
    updated_at 
  from 
    sub_revenue 
  where 
    (
      sub_revenue.transaction_dates != '09/23/2018' 
      or sub_revenue.practice_name != 'Shahin Fazilat, M.D.'
    ) 
  group by 
    sub_revenue.practice_name, 
    sub_revenue.transaction_dates, 
    sub_revenue.customer_id,
    sub_revenue.updated_at
) 
SELECT 
  *,current_timestamp::timestamp as dwh_created_at 
FROM 
  main

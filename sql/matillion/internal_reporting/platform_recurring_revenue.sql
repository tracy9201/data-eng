 select 
    case when practice_name = 'Ness Plastic Surgery' then 'Omni Cosmetic'
        when practice_name like 'Beaty Facial%' then 'Beaty Facial Plastic Surgery'
        when practice_name like 'Modern Dermatology%' then 'Modern Dermatology of Connecticut'
        when practice_name = 'Premier Plastic Surgery Arts' then 'William Franckle MD FACS'
        when practice_name = 'Serenity MedSpa' then 'Serenity MedSpa (Burlingame)'
        when practice_name = 'Maffi Clinic' then 'Maffi Clinics'
        when practice_name = 'Saltz Plastic Surgery' then 'Saltz Plastic Surgery & Saltz Spa Vitória'
        when practice_name = 'OrangeTwist (Forth Worth)' then 'OrangeTwist (Fort Worth)'
        when practice_name = 'HintMD Internal Beauty (New)' then 'HintMD Internal Beauty'
        when practice_name = 'Platinum Care LA' then 'Self Care LA'
        when practice_name like 'Dr. Haena Kim%' then 'Dr. Haena Kim Facial Plastic & Reconstructive Surgery'
        else practice_name
    end as practice_name,
    to_date(transaction_dates,'MM/DD/YYYY') as transaction_date,
    sum(membership) as membership_fee, sum(platform) as platform_fee,
    sum(membership + platform + organization_product) as total
from (
    select 
        transaction_name, 
        customer_id, 
        to_char(created_at,'MM/DD/YYYY') as transaction_dates, 
        case when transaction_name like '%Membershi%' then payment_amount/595 else 0 end as number_of_members, 
        case when transaction_name like '%Membershi%' then round( cast ( payment_amount as numeric )/ cast( 100 as numeric),2) else 0 end as membership, 
        case when transaction_name like '%Platform%' then round( cast ( payment_amount as numeric )/ cast( 100 as numeric),2) else 0 end as platform, 
        name as practice_name, 
        case when transaction_name like '%Organization%' then round( cast ( payment_amount as numeric )/ cast( 100 as numeric),2) else 0 end as organization_product
    from
      (
       SELECT
        transaction_name, payment_amount, type, transaction_created_at as created_at, invoice_id, plan_id1 as plan_id, plan.customer_id as customer_id, provide_id, customer.name as name
        from (
        select gateway_transaction.name as transaction_name, round(gateway_transaction.amount) as payment_amount, gateway_transaction.created_at as transaction_created_at, gateway_transaction.invoice_id, invoice.plan_id as plan_id1, gateway_transaction.type, provider.id as provide_id
        from gaia.gateway_transaction
        inner join gaia.invoice on invoice.id = gateway_transaction.invoice_id
        inner join gaia.authorisation on gateway_transaction.destination_object_id = authorisation.id
        inner join gaia.provider on authorisation.object_id = provider.id
        where gateway_transaction.destination_object_name = 'authorisation' and gateway_transaction.destination_object_id = 2 and authorisation.object_id = 1 and authorisation.object = 'provider'
        ) table1
        inner join gaia.plan on table1.plan_id1 = plan.id
        inner join gaia.customer on plan.customer_id = customer.id
      ) platform_revenue
    where name not like '%zztest%'
) tbale1
where 
    (transaction_dates != '09/23/2018' or practice_name != 'Shahin Fazilat, M.D.')
group by 
    practice_name, 
    transaction_dates, 
    customer_id
   --------------------------------------Member Status - Fact ---------------------------------------------

    SELECT 
    user_id, 
    MIN(created_date) AS created_date, 
    CASE 
        WHEN ISmember3 = 0 THEN MAX(deprecated_date)
        WHEN ISmember3> 0 THEN NULL
    END AS updated_date,
    CASE WHEN ISmember3>0 THEN 'active' ELSE 'inactive' END AS status,
    gx_customer_id,
    gx_provider_id
FROM (
  SELECT 
    user_id, 
    created_date, 
    deprecated_date, 
    ISmember, 
    ismember2, 
    sum(ismember2) OVER (PARTITION by USER_id) AS ISmember3,
    gx_customer_id,
    gx_provider_id
  FROM (
        SELECT 
            DISTINCT customer.user_id, 
            sub_id,
            customer.status, 
            subscription.created_date, 
            subscription.deprecated_date, 
            isMember, 
            CASE 
              WHEN deprecated_date IS NULL AND ismember = 1 THEN 1
              WHEN ismember = 0 THEN 0
              WHEN ismember =1 AND deprecated_date IS NOT NULL THEN 0
              END AS isMember2,
            gx_customer_id
        FROM customer_data customer
        JOIN 
             v4_k_plan plan 
                ON customer.user_id=plan.user_id
        JOIN (
        -- Subscription starting date and deprecated date
        -- We don't need TO have subscription id, if there ARE several subscription WITH the same created AND deprecated date, we just care that AT that TIME we had a subscription
            SELECT 
                DISTINCT plan_id, 
                cast(to_char(created_at,'yyyy-mm-dd') AS date) AS created_date,
                id AS sub_id,
                CASE 
                    WHEN (type=2) THEN 
                    -- When a user have an installment, if deprecated_at is not null then deprecated_date=deprecated_at, else deprecated_at=created_at+period+1 (software rule)
                    (CASE WHEN (deprecated_at IS NOT null) THEN (cast(to_char(deprecated_at,'yyyy-mm-dd') AS date)) 
                    ELSE (cast(to_char(cast(to_char(created_at,'yyyy-mm-dd') AS date) + INTERVAL '1 month' * (period+1),'yyyy-mm-dd') AS date)) end) 
                    -- When we have a pay in full or subscription then deprecated_date=deprecated_at, respecting if it's null or not
                    ELSE (cast(to_char(deprecated_at,'yyyy-mm-dd') AS date)) END AS deprecated_date,
                    -- Member or not
                    CASE WHEN (type=2 OR type=1) THEN 1 ELSE 0 END AS isMember
            FROM v4_k_subscription subscription
        ) subscription ON plan.id=subscription.plan_id
WHERE  ISmember =1
ORDER BY USER_id 
  ) final
  JOIN 
      users 
        ON users.id = final.user_id
  JOIN 
      organization_data 
        ON users.organization_id = organization_data.id
  WHERE 
      organization_data.name not like 'zz%' 
      or organization_data.name not like 'zzz%' 
      or organization_data.name not like 'Hint%' 
) finalstatus 
GROUP BY 
  user_id, 
  ismember3,
  gx_customer_id,
  gx_provider_id

  --------------------------------------Practice Recurring Revenue - Fact---------------------------------------------

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
    from v4_g_plantform_revenue
    where name not like '%zztest%'
) tbale1
where 
    (transaction_dates != '09/23/2018' or practice_name != 'Shahin Fazilat, M.D.')
group by 
    practice_name, 
    transaction_dates, 
    customer_id


      --------------------------------------Patient - DIM---------------------------------------------

select
    gx_customer_id,
    case when customer_data.type = 1 then 'guest_checkout' else 'customer' end as patient_type,
    case 
        when gender = 0 then 'unknown'
        when gender = 1 then 'male'
        when gender = 2 then 'female'
        end as gender,
    organization_id,
    left (firstname, 2) ||'****' as firstname,
    user_id,
    to_char(birth_date_utc, 'yyyy') as birth_year,
    city,
    state,
    created_at,
    deprecated_at
from customer_data 
inner join 
    users 
        on users.id = user_id
inner join 
    v4_k_address add
        on billing_address_id = add.id

       --------------------------------------Staff - DIM---------------------------------------------

SELECT users.id AS user_id,
  CASE 
    WHEN users.status = 0 THEN 'active' 
    WHEN users.status = 1 THEN 'achived'
    WHEN users.status = 2 THEN 'pending' 
    END AS status,
  users.title,
  users.firstname,
  users.lastname,
  CASE 
    WHEN role = 1 THEN 'system_admin' 
    WHEN role = 2 THEN 'curator' 
    WHEN role = 4 THEN 'expert' 
    WHEN role = 5 THEN 'expert' 
    WHEN role = 6 THEN 'staff' 
    WHEN role = 10 THEN 'admin' 
    END AS role,
  users.email,
  users.organization_id,
  users.created_at,
  users.deprecated_at, 
  users.zendesk_user_id, 
  principal AS pricinple_epxert,
  CASE 
    WHEN expert_data.commission IS NOT NULL THEN expert_data.commission
    WHEN staff_data.commission IS NOT NULL THEN staff_data.commission 
    ELSE NULL 
    END AS commssion
FROM users 
LEFT JOIN expert_data ON users.id = expert_data.user_id 
LEFT JOIN staff_data ON users.id = staff_data.user_id 
WHERE role IN (1,2,4,5,6,10)


--------------------------------------Practice - DIM---------------------------------------------

SELECT 
    org.id AS practice_id,
    org.created_at,
    org.deprecated_at,
    org.status, 
    gx_provider_id,
    org.per_member_rate,
    org.rate AS practice_rate,
    org.timezone, 
    org.activated_at,
    org.name AS practice_name,
    org.live,
    organization_tax_percentage,
    city,
    state,
    zip,
    provider.name AS business_name
FROM organization_data org 
LEFT JOIN 
    v4_k_address address 
        ON address.id = address_id
LEFT JOIN 
    v4_g_provider provider 
        ON encrypted_ref_id = gx_provider_id


        --------------------------------------Offering - DIM---------------------------------------------

        
select  
    v4_k_offering.id as offering_id, 
    v4_k_offering.name as offering_name, 
    v4_k_catalog_item.name as catalog_name, 
    catalog_item_id as catalog_id, 
    v4_k_brand.name as factory_name, 
    brand_id as factory_id, 
    pay_in_full_price as offering_pay_in_full_price, 
    subscription_price as offering_subscription_price, 
    pay_over_time_price as offering_pay_over_time_price, 
    service_tax as offering_service_tax, 
    v4_k_offering.status as offering_status, 
    v4_k_offering.organization_id, 
    v4_k_offering.created_at as offering_created_at, 
    v4_k_catalog_item.created_at as catalog_created_at, 
    v4_k_catalog_item.status as catalog_status, 
    v4_k_catalog_item.wholesale_price as catalog_wholesale_price, 
    bd_status, 
    v4_k_brand.created_at as brand_created_at
from  v4_k_offering 
left join 
    v4_k_catalog_item 
        on catalog_item_id = v4_k_catalog_item.id
left join  
    v4_k_brand 
        on brand_id = v4_k_brand.id

  --------------------------------------Fulfillment-Fact ---------------------------------------------
select 
    ful.id, 
    ful.created_at, 
    ful.deprecated_at, 
    ful.cancelled_at, 
    ful.status, 
    ful.quantity_rendered, 
    ful.next_service_date, 
    ful.service_date, 
    ful.value, 
    ful.tax_value, 
    shipping_cost, 
    ful.type, 
    ful.name, 
    offering_id
from cached_gx_fulfillment ful
left join 
    v4_k_subscription sub 
        on ful.gx_subscription_id = sub.gx_subscription_id


  --------------------------------------Payment_Summary-Fact ---------------------------------------------

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
from transactions

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
    0 as gratuity_amount,
    null as customer_type,
    null as payment_detail
from v4_g_settlement settlement
inner join 
    v4_g_gateway_transaction gt 
        on gateway_transaction_id = gt.id 
left outer join (
    select 
        distinct gp.gx_transaction_id 
    from cached_gx_refund gr
    inner join 
        cached_gx_payment gp 
            on gx_payment_id = gp.id 
    inner join 
        v4_g_gateway_transaction gt 
            on gp.gx_transaction_id = gt.transaction_id
    where gr.is_void = 'T'
) tr 
    on gt.transaction_id = tr.gx_transaction_id
inner JOIN 
    v4_g_payment payment 
        ON  payment_id = payment.id
inner JOIN 
    v4_g_plan gplan 
        ON payment.plan_id = gplan.id
inner join 
    v4_k_plan kplan 
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
    0 as gratuity_amount,
    null as customer_type,
    null as payment_detail
from v4_g_settlement settlement
inner join 
    v4_g_gateway_transaction gt 
        on gateway_transaction_id = gt.id 
left outer join (
    select 
        distinct gp.gx_transaction_id 
    from cached_gx_refund gr
    inner join 
        cached_gx_payment gp 
            on gx_payment_id = gp.id 
    inner join 
        v4_g_gateway_transaction gt 
            on gp.gx_transaction_id = gt.transaction_id
    where gr.is_void = 'T'
    ) tr 
        on gt.transaction_id = tr.gx_transaction_id
    LEFT JOIN 
        v4_g_invoice invoice 
            ON gt.invoice_id = invoice.id
    LEFT JOIN 
        v4_g_plan gplan 
            ON invoice.plan_id = gplan.id
    inner join 
        v4_k_plan kplan 
            on gplan.encrypted_ref_id = gx_plan_id
  where 
    settlement.settlement_status = 'Voided' 
    AND invoice_id IS NOT NULL 
    AND gt.is_voided = 'f' 
    and tr.gx_transaction_id is null
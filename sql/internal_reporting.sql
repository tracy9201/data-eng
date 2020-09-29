----- payment_summary ---------------------

select * from(
  SELECT 'credit_'||cast(credit.id AS text) AS sales_id,
    credit.name AS sales_name,
    credit.amount AS sales_amount,
    credit.type AS sales_type,
    credit.status AS sales_status,
    credit.created_at AS sales_created_at,
    gx_customer_id, gx_provider_id,
    credit.created_by AS staff_user_id,
    NULL AS device_id, NULL AS gratuity_amount,
    credit.balance as balance,
    null as reason
  FROM v4_g_credit credit
    LEFT JOIN v4_g_plan plan ON credit.plan_id = plan.id
    LEFT JOIN v4_k_plan k_plan on plan.encrypted_ref_id = k_plan.gx_plan_id
    LEFT JOIN v4_k_customer_data  customer on k_plan.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
  WHERE credit.id IS NOT NULL
    AND credit.status =1
    AND gx_plan_id is not null

  UNION

  SELECT 'payment_'||cast(payment.id AS text) AS sales_id,
    payment.name AS sales_name,
    payment.amount AS sales_amount,
    payment.type AS sales_type,
    payment.status AS sales_status,
    payment.created_at AS sales_created_at,
    gx_customer_id,
    gx_provider_id,
    payment.created_by AS staff_user_id,
    payment.device_id AS device_id,
    gratuity.amount AS gratuity_amount,
    payment.balance as balance,
    payment.reason
  FROM v4_g_payment payment
    LEFT JOIN gratuity ON gratuity.id = payment.gratuity_id
    LEFT JOIN v4_g_plan plan ON payment.plan_id = plan.id
    LEFT JOIN v4_k_plan k_plan on plan.encrypted_ref_id = k_plan.gx_plan_id
    LEFT JOIN v4_k_customer_data customer on k_plan.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
    LEFT JOIN v4_g_gateway_transaction gateway_transaction ON gateway_transaction.payment_id = payment.id
  WHERE payment.id IS NOT NULL
    AND payment.status = 1

  UNION

  SELECT 'refund1_'||cast(refund.id AS text) AS sales_id,
    refund.name AS sales_name,
    refund.amount AS sales_amount,
    refund.type AS sales_type,
    refund.status AS sales_status,
    refund.created_at AS sales_created_at,
    gx_customer_id,
    gx_provider_id,
    refund.created_by AS staff_user_id,
    NULL AS device_id,
    gratuity.amount AS gratuity_amount,
    refund.balance as balance,
    gateway_transaction.reason
  FROM v4_g_refund refund
    LEFT JOIN gratuity ON gratuity.id = refund.gratuity_id
    LEFT JOIN v4_g_subscription subscription ON subscription_id = subscription.id
    LEFT JOIN v4_g_plan plan ON subscription.plan_id = plan.id
    LEFT JOIN v4_g_gateway_transaction gateway_transaction on refund.gateway_transaction_id = gateway_transaction.id
    LEFT JOIN v4_k_plan k_plan on plan.encrypted_ref_id = k_plan.gx_plan_id
    LEFT JOIN v4_k_customer_data customer on k_plan.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
  WHERE subscription_id IS NOT NULL
    AND refund.status =20
    AND refund.is_void = 'f'

  UNION

  SELECT 'tran_'||cast(gateway_transaction.id AS text) AS sales_id,
    gateway_transaction.name AS sales_name,
    gateway_transaction.amount AS sales_amount,
    gateway_transaction.type AS sales_type,
    gateway_transaction.status AS sales_status,
    gateway_transaction.created_at AS sales_created_at,
    gx_customer_id,
    gx_provider_id,
    NULL AS staff_user_id,
    NULL AS device_id,
    gateway_transaction.gratuity_amount,
    NULL as balance,
    gateway_transaction.reason
  FROM v4_g_gateway_transaction gateway_transaction
    LEFT JOIN v4_g_invoice invoice ON invoice_id = invoice.id
    LEFT JOIN v4_g_invoice_item invoice_item ON invoice_item_id = invoice_item.id
    LEFT JOIN v4_g_subscription subscription ON subscription.id = invoice_item.subscription_id
    LEFT JOIN v4_g_plan plan ON subscription.plan_id = plan.id
    LEFT JOIN v4_k_plan k_plan on plan.encrypted_ref_id = k_plan.gx_plan_id
    LEFT JOIN v4_k_customer_data customer on k_plan.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
  WHERE source_object_name  = 'card_payment_gateway'
    AND gateway_transaction.status = 20
    AND gateway_transaction.payment_id IS NULL
    AND gateway_transaction.is_voided = 'f'


  UNION

  SELECT 'refund3_'||cast(refund.id AS text) AS sales_id,
    refund.name AS sales_name,
    refund.amount AS sales_amount,
    refund.type AS sales_type,
    refund.status AS sales_status,
    refund.created_at AS sales_created_at,
    gx_customer_id,
    gx_provider_id,
    refund.created_by AS staff_user_id,
    NULL AS device_id,
    gratuity.amount AS gratuity_amount,
    refund.balance as balance,
    gateway_transaction.reason
  FROM v4_g_refund refund
    LEFT JOIN gratuity ON gratuity.id = refund.gratuity_id
    LEFT JOIN v4_g_subscription ON subscription_id = v4_g_subscription.id
    LEFT JOIN v4_g_gateway_transaction gateway_transaction ON gateway_transaction_id = gateway_transaction.id
    LEFT JOIN v4_g_payment payment ON gateway_transaction.payment_id = payment.id
    LEFT JOIN v4_g_plan plan ON payment.plan_id = plan.id
    LEFT JOIN v4_k_plan k_plan on plan.encrypted_ref_id = k_plan.gx_plan_id
    LEFT JOIN v4_k_customer_data customer on k_plan.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
  WHERE refund.subscription_id IS NULL
    AND gateway_transaction.invoice_item_id IS NULL
    AND source_object_name = 'refund'
    AND refund.status =20
    AND refund.is_void = 'f'

  UNION

  SELECT 'settle_'||cast(settlement.id AS text) AS sales_id,
    card_brand AS sales_name,
    amount*100 AS sales_amount,
    settlement.type AS sales_type,
    CASE
      WHEN settlement_status like 'Accepted' then 1
      WHEN settlement_status like 'Amount' then 2
      WHEN settlement_status like 'Processed' then 3
      WHEN settlement_status like 'Queued' then 4
      WHEN settlement_status like 'Rejected' then 5
      WHEN settlement_status like 'Voided' then 6
      ELSE 7
      END AS sales_status,
    settlement_date AS sales_created_at,
    null AS gx_customer_id,
    provider.encrypted_ref_id AS gx_provider_id,
    NULL AS staff_user_id,
    NULL AS device_id,
    NULL AS gratuity_amount,
    NULL as balance,
    NULL as reason
  FROM v4_g_authorisation authorisation
    RIGHT JOIN v4_g_settlement settlement ON authorisation.id = settlement.authorisation_id
    LEFT JOIN v4_g_provider provider ON object_id = provider.id
  WHERE gateway_transaction_id IS NULL
    AND authorisation.object ='provider'

  UNION

  SELECT 'void1_'||cast(settlement.id AS text) AS sales_id,
    gateway_transaction.name AS sales_name,
    settlement.tendered*100 AS sales_amount,
    gateway_transaction.type AS sales_type,
    settlement.status AS sales_status,
    settlement.authd_date AS sales_created_at,
    customer.gx_customer_id,
    provider.gx_provider_id,
    NULL AS staff_user_id,
    NULL AS device_id,
    gateway_transaction.gratuity_amount AS gratuity_amount,
    NULL as balance,
    gateway_transaction.reason
  FROM v4_g_settlement settlement
    LEFT JOIN v4_g_gateway_transaction gateway_transaction ON gateway_transaction.id = gateway_transaction_id
    LEFT JOIN v4_g_invoice invoice ON  gateway_transaction.invoice_id = invoice.id
    LEFT JOIN v4_g_plan plan ON invoice.plan_id = plan.id
    LEFT JOIN v4_k_plan plan2 on plan.encrypted_ref_id = plan2.gx_plan_id
    LEFT JOIN v4_k_customer_data customer on plan2.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
  WHERE settlement.settlement_status = 'Voided'

  UNION

  SELECT 'void2_'||cast(settlement.id AS text) AS sales_id,
    gateway_transaction.name AS sales_name,
    settlement.tendered*100 AS sales_amount,
    gateway_transaction.type AS sales_type,
    settlement.status AS sales_status,
    settlement.authd_date AS sales_created_at,
    customer.gx_customer_id,
    provider.gx_provider_id,
    NULL AS staff_user_id,
    NULL AS device_id,
    gateway_transaction.gratuity_amount AS gratuity_amount,
    NULL as balance,
    gateway_transaction.reason
  FROM v4_g_settlement settlement
    LEFT JOIN v4_g_gateway_transaction gateway_transaction ON gateway_transaction.id = gateway_transaction_id
    LEFT JOIN v4_g_payment payment ON  payment.id = gateway_transaction.payment_id
    LEFT JOIN v4_g_plan plan ON payment.plan_id = plan.id
    LEFT JOIN v4_k_plan plan2 on plan.encrypted_ref_id = plan2.gx_plan_id
    LEFT JOIN v4_k_customer_data customer on plan2.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
  WHERE settlement.settlement_status = 'Voided'
    AND gateway_transaction.invoice_id IS NULL

  UNION

  SELECT 'void3_'||cast(refund.id AS text) AS sales_id,
    refund.name AS sales_name,
    refund.amount AS sales_amount,
    refund.type AS sales_type,
    refund.status AS sales_status,
    refund.created_at AS sales_created_at,
    customer.gx_customer_id,
    provider.gx_provider_id,
    refund.created_by AS staff_user_id,
    NULL AS device_id,
    gratuity.amount AS gratuity_amount,
    refund.balance as balance,
    gateway_transaction.reason
  FROM v4_g_refund refund
    LEFT JOIN gratuity ON gratuity.id = refund.gratuity_id
    LEFT JOIN v4_g_subscription subscription ON subscription_id = subscription.id
    LEFT JOIN v4_g_plan plan ON subscription.plan_id = plan.id
    LEFT JOIN v4_g_gateway_transaction gateway_transaction on refund.gateway_transaction_id = gateway_transaction.id
    LEFT JOIN v4_k_plan k_plan on plan.encrypted_ref_id = k_plan.gx_plan_id
    LEFT JOIN v4_k_customer_data customer on k_plan.user_id = customer.user_id
    LEFT JOIN  v4_k_organization_data provider ON customer.organization_id = provider.id
  WHERE refund.status =20
    AND refund.is_void = 't'
) as a
 group by 1,2,3,4,5,6,7,8,9,10,11,12,13

----- v4_ach_revenue ---------------------

select transaction_name,
  payment_amount,
  type,
  created_at,
  invoice_id,
  plan_id,
  customer_id,
  name as practice_name
from v4_g_plantform_revenue

----- v4_charge_back ---------------------

SELECT id,
  name,
  payment_gateway_id,
  authorisation_id,
  funding_charge_back_id,
  deposit_date,
  amount,
  transaction_date,
  reason_description,
  reason_code,
  date_changed,
  source_transaction_id,
  transaction_amount,
  charge_back_date,
  sequence_number,
  date_added,
  auth_code,
  funding_master_id,
  case_number,
  acquire_reference_number,
  card_number,
  transaction_id,
  invoice_number,
  status,
  created_at,
  updated_at,
  canceled_at,
  deleted_at,
  encrypted_ref_id
FROM public.v4_g_charge_back;

----- v4_download_report ---------------------

SELECT public.report_generation_jobs.id,
  public.report_generation_jobs.created_at,
  organization_id,
  public.report_generation_jobs.status,
  public.report_generation_jobs.name as report_name,
  organization_data.name as practice
FROM public.report_generation_jobs join organization_data on organization_data.id = organization_id

----- v4_fulfillment ---------------------

select id,
  created_at,
  updated_at,
  deprecated_at,
  cancelled_at,
  status,
  gx_subscription_id,
  quantity_balance,
  quantity_rendered,
  next_service_date,
  service_date,
  value,
  tax_value,
  gx_shipping_address_id,
  shipping,
  shipping_cost,
  tracking_id,
  tracking_url,
  type,
  name
from cached_gx_fulfillment

----- v4_growth_detail ---------------------

select count (practice_name) over (order by growth_date, practice_name) as id,
  *
from
(
  select case when provider_name1 is null then provider_name2 else provider_name1 end as practice_name,
    case when on_boarding_date is null then cancel_date else on_boarding_date end as growth_date,
    case when daily_created is null then 0 else daily_created end as created,
    case when daily_canceled is null then 0 else daily_canceled end as cancelled,
    case when daily_created is null then 0 else daily_created end - case when daily_canceled is null then 0 else daily_canceled end as active
  from
  (
    select provider_name1,
      on_boarding_date,
      count(user_id) as daily_created
    from
    (
      select v4_k_organization_data.lastname as provider_name1,
        user_id,
        to_char(min(case
            when v4_k_subscription.type =1 then v4_k_subscription.created_at
            when v4_k_subscription.type=2 then v4_k_subscription.created_at else null
            end), 'yyyy-mm-dd') as on_boarding_date
      from v4_k_plan
        join v4_k_subscription on plan_id = v4_k_plan.id
        join v4_k_users on user_id = v4_k_users.id
        join v4_k_organization_data on v4_k_users.organization_id = v4_k_organization_data.id
      where
      v4_k_organization_data.id not in (1,2,3,4,5,7,8,9,10,11,12,70,84)
      and (v4_k_subscription.type =1 or v4_k_subscription.type = 2 )
      and v4_k_subscription.status=0
      group by v4_k_organization_data.lastname, user_id
    ) create_table
    where on_boarding_date is not null
    group by provider_name1, on_boarding_date
  ) create_table2
  full join
  (
    select
    provider_name2,
    cancel_date,
    count(user_id) as daily_canceled
    from
    (
      select
      provider_name2,
      user_id,
      to_char(max(deprecated_at), 'yyyy-mm-dd') as cancel_date
      from
      (
        select
        v4_k_organization_data.lastname as provider_name2,
        v4_k_subscription.id, user_id,
        v4_k_subscription.deprecated_at,
        sum(case when v4_k_subscription.deprecated_at is null then 1 else 0 end) over (partition by user_id) as index
        from v4_k_plan
          join v4_k_subscription on plan_id = v4_k_plan.id
          join v4_k_users on user_id = v4_k_users.id
          join v4_k_organization_data on v4_k_users.organization_id = v4_k_organization_data.id
        where
        v4_k_organization_data.id not in (1,2,3,4,5,7,8,9,10,11,12,70,84)
        and (v4_k_subscription.type = 1 or v4_k_subscription.type = 2 )
        and v4_k_subscription.status=0
      )tabe1
      where
      index=0
      and deprecated_at is not null
      group by provider_name2, user_id
    ) cancel_table
    where cancel_date is not null
    group by provider_name2, cancel_date
  ) cancel_table2
  on provider_name1 = provider_name2 and on_boarding_date = cancel_date
)table1
order by growth_date

----- v4_audit_event ---------------------

select id,
  user_id,
  created_at,
  data::json->0->'table' as active_table,
  data::json->0->'type' as active_type
from audit_event

----- v4_adjustment ---------------------

SELECT id,
  name,
  payment_gateway_id,
  authorisation_id,
  funding_adjustment_id,
  funding_master_id,
  category,
  type,
  amount,
  description,
  currency,
  date_changed,
  date_added,
  status,
  created_at,
  updated_at,
  canceled_at,
  deleted_at,
  encrypted_ref_id
FROM public.adjustment;

----- v4_authorisation ---------------------

SELECT id,
  name,
  object_id,
  object,
  site,
  type,
  status,
  created_at,
  updated_at,
  canceled_at,
  deleted_at
FROM public.v4_g_authorisation;

----- v4_bd_token ---------------------

SELECT id,
  user_id,
  created_at,
  updated_at,
  deprecated_at,
  status,
  token
FROM public.bd_token;

----- v4_customer_data ---------------------

select users.id as user_id,
  customer_data.id as customer_id,
  gx_customer_id,
  shipping_address_id,
  customer_data.status,
  customer_data.created_at,
  customer_data.updated_at,
  customer_data.deprecated_at,
  firstname,
  right(mobile, 4) as mobile,
  users.organization_id,
  gender,
  date_part('year', birth_date_utc) as birth_year,
  lastname,
  email
from customer_data
  join users on user_id = users.id

----- v4_offering_catalog_factory ---------------------

select v4_k_subscription.id as subscription_id,
  cached_gx_subscription.name as offering_name,
  v4_k_offering.id as offering_id,
  v4_k_catalog_item.name as catalog_name,
  catalog_item_id as catalog_id,
  v4_k_brand.name as factory_name,
  brand_id as factory_id,
  case when v4_k_brand.name = 'ZO Skin Health' or v4_k_brand.name = 'Alastin Skincare' then 'yes' else 'no' end as is_skin_care,
  pay_in_full_price as offering_pay_in_full_price,
  subscription_price as offering_subscription_price,
  pay_over_time_price as offering_pay_over_time_price,
  service_tax as offering_service_tax,
  v4_k_offering.status as offering_status,
  v4_k_offering.organization_id,
  v4_k_offering.created_at as offering_created_at,
  v4_k_catalog_item.created_at as catalog_created_at,
  v4_k_catalog_item.status as catalog_status,
  v4_k_catalog_item.wholesale_price as catalog_wholesale_price, bd_status,
  v4_k_brand.created_at as brand_created_at
from v4_k_subscription
  join cached_gx_subscription on v4_k_subscription.gx_subscription_id = cached_gx_subscription.id
  left join v4_k_offering on v4_k_subscription.offering_id = v4_k_offering.id
  left join v4_k_catalog_item on catalog_item_id = v4_k_catalog_item.id
  left join v4_k_brand on brand_id = v4_k_brand.id

----- v4_funding ---------------------

SELECT id,
  name,
  payment_gateway_id,
  authorisation_id,
  funding_master_id,
  funding_id,
  net_sales*100,
  third_party*100,
  adjustment*100,
  interchange_fee*100,
  service_charge*100,
  fee*100,
  reversal*100,
  other_adjustment*100,
  total_funding*100,
  funding_date,
  currency,
  dda_number,
  aba_number,
  date_changed,
  date_added,
  deposit_trancode,
  deposit_ach_tracenumber,
  status,
  created_at,
  updated_at,
  canceled_at,
  deleted_at,
  encrypted_ref_id
FROM public.v4_g_funding;

----- v4_gateway_transaction ---------------------

SELECT id,
  name,
  external_id,
  idempotency_key,
  transaction_id,
  payment_gateway_id,
  invoice_id,
  invoice_item_id,
  card_payment_gateway_id,
  source_object_name,
  source_object_id,
  payment_id,
  amount,
  tendered,
  type,
  reason,
  currency,
  status,
  created_at,
  updated_at,
  canceled_at,
  deleted_at,
  destination_object_name,
  destination_object_id,
  settlement_id,
  entry_mode,
  entry_capability,
  condition_code,
  category_code,
  encrypted_ref_id,
  is_voided,
  gratuity_amount,
  credit_id
FROM public.v4_g_gateway_transaction;

----- v4_invoice ---------------------

SELECT id,
  plan_id,
  quantity,
  amount,
  due_date,
  pay_date,
  application_fee,
  attempts,
  amount_paid,
  charge_id,
  total_credit,
  total_discount,
  total_coupon,
  total_payment,
  currency,
  total_tax,
  tax_percentage,
  subtotal,
  total,
  starting_balance,
  ending_balance,
  name,
  canceled_at,
  deleted_at,
  status,
  created_at,
  updated_at,
  encrypted_ref_id
FROM public.v4_g_invoice;

----- v4_provider ---------------------

SELECT id,
  account_id,
  name,
  status,
  created_at,
  updated_at,
  canceled_at,
  deleted_at,
  encrypted_ref_id
FROM public.v4_g_provider;

----- v4_settlement ---------------------

SELECT id,
  name,
  authorisation_id,
  gateway_transaction_id,
  external_id,
  transaction_id,
  payment_gateway_id,
  amount*100,
  tendered*100,
  type,
  reason,
  currency,
  account,
  batch_id,
  settlement_status,
  settlement_date,
  signature,
  token,
  entry_mode,
  authd_date,
  last_four,
  bin_type,
  card_brand,
  funding_txn_id,
  funding_id,
  interchange_unit_fee,
  interchange_percentage_fee,
  plan_code,
  downgrade_reason_codes,
  invoice_number,
  source_transaction_id,
  terminal_number,
  ach_return_code,
  parent_retref,
  status,
  created_at,
  updated_at,
  canceled_at,
  deleted_at,
  encrypted_ref_id
FROM public.v4_g_settlement

----- v4_subscription ---------------------

select v4_k_subscription.id as subscription_id,
  v4_k_subscription.plan_id,
  v4_k_subscription.created_at,
  v4_k_subscription.updated_at,
  v4_k_subscription.deprecated_at,
  renewal_count as multiple_treatments_times,
  v4_g_subscription.quantity as product_quantity,
  v4_g_subscription.unit_name as product_unit_name,
  case when v4_k_subscription.deprecated_at is null and v4_k_subscription.type in (1,2) then 'yes' else 'no' end as subscription_status,
  end_count as treatment_period,
  auto_renewal as is_subscription,
  case when v4_k_subscription.type =0  then 'One Time Treatment'
    when v4_k_subscription.type = 2 then 'Multiple Treatments'
    when v4_k_subscription.type =1 then 'Recurring Treatments'
    end as subscription_type,
  v4_k_subscription.deprecated_at as cancelled_at,
  remaining_payment,
  balance as payment_balance,
  discount_amts ,
  tax,
  total as total_payment,
  start_date as current_period_start_date,
  end_date as current_period_end_date,
  gx_subscription_id,
  v4_k_subscription.offering_id, v4_g_subscription.name as subscription_name
from v4_g_subscription
join v4_k_subscription
on gx_subscription_id = v4_g_subscription.encrypted_ref_id

----- v4_organization_data ---------------------

select organization_data.id,
  organization_data.created_at,
  organization_data.updated_at,
  organization_data.deprecated_at,
  organization_data.status,
  organization_data.gx_provider_id,
  organization_data.currency,
  organization_data.rate,
  organization_data.per_member_rate,
  organization_data.address_id,
  organization_data.signer_id,
  organization_data.merchant_id,
  organization_data.timezone,
  organization_data.gx_org_customer_id,
  organization_data.title,
  organization_data.firstname,
  organization_data.lastname,
  organization_data.role,
  organization_data.email,
  organization_data.mobile,
  organization_data.organization_id
  users.lastname as practice_name
from organization_data
  join users on users.organization_id = organization_data.id
where role = 7

----- v4_plan ---------------------

select plan_id,
  gx_plan_id,
  user_id,
  to_char(min(case when v4_k_subscription.type in (1,2) then v4_k_subscription.created_at else null end), 'yyyy-mm-dd')  as plan_first_date,
  v4_k_plan.created_at,
  v4_k_plan.updated_at,
  v4_k_plan.deprecated_at,
  sum(case when v4_k_subscription.type in (1,2) and v4_k_subscription.deprecated_at is null then 1 else 0 end) as plan_active,
  to_char(max(case when v4_k_subscription.type in (1,2) then v4_k_subscription.deprecated_at  else null end), 'YYYY-MM-DD') as plan_ended_date,
  sum(case when v4_k_subscription.type in (1,2) then 1 else 0 end) as member_recoganize,
  count(v4_k_subscription.id) as num_of_subscription,
  min(case when v4_k_subscription.type in (1,2) then v4_k_subscription.created_at else null end) as on_boarding_date
from v4_k_plan
  join v4_k_subscription on plan_id = v4_k_plan.id
group by plan_id, v4_k_plan.created_at, gx_plan_id, user_id, v4_k_plan.created_at, v4_k_plan.updated_at, v4_k_plan.deprecated_at

----- v4_team_members ---------------------

select id as user_id,
  created_at,
  updated_at,
  deprecated_at,
  status,
  title,
  firstname,
  lastname,
  role,
  email,
  mobile,
  organization_id
from users
where role = 4
  or role = 6

----- v4_users ---------------------

SELECT id,
  created_at,
  updated_at,
  deprecated_at,
  status,
  title,
  firstname,
  lastname,
  password,
  salt,
  last_login_attempt_at,
  last_login_at,
  role,
  email,
  mobile,
  organization_id,
  thumbnail,
  color,
  firebase_token,
  invite_sent_date,
  deactivated_date,
  activated_date,
  zendesk_user_id
FROM public.users;

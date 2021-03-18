WITH new_main as (
SELECT 
    org.id AS practice_id,
    org.created_at,
    org.deprecated_at,
    org.status, 
    gx_provider_id,
    round(cast ( org.per_member_rate as numeric )/100,2) as per_member_rate,
    round(cast ( org.rate as numeric )/100,2) AS practice_rate,
    org.timezone, 
    org.activated_at,
    org.name AS practice_name,
    org.live,
    FALSE as payfac,
    round(cast ( org.organization_tax_percentage as numeric )/100,2) as organization_tax_percentage,
    address.city,
    address.state,
    address.zip,
    provider.name AS business_name
FROM kronos.organization_data org 
LEFT JOIN 
    kronos.address address 
        ON address.id = address_id
LEFT JOIN 
    gaia.provider provider 
        ON provider.encrypted_ref_id = gx_provider_id
),
tip as (
SELECT 
  id, 'yes' as gratuity
FROM kronos_opul.organization_data 
where feature_flags_json like '%GRATUITY%'
),
new_main1 as (
select 
  new_main.*, 
  tip.id,
  tip.gratuity
from new_main
left join 
  tip
    on practice_id = id
),
main as (
select 
  practice_id,
  created_at,
  deprecated_at,
  status, 
  gx_provider_id,
  per_member_rate,
  practice_rate,
  timezone, 
  activated_at,
  practice_name,
  live,
  payfac,
  organization_tax_percentage,
  city,
  state,
  zip,
  business_name,
  gratuity
from new_main1
)
SELECT * FROM main

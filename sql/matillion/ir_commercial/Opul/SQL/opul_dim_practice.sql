WITH main as (
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
    least(org.updated_at,address.updated_at,provider.updated_at) as updated_at,
    provider.name AS business_name
FROM internal_kronos_opul.organization_data org 
LEFT JOIN 
    internal_kronos_opul.address address 
        ON address.id = address_id
LEFT JOIN 
    internal_gaia_opul.provider provider 
        ON provider.encrypted_ref_id = gx_provider_id
),
tip as (
SELECT 
  id, 'yes' as gratuity
FROM internal_kronos_opul.organization_data 
where feature_flags_json like '%GRATUITY%'
),
new_main as (
select 
    gx_provider_id,
    created_at,
    deprecated_at,
    status, 
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
    tip.gratuity,
    updated_at,
    current_timestamp::timestamp as dwh_created_at
from main
left join 
  tip
    on practice_id = id
where gx_provider_id is not null
)
SELECT * FROM new_main

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
    provider.name AS business_name
FROM internal_kronos_hint.organization_data org 
LEFT JOIN 
    internal_kronos_hint.address address 
        ON address.id = address_id
LEFT JOIN 
    internal_gaia_hint.provider provider 
        ON provider.encrypted_ref_id = gx_provider_id
),
tip as (
SELECT 
  id, 'yes' as gratuity
FROM internal_kronos_hint.organization_data 
where feature_flags_json like '%GRATUITY%'
),
new_main as (
select 
  main.*,
  gratuity
from main
left join 
  tip
    on practice_id = id
)
SELECT * FROM new_main

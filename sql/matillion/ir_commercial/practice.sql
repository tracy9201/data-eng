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
FROM kronos.organization_data org 
LEFT JOIN 
    kronos.address address 
        ON address.id = address_id
LEFT JOIN 
    gaia.provider provider 
        ON provider.encrypted_ref_id = gx_provider_id
)
SELECT * FROM main
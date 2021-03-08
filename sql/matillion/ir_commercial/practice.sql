WITH main as (
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
        ON encrypted_ref_id = gx_provider_id
) 
SELECT * FROM main
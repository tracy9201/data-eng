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
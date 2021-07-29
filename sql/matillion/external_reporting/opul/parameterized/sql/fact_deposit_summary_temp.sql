with funding as  
(  
SELECT
    funding_master_id,
    net_sales*100 AS net_sales,
    third_party*100 AS third_party,
    adjustment*100 AS adjustment,
    interchange_fee*100 AS interchange_fee,
    service_charge*100 AS service_charge,
    fee*100 AS fee,
    reversal*100 AS reversal,
    other_adjustment*100 AS other_adjustment,
    total_funding*100 AS total_funding,
    funding_date,
    date_added,
    provider.encrypted_ref_id AS gx_provider_id,
    funding.status,
    funding.id AS funding_id  
FROM
    gaia.funding funding 
 JOIN
    gaia.authorisation authorisation
        ON authorisation_id = authorisation.id  
JOIN
    gaia.provider provider 
        ON object_id = provider.id 
),

main as 
( 
SELECT
    funding_master_id as reference_id,
    gx_provider_id as merchant_id,
    funding_date as settle_date,
    adjustment + other_adjustment AS adjustments,
    interchange_fee + service_charge + fee + third_party AS fees,    
    net_sales,
    reversal AS chargebacks
FROM
    funding 
) 
SELECT * FROM main
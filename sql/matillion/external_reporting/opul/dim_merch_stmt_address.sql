WITH merchant_address as
(
SELECT  distinct
    -- m.id as merchant_id_original
    cp.mid as merchant_id
    ,m.legal_business_name as merchant_name
    ,a.address1
    ,a.address2
    ,a.city
    ,a.state
    ,a.country
    ,a.zip
    ,a.zip2
    ,a.created_at
    ,a.updated_at
    ,a.deprecated_at
    ,case when a.address2 is not null then  a.address1|| chr(10) || a.address2|| chr(10) ||a.city|| chr(10) ||a.state|| '-' ||a.zip
          else a.address1|| chr(10) ||a.city|| chr(10) ||a.state || '-' ||a.zip end as full_address
    ,current_timestamp::timestamp as dwh_created_at
FROM
    merchant.address a 
JOIN
    merchant.contact c 
    on a.id = c.address_id
JOIN 
    merchant.merchant m 
    on c.merchant_id = m.id
JOIN 
    merchant.card_processing cp 
    on m.id = cp.merchant_id
),

latest_address as
(
SELECT
    merchant_id
    ,max(updated_at) as max_updated_at
FROM
    merchant_address
GROUP BY 1
),

main as
(
SELECT
    a.merchant_id
    ,a.merchant_name
    ,a.address1
    ,a.address2
    ,a.city
    ,a.state
    ,a.country
    ,a.zip
    ,a.zip2
    ,a.full_address
    ,case when b.merchant_id is not null then 'Y' else 'N' end as is_latest_address
    ,a.created_at
    ,a.updated_at
    ,a.deprecated_at
    ,a.dwh_created_at
FROM
    merchant_address a
LEFT JOIN 
    latest_address b on a.merchant_id = b.merchant_id and a.updated_at = b.max_updated_at
)

SELECT * FROM main

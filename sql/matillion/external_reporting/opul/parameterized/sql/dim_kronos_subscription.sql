WITH main as
(SELECT
    sub.id AS subscription_id,
    sub.status,
    sub.cycles,
    sub.quantity,
    sub.is_subscription,
    sub.period_unit,
    sub.period,
    gx_subscription_id,
    sub.plan_id,
    sub.offering_id,
    sub.type AS subscription_type,
    ad_hoc_offering_id,  
    sub.created_at,
    sub.updated_at,
    current_timestamp::timestamp as dwh_created_at
FROM kronos_opul_{environment}.subscription sub  
LEFT JOIN kronos_opul_{environment}.ad_hoc_offering ad ON ad.id = ad_hoc_offering_id 
)
SELECT * FROM main
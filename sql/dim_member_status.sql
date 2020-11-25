SELECT 
    user_id, 
    MIN(created_date) AS created_date, 
    CASE 
        WHEN ISmember3 = 0 THEN MAX(deprecated_date)
        WHEN ISmember3> 0 THEN NULL
    END AS updated_date,
    CASE WHEN ISmember3>0 THEN 'active' ELSE 'inactive' END AS status,
    gx_customer_id,
    gx_provider_id
FROM (
  SELECT 
    user_id, 
    created_date, 
    deprecated_date, 
    ISmember, 
    ismember2, 
    sum(ismember2) OVER (PARTITION by USER_id) AS ISmember3,
    gx_customer_id,
    gx_provider_id
  FROM (
        SELECT 
            DISTINCT customer.user_id, 
            sub_id,
            customer.status, 
            subscription.created_date, 
            subscription.deprecated_date, 
            isMember, 
            CASE 
              WHEN deprecated_date IS NULL AND ismember = 1 THEN 1
              WHEN ismember = 0 THEN 0
              WHEN ismember =1 AND deprecated_date IS NOT NULL THEN 0
              END AS isMember2,
            gx_customer_id
        FROM customer_data customer
        JOIN 
             v4_k_plan plan 
                ON customer.user_id=plan.user_id
        JOIN (
        -- Subscription starting date and deprecated date
        -- We don't need TO have subscription id, if there ARE several subscription WITH the same created AND deprecated date, we just care that AT that TIME we had a subscription
            SELECT 
                DISTINCT plan_id, 
                cast(to_char(created_at,'yyyy-mm-dd') AS date) AS created_date,
                id AS sub_id,
                CASE 
                    WHEN (type=2) THEN 
                    -- When a user have an installment, if deprecated_at is not null then deprecated_date=deprecated_at, else deprecated_at=created_at+period+1 (software rule)
                    (CASE WHEN (deprecated_at IS NOT null) THEN (cast(to_char(deprecated_at,'yyyy-mm-dd') AS date)) 
                    ELSE (cast(to_char(cast(to_char(created_at,'yyyy-mm-dd') AS date) + INTERVAL '1 month' * (period+1),'yyyy-mm-dd') AS date)) end) 
                    -- When we have a pay in full or subscription then deprecated_date=deprecated_at, respecting if it's null or not
                    ELSE (cast(to_char(deprecated_at,'yyyy-mm-dd') AS date)) END AS deprecated_date,
                    -- Member or not
                    CASE WHEN (type=2 OR type=1) THEN 1 ELSE 0 END AS isMember
            FROM v4_k_subscription subscription
        ) subscription ON plan.id=subscription.plan_id
WHERE  ISmember =1
ORDER BY USER_id 
  ) final
  JOIN 
      users 
        ON users.id = final.user_id
  JOIN 
      organization_data 
        ON users.organization_id = organization_data.id
  WHERE 
      organization_data.name not like 'zz%' 
      or organization_data.name not like 'zzz%' 
      or organization_data.name not like 'Hint%' 
) finalstatus 
GROUP BY 
  user_id, 
  ismember3,
  gx_customer_id,
  gx_provider_id
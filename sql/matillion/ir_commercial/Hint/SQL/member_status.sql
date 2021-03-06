WITH subscription AS (
    SELECT 
        DISTINCT plan_id, 
        cast(to_char(created_at,'MON-DD-YYYY') AS date) AS created_date,
        id AS sub_id,
        CASE 
            WHEN (type=2) THEN 
                (CASE 
                    WHEN (deprecated_at IS NOT null) THEN (cast(to_char(deprecated_at,'MON-DD-YYYY') AS date)) 
                    ELSE (cast(to_char(DATEADD(month, 1*(period), created_at) ,'MON-DD-YYYY') AS date)) end )
            ELSE (cast(to_char(deprecated_at,'MON-DD-YYYY') AS date)) 
            END AS deprecated_date,
        CASE WHEN (type=2 OR type=1) THEN 1 ELSE 0 END AS isMember,
        updated_at
    FROM internal_kronos_hint.subscription subscription
  )
  ,
customer AS (  
        SELECT 
            DISTINCT customer.user_id, 
            sub_id,
            customer.status, 
            subscription.created_date, 
            subscription.deprecated_date, 
            getdate(),
            isMember, 
            CASE 
              WHEN ismember = 0 THEN 0 
              when ismember = 1 AND to_timestamp(deprecated_date,'MM-DD-YYYY') < getdate() THEN 0
              WHEN ismember =1 AND to_timestamp(deprecated_date,'MM-DD-YYYY') >= getdate() THEN 1
              when ismember = 1 and deprecated_date is null then 1
              END AS isMember2,
            gx_customer_id,
            least(customer.updated_at,plan.updated_at,subscription.updated_at) as updated_at
        FROM internal_kronos_hint.customer_data customer
        JOIN 
             internal_kronos_hint.plan plan 
                ON customer.user_id = plan.user_id
        JOIN subscription 
            ON plan.id = subscription.plan_id
        WHERE  ISmember =1 
        ORDER BY user_id 
)
,
final as (  
  SELECT 
    user_id, 
    created_date, 
    deprecated_date, 
    getdate(),
    ISmember, 
    ismember2, 
    sum(ismember2) OVER (PARTITION by USER_id) AS ISmember3,
    gx_customer_id,
    gx_provider_id,
    least(customer.updated_at,users.updated_at,organization_data.updated_at) as updated_at
  FROM customer
  JOIN 
      internal_kronos_hint.users users
        ON users.id = customer.user_id
  JOIN 
      internal_kronos_hint.organization_data organization_data
        ON users.organization_id = organization_data.id
  WHERE 
      (organization_data.name not like 'zz%' 
      or organization_data.name not like 'zzz%' 
      or organization_data.name not like 'Hint%' )

)
,
finalstatus as (
SELECT 
    gx_customer_id,
    MIN(case when ISmember = 1 then created_date end) AS created_date, 
    CASE 
        WHEN ISmember3 = 0 THEN MAX(deprecated_date)
        WHEN ISmember3> 0 THEN NULL
    END AS updated_date,
    CASE WHEN ISmember3>0 THEN 'active' ELSE 'inactive' END AS status,
    gx_provider_id,
    updated_at
FROM final
GROUP BY 
  gx_customer_id,
  user_id, 
  ismember3,
  gx_provider_id,
  updated_at
ORDER BY
    created_date,
    user_id
),
main as (
SELECT 
    ROW_NUMBER() OVER () AS id, 
    *
FROM finalstatus
)
SELECT *,current_timestamp::timestamp as dwh_created_at FROM main

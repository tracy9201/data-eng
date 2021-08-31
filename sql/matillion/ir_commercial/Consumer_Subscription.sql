WITH Membership_Active_Count AS
(
  SELECT count(Distinct gx_customer_id) AS MEM_COUNT,gx_provider_id
  FROM
  ir_commercial.membership_status
  Group By gx_provider_id
),
ACTIVE_MEMBER AS
(
  SELECT
  gx_customer_id
  FROM ir_commercial.membership_status
  WHERE status='active'
),   
Subscription_Count AS
(
  SELECT count(Distinct ICS.gx_customer_id) AS SUB_COUNT, gx_provider_id
  FROM ir_commercial.subscription AS ICS
  RIGHT JOIN ACTIVE_MEMBER AS AM on
  AM.gx_customer_id=ICS.gx_customer_id
  WHERE
  Subscription_type=1
  AND gx_subscription_id IS NOT NULL
  GROUP BY gx_provider_id
),
Consumer_Subscription AS
(
  SELECT
  MAC.gx_provider_id,
  MAC.MEM_COUNT AS MemberCount,
  SC.SUB_COUNT AS SubcriberMemberCount
  FROM Membership_Active_Count AS MAC
  INNER JOIN Subscription_Count AS SC
  ON SC.gx_provider_id= MAC.gx_provider_id
)
    
SELECT * FROM Consumer_Subscription
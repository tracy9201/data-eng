WITH Service_Customer_Date_Differences AS
(
   SELECT DISTINCT
      gx_customer_id,
      Date(service_date) AS Service_Date,
      COALESCE(Date(LAG(service_date, 1) OVER (PARTITION BY gx_customer_id, offering_id
   ORDER BY
      service_date)), Date(service_date)) AS Last_Service_Date,
      COALESCE(DATEDIFF(day, Last_Service_Date, service_date), 0) AS Diff_Days
   FROM
      ir_commercial.fulfillment
   WHERE
      status = 'Completed'
   ORDER BY
      gx_customer_id,
      service_date DESC
)
,
Provider_Average_Differences AS
(
   SELECT
      ICPR.gx_provider_id,
      ICPR.business_name,
      avg(SDD.diff_days) AS AverageDays
   FROM
      Service_Customer_Date_Differences AS SDD
      INNER JOIN
         ir_commercial.patient AS ICP
         ON ICP.gx_customer_id = SDD.gx_customer_id
      INNER JOIN
         ir_commercial.practice AS ICPR
         ON ICPR.gx_provider_id = ICP.gx_provider_id
         AND diff_days > 0
   GROUP BY
      ICPR.gx_provider_id,
      ICPR.business_name
)
,
Active_Members AS
(
   SELECT
      id,
      created_date,
      updated_date,
      status,
      gx_customer_id,
      gx_provider_id,
      DATEDIFF(day, created_date, updated_date) as num_days_as_active,
      DATEDIFF(day, created_date, getdate()) as days_since_creation
   FROM
      ir_commercial.member_status
  -- WHERE
  --    status = 'active'
)
,
Active_Membership_length As
(
   SELECT
      id,
      created_date,
      updated_date,
      gx_customer_id,
      gx_provider_id,
      ISNULL(num_days_as_active, days_since_creation) as membership_length
   FROM
      Active_Members
)
,
Active_Average_Membership AS
(
   SELECT
      AVG(membership_length) as avg_membership_length,
      gx_provider_id
   FROM
      Active_Membership_length
   GROUP BY
      gx_provider_id
)
,
Business_Info_Active_Members AS
(
   SELECT
      AAM.gx_provider_id,
      business_name,
      avg_membership_length
   FROM
      ir_commercial.practice AS ICP
      INNER JOIN
         Active_Average_Membership AS AAM
         ON AAM.gx_provider_id = ICP.gx_provider_id
),
membershiplength_vs_daysbetweenappts AS (
SELECT
   BIAM.business_name,
   BIAM.gx_provider_id,
   PAD.averagedays,
   BIAM.avg_membership_length
FROM
   Business_Info_Active_Members AS BIAM
   INNER JOIN
      Provider_Average_Differences AS PAD
      ON PAD.gx_provider_id = BIAM.gx_provider_id
)
SELECT * FROM membershiplength_vs_daysbetweenappts
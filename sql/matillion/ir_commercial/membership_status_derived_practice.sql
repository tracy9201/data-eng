With Active_Members AS
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
),
Active_Membership_length As
(
   SELECT
      id,
      status,
      created_date,
      updated_date,
      gx_customer_id,
      gx_provider_id,
      ISNULL(num_days_as_active, days_since_creation) as membership_length
   FROM
      Active_Members
),
Active_Average_Membership AS
(
   SELECT
      AVG(membership_length) as avg_membership_length,
      gx_provider_id
   FROM
      Active_Membership_length
   GROUP BY
      gx_provider_id
),
Business_Info_Active_Members AS
(
   SELECT
      AAM.gx_provider_id,
      business_name,
      avg_membership_length,
      state
   FROM
      ir_commercial.practice
      INNER JOIN
         Active_Average_Membership as AAM
         ON AAM.gx_provider_id = ir_commercial.practice.gx_provider_id
   ORDER BY
      avg_membership_length
),
membership_status_derived_practice AS
(
   SELECT
      id,
      status,
      created_date,
      updated_date,
      gx_customer_id,
      BIAM.gx_provider_id,
      business_name,
      membership_length,
      avg_membership_length,
      state
   FROM
      Active_Membership_length AS AML
      LEFT JOIN
         Business_Info_Active_Members as BIAM
         ON BIAM.gx_provider_id = AML.gx_provider_id
   WHERE
      AML.gx_provider_id NOT IN
      (
         SELECT
            gx_provider_id
         FROM
            ir_commercial.practice
         WHERE
            LOWER(business_name) like '%test%'
            OR lower(business_name) like '%zz%'
            OR lower(business_name) like '%hint%'
            OR business_name like '%Medspa%'
            OR lower(business_name) like '%anthena%'
      )
)
SELECT
   *
FROM
   membership_status_derived_practice
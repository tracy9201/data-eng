WITH Membership_Status AS
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
)
,
Membership_Status_With_length as
(
   SELECT
      id,
      created_date,
      updated_date,
      status,
      gx_customer_id,
      gx_provider_id,
      num_days_as_active,
      days_since_creation,
      ISNULL(num_days_as_active, days_since_creation) as membership_length
   FROM
      Membership_Status
)
Select
   *
From
   Membership_Status_With_length
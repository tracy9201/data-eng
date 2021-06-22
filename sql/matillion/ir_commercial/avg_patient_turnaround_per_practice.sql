with DurationPerUser as 
(
   SELECT DISTINCT
      user_id,
      Date(service_date) AS Service_Date,
      COALESCE(Date(LAG(service_date, 1) OVER (PARTITION BY user_id, offering_id 
   ORDER BY
      service_date)), Date(service_date)) AS Last_Service_Date,
      COALESCE(DATEDIFF(day, Last_Service_Date, service_date), 0) AS Diff_Days 
   FROM
      ir_commercial.fulfillment 
   WHERE
      status = 'Completed' 
   ORDER BY
      user_id,
      service_date DESC 
)
,
AveragePerPractice AS 
(
   select
      practice.practice_id,
      avg(DurationPerUser.diff_days) as AverageDays 
   from
      DurationPerUser 
      inner join
         ir_commercial.patient 
         on patient.user_id = DurationPerUser.user_id 
      inner join
         ir_commercial.practice 
         on practice.practice_id = patient.organization_id 
         and diff_days > 0 
   group by
      practice_id 
   order by
      practice_id 
)
,
Result as
(
   select
      practice.business_name,
      practice.practice_id,
      AveragePerPractice.AverageDays 
   from
      AveragePerPractice 
      inner join
         ir_commercial.practice 
         on practice.practice_id = AveragePerPractice.practice_id 
   order by
      practice.business_name 
)
Select
   * 
from
   Result

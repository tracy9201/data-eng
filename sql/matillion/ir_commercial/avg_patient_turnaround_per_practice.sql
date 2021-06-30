with Chain as
(
   with DurationPerUser as
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
   Brand as
   (
      SELECT
         ICF.gx_customer_id,
         IR.category
      FROM
         ir_cs.brand_catalog_category IR
         Inner JOIN
            ir_commercial.offering IO
            ON (IO.factory_name = IR.brand)
            AND
            (
               IO.catalog_name = IR.catalog
            )
         INNER JOIN
            ir_commercial.fulfillment ICF
            ON (ICF.offering_id = IO.offering_id)
   )
   Select
      DurationPerUser.gx_customer_id,
      DurationPerUser.Service_Date,
      DurationPerUser.Diff_Days,
      Brand.category
   from
      DurationPerUser
      inner join
         Brand
         on Brand.gx_customer_id = DurationPerUser.gx_customer_id
)
,
AveragePerPractice AS
(
   select
      practice.gx_provider_id,
      Chain.category,
      avg(Chain.diff_days) as AverageDays
   from
      Chain
      inner join
         ir_commercial.patient
         on patient.gx_customer_id = Chain.gx_customer_id
      inner join
         ir_commercial.practice
         on practice.gx_provider_id = patient.gx_provider_id
         and diff_days > 0
   group by
      practice.gx_provider_id,
      category
   order by
      practice.gx_provider_id
)
,
Result as
(
   select
      ir_commercial.practice.business_name,
      ir_commercial.practice.gx_provider_id,
      AveragePerPractice.category,
      AveragePerPractice.AverageDays
   from
      AveragePerPractice
      inner join
         ir_commercial.practice
         on ir_commercial.practice.gx_provider_id = AveragePerPractice.gx_provider_id
   order by
      practice.business_name
)
Select
   *
from
   Result
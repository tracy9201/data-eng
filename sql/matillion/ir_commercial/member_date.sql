With member_date AS 
(
   select
      ir_commercial.member_status.gx_customer_id,
      to_char(ir_commercial.member_status.created_date, 'yyyy-mm') as created,
      to_char((ir_commercial.member_status.updated_date || ' 00:00:01'):: timestamp, 'yyyy-mm') as cancelled,
      (
         DATE_PART('year', ir_commercial.member_status.updated_date) - DATE_PART('year', ir_commercial.member_status.created_date) 
      )
      * 12 + (DATE_PART('month', ir_commercial.member_status.updated_date) - DATE_PART('month', ir_commercial.member_status.created_date)) as cancelled_month 
   from
      ir_commercial.member_status 
   WHERE
      ir_commercial.member_status.updated_date <= getdate() 
      OR ir_commercial.member_status.updated_date IS NULL
)
select
   * 
from
   member_date
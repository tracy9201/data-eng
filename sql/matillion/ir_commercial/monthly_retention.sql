With Member_Days AS
(
   select
      ir_commercial.member_status.gx_customer_id,
      to_char(ir_commercial.member_status.created_date, 'yyyy-mm') as created,
      to_char((ir_commercial.member_status.updated_date || ' 00:00:01'):: timestamp, 'yyyy-mm') as cancelled,
      ( DATE_PART('year', ir_commercial.member_status.updated_date) - DATE_PART('year', ir_commercial.member_status.created_date) ) * 12 + (DATE_PART('month', ir_commercial.member_status.updated_date) - DATE_PART('month', ir_commercial.member_status.created_date)) 
      as cancelled_month 
   from
      ir_commercial.member_status 
   WHERE
      ir_commercial.member_status.updated_date <= getdate() 
      OR ir_commercial.member_status.updated_date IS NULL 
),
Member_days_By_Cancelled_Date as 
(
   select
      created,
      gx_customer_id,
      case when cancelled_month is null then 100 else cancelled_month + 1 
      end
      as cancelled_month , count(*) as total 
   from
      Member_Days 
   group by
      created, cancelled_month, gx_customer_id 
),
Retention_Values as 
(
   select
      created,
      cancelled_month,
      gx_customer_id,
      ( created || '-01 00:00:01' ) :: timestamp as created_month,
      total,
      sum(total) over (partition by created) as Total_Customer_Per_Month,
      sum(total) over (partition by created 
   order by
      cancelled_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as customer_index 
   from
      Member_days_By_Cancelled_Date 
),
Cancelled_Month_filtering as 
(
   select
      created,
      gx_customer_id,
      cancelled_month,
      created_month,
      Total_Customer_Per_Month,
      customer_index,
      case
         when cancelled_month = 100 then 0 else customer_index 
      end
      as occurance_limitation 
   from
      Retention_Values 
   order by
      created, cancelled_month 
),
Monthly_Retention as 
(
   select
      created,
      gx_customer_id,
      cancelled_month,
      created_month,
      (Total_Customer_Per_Month - (max(occurance_limitation) over (partition by created))) as currently_remaning_customer,
      Total_Customer_Per_Month ,customer_index 
   from
      Cancelled_Month_filtering 
   order by
      created, cancelled_month 
)
Select
   * 
from
   Monthly_Retention
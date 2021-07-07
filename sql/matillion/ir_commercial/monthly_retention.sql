select
   created,
   gx_customer_id,
   cancelled_month,
   created_month,
   (
      sum - (max(agg_total2) over (partition by created)) 
   )
   as total,
   sum,
   agg_total 
from
   (
      select
         created,
         gx_customer_id,
         cancelled_month,
         created_month,
         sum,
         agg_total,
         case
            when
               cancelled_month = 100 
            then
               0 
            else
               agg_total 
         end
         as agg_total2 
      from
         (
            select
               created,
               cancelled_month,
               gx_customer_id,
               (
                  created || '-01 00:00:01' 
               )
               :: timestamp as created_month,
               total,
               sum(total) over (partition by created) as sum,
               sum(total) over (partition by created 
            order by
               cancelled_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as agg_total 
            from
               (
                  select
                     created,
                     gx_customer_id,
                     case
                        when
                           cancelled_month is null 
                        then
                           100 
                        else
                           cancelled_month + 1 
                     end
                     as cancelled_month , count(*) as total 							--
                  from
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
                     table1 
                  group by
                     created,
                     cancelled_month,
                     gx_customer_id 
               )
               table2 
         )
         table3 
   )
   table4 
order by
   created,
   cancelled_month
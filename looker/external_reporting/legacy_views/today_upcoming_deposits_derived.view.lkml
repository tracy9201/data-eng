view: today_upcoming_deposits_derived {
  derived_table: {
    sql:select A.deposit_date, A.gx_provider_id,A.id,A.uniq_date, A.total_fund, A.total_tran,A.sum_tran_to_date1, A.sum_fund_to_date1,
          last_value(A.sum_tran_to_date1 ignore nulls) over(partition by A.gx_provider_id order by A.uniq_date rows between unbounded preceding and current row ) as sum_tran_to_date,
      last_value(A.sum_fund_to_date1 ignore nulls) over(partition by A.gx_provider_id order by A.uniq_date rows between unbounded preceding and current row ) as sum_fund_to_date
      from (
          SELECT cast(DATE AS timestamp) as deposit_date, date_provider.gx_provider_id,qpd.id,cast(coalesce(qpd.unique_date,date) as timestamp) as uniq_date,
                coalesce(qpd.total_fund,0) as total_fund, coalesce(qpd.total_tran,0) as total_tran,
                qpd.sum_tran_to_date1, qpd.sum_fund_to_date1
                  from
                  (SELECT DATE, gx_provider_id
                           FROM
                               date_table
                           CROSS JOIN
                              practice
                           ORDER BY gx_provider_id, DATE
                           ) date_provider
                  left join today_upcoming_deposit qpd
                  on date_provider.gx_provider_id = qpd.gx_provider_id
                  and date_provider.date = qpd.unique_date

                  order by gx_provider_id, uniq_date)A ;;


    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    measure: upcoming_deposit {
      type: max
      sql: ${sum_tran_to_date}-${sum_fund_to_date};;
      filters: {
        field: uniq_date_date
        value: "today"
      }

      label: "upcoming"
      value_format: "$#,##0.00"
      html:  <p style="text-align:center;font-weight: bold;color:black;font-size:45%;"> Upcoming Deposits </p>
        <div  style="text-align:center;font-weight: bold; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    }

    measure: total_funds {
      type: sum
      sql: coalesce(${total_fund},0) ;;
      label: "total funds"
      value_format: "$#,##0.00"
      html:  <p style="text-align:center;font-weight: bold;color:black;font-size:45%;"> Total Deposits </p>
        <div  style="text-align:center; font-weight: bold;number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    }


    dimension_group: deposit_date {
      type: time
      timeframes: [date, week, month, year, hour12, minute, hour,time,time_of_day,hour_of_day]
      sql: ${TABLE}.deposit_date ;;
    }

    dimension: gx_provider_id {
      type: string
      sql: ${TABLE}.gx_provider_id ;;
    }

    dimension: id {
      type: number
      sql: ${TABLE}.id ;;
    }

    dimension_group: uniq_date {
      type: time
      timeframes: [date, week, month, year, hour12, minute, hour,time,time_of_day,hour_of_day]
      sql: ${TABLE}.uniq_date ;;
    }

    dimension: total_fund {
      type: number
      sql: ${TABLE}.total_fund/100 ;;
    }

    dimension: total_tran {
      type: number
      sql: ${TABLE}.total_tran/100 ;;
    }

    dimension: sum_tran_to_date1 {
      type: number
      sql: coalesce(${TABLE}.sum_tran_to_date1,0)/100 ;;
    }

    dimension: sum_fund_to_date1 {
      type: number
      sql: coalesce(${TABLE}.sum_fund_to_date1,0)/100 ;;
    }

    dimension: sum_tran_to_date {
      type: number
      sql: coalesce(${TABLE}.sum_tran_to_date,0)/100 ;;
    }

    dimension: sum_fund_to_date {
      type: number
      sql: coalesce(${TABLE}.sum_fund_to_date,0)/100 ;;
    }

    set: detail {
      fields: []
    }

    #set: detail {
    #  fields: [
    #    deposit_date_date,
    #    gx_provider_id,
    #    id,
    #    uniq_date_date,
    #    total_fund,
    #    total_tran,
    #    sum_tran_to_date,
    #    sum_fund_to_date
    #  ]
    #}
  }

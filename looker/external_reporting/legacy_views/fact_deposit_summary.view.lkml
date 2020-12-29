view: deposit_summary{
  sql_table_name: dwh_hint.fact_deposit_summary ;;

  # derived_table: {

  #   sql:  select *, sum(total_funding) over(partition by gx_provider_id,funding_master_id) as sum_funds,
  #           --row_number() over(partition by provider_id,funding_master_id) as ronum_Funding_master from deposit_summary
  #           row_number() over(partition by funding_master_id) as ronum_Funding_master from deposit_summary ;;
  # }


  dimension: adjustments {
    type: number
    sql: ${TABLE}.adjustments/100 ;;
    value_format: "$#,##0.00"
  }

  dimension: batch_id {
    type: string
    sql: ${TABLE}.batch_id ;;
  }

  dimension: chargebacks {
    type: number
    sql: ${TABLE}.chargebacks/100 ;;
    value_format: "$#,##0.00"
  }

  dimension_group: date_added {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.date_added_time ;;
  }

  dimension: fees {
    type: number
    sql: ${TABLE}.fees/100 ;;
    value_format: "$#,##0.00"
  }

  dimension_group: funding_date_time {
    type: time
    timeframes: [date, week, month, year, hour12, minute, hour,time,time_of_day,hour_of_day
    ]
    sql: ${TABLE}.funding_date_time ;;
    #sql: ${TABLE}.funding_date_date;;
    #html: {{ rendered_value | date: "%m/%d/%Y" }} ;;
  }

  dimension: funding_date {
    type: date
    sql: ${TABLE}.funding_date_time ;;
    #sql: ${TABLE}.funding_date_date;;
    html: {{ rendered_value | date: "%m/%d/%Y" }} ;;
  }

  dimension: funding_master_id {
    type: string
    sql: ${TABLE}.funding_master_id ;;

    link: {
      label: "Deposit Details"
      #url: "https://hintmdqa.looker.com/dashboards/looker_hintmd::Deposit_Details?Funding_master_id={{ value }}"
      url:  "/dashboards/looker_hintmd::Deposit_Details?Funding_master_id={{ value }}"
      icon_url: "https://looker.com/favicon.ico"

    }

  }

  dimension: gx_provider_id {
    type: string
    sql: ${TABLE}.gx_provider_id ;;
  }

  dimension: net_sales {
    type: number
    sql: ${TABLE}.net_sales/100 ;;
    value_format: "$#,##0.00"
  }

  dimension: status {
    #type: number
    #sql: ${TABLE}.status ;;
    case: {
      when: {
        sql: ${TABLE}.status = 1 ;;
        label: "Funded"
      }
      else: "Processed"
    }
  }

  dimension: total_funding {
    type: number
    sql: ${TABLE}.total_funding/100 ;;
    value_format: "$#,##0.00"
  }

  # dimension: sum_funds {
  #   type: number
  #   sql: ${TABLE}.sum_funds/100 ;;
  #   label: "Window Sum"
  #   value_format: "$#,##0.00"
  # }

  # dimension: ronum_Funding_master {
  #   type: number
  #   sql:  ${TABLE}.ronum_Funding_master ;;
  # }

  measure: total_funds {
    type: sum
    sql: coalesce(${total_funding},0) ;;
    label: "total funds"
    value_format: "$#,##0.00"
    html:  <p style="text-align:center;font-weight: bold;color:black;font-size:95%;"> Total Deposits </p>
      <div  style="text-align:center; font-weight: bold;number-format='$#,##0' ">{{ rendered_value }}</div> ;;
  }

  measure: total_funds_7_days {
    type: sum
    sql: coalesce(${total_funding},0) ;;
    label: "total funds last 7d"
    value_format: "$#,##0.00"
    html:  <p style="text-align:center;font-weight: bold;color:black;font-size:95%;"> Total Deposits Last 7d </p>
      <div  style="text-align:center; font-weight: bold;number-format='$#,##0' ">{{ rendered_value }}</div> ;;
  }

  measure: total_funds_current_month {
    type: sum
    sql: coalesce(${total_funding},0) ;;
    label: "total funds current month"
    value_format: "$#,##0.00"
    html:  <p style="text-align:center;font-weight: bold;color:black;font-size:95%;"> Total Deposits Current Month </p>
      <div  style="text-align:center; font-weight: bold;number-format='$#,##0' ">{{ rendered_value }}</div> ;;
  }

  measure: total_funds_last_month {
    type: sum
    sql: coalesce(${total_funding},0) ;;
    label: "total funds last month"
    value_format: "$#,##0.00"
    html:  <p style="text-align:center;font-weight: bold;color:black;font-size:95%;"> Total Deposits Last Month </p>
      <div  style="text-align:center; font-weight: bold;number-format='$#,##0' ">{{ rendered_value }}</div> ;;
  }

  measure: total_funds_current_year {
    type: sum
    sql: coalesce(${total_funding},0) ;;
    label: "total funds current year"
    value_format: "$#,##0.00"
    html:  <p style="text-align:center;font-weight: bold;color:black;font-size:95%;"> Total Deposits Current Year </p>
      <div  style="text-align:center; font-weight: bold;number-format='$#,##0' ">{{ rendered_value }}</div> ;;
  }

  ### ADDED BELOW MEASURES FOR DEPOSIT DETAILS DASHBOARD PAN-5103 #######
  measure: sum_fees_Details {
    type: sum
    sql: ${fees} ;;
    value_format: "$#,##0.00"
    label: "CC Fees"

  }

  measure: sum_total_deposited_Details {
    type: sum
    sql: ${total_funding} ;;
    label: "Total Deposited"
    value_format: "$#,##0.00"
    html: <p style="text-align:center;font-size:100%;color:black"> {{ rendered_value }}</p>
      <div style="text-align:center;color:black;font-size:65%;"> Total Deposited </div>;;

  }

  measure: sum_net_sales_Details {
    type: sum
    sql: ${net_sales};;
    label: "Net Sales Sum"
    value_format: "$#,##0.00"

  }

  measure: sum_adjustment_Details {
    type: sum
    sql: ${adjustments};;
    label: "Adjustments Sum"
    value_format: "$#,##0.00"

  }

  measure: count {
    type: count
    drill_fields: []
  }
}

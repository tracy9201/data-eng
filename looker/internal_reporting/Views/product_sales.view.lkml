view: product_sales {
  sql_table_name: external_reporting_qa.product_sales ;;

  dimension: auto_renewal {
    type: string
    sql: ${TABLE}.auto_renewal ;;
  }

  dimension: balance {
    type: number
    sql: ${TABLE}.balance ;;
  }

  dimension: coupons {
    type: number
    sql: ${TABLE}.coupons ;;
  }

  dimension: credits {
    type: number
    sql: ${TABLE}.credits ;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: discount_amts {
    type: number
    sql: ${TABLE}.discount_amts ;;
  }

  dimension: discount_percentages {
    type: number
    sql: ${TABLE}.discount_percentages ;;
  }

  dimension: end_count {
    type: number
    sql: ${TABLE}.end_count ;;
  }

  dimension_group: end {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour12,
      minute,
      hour,
      time_of_day,
      hour_of_day
    ]

    sql: ${TABLE}.end_date ;;
  }

  dimension: end_unit {
    type: string
    sql: ${TABLE}.end_unit ;;
  }

  dimension: k_customer_id {
    type: string
    sql: ${TABLE}.k_customer_id ;;
  }

  dimension: k_plan_id {
    type: string
    sql: ${TABLE}.k_plan_id ;;
  }

  dimension: k_provider_id {
    type: string
    sql: ${TABLE}.k_provider_id ;;
  }

  dimension: k_subscirption_id {
    type: string
    sql: ${TABLE}.k_subscirption_id ;;
  }

  dimension: payments {
    type: number
    sql: ${TABLE}.payments ;;
  }

  dimension: plan_id {
    type: number
    sql: ${TABLE}.plan_id ;;
  }

  dimension: proration {
    type: string
    sql: ${TABLE}.proration ;;
  }

  dimension: provider_id {
    type: number
    sql: ${TABLE}.provider_id ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: remaining_payment {
    type: number
    sql: ${TABLE}.remaining_payment ;;
  }

  dimension: renewal_count {
    type: number
    sql: ${TABLE}.renewal_count ;;
  }

  dimension_group: start {
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
    sql: ${TABLE}.start_date ;;
  }

  dimension_group: subscription_canceled {
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
    sql: ${TABLE}.subscription_canceled_at ;;
  }

  dimension_group: subscription_created {
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
    sql: ${TABLE}.subscription_created ;;
  }

  dimension: subscription_id {
    type: number
    sql: ${TABLE}.subscription_id ;;
    primary_key: yes
  }

  dimension: subscription_name {
    type: string
    sql: ${TABLE}.subscription_name ;;
  }

  dimension_group: subscription_updated {
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
    sql: ${TABLE}.subscription_updated_at ;;
  }

  dimension: subtotal {
    type: number
    sql: ${TABLE}.subtotal ;;
  }

  dimension: tax {
    type: number
    sql: ${TABLE}.tax ;;
  }

  dimension: total {
    type: number
    sql: ${TABLE}.total ;;
  }

  dimension: total_installment {
    type: number
    sql: ${TABLE}.total_installment ;;
  }

  dimension: unit_name {
    type: string
    sql: ${TABLE}.unit_name ;;
  }

  dimension: top_five_products {
    type: string
    sql: case when ${subscription_created_date} IS NOT NULL then 'Top Sales' else NULL end ;;
    html:  <p style="text-align:center;color:black;font-size:155%"> Top Product Sales </p>
      <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
  }

  dimension_group: loaded_at {
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
    sql: ${TABLE}.loaded_at ;;
  }

  measure: max_load_date {

    sql: max(${loaded_at_time}) ;;
    label: "max load date"

  }

  measure: Note_Tile {
    type: string
    #sql: case when ${sales_created_at_date} IS NOT NULL then 'Sales By Payment Method' else NULL end ;;
    sql: ${max_load_date};;
    html:  <p style="text-align:right;color:#97999B;font-size:60%;margin-right:1%"> Data refreshed: <span style = "text-align:right;color:#97999B;font-size:90%;margin-right:1%;margin-top:1px">{{ rendered_value | date: "%m/%d/%Y %I:%M %p" }}<span style="text-align:right;color:#97999B;font-size:100%;margin-right:1%;margin-top:1px"> , max. 1000 records</span></span></p></p>;;
    #html:  <p style="text-align:right;color:#808080;font-size:68%;font-weight:bolder;margin-top:0%;margin-right:1%"> Data refreshed: <span style = "text-align:right;color:#808080;font-size:100%;font-weight:500;margin-top:0%;margin-right:1%">{{ rendered_value | date: "%m/%d/%Y %I:%M %p" }}<span style="text-align:right;color:#808080;font-size:100%;font-weight:500;margin-top:0%;margin-right:1%"> , max. 1000 records</span></span></p></p>;;
# #ffffff
  }


#   dimension: Note_Tile_Left {
#     type: string
#     sql: 'Note_2_left' ;;
#     # html:  <p style="text-align:left;color:#97999B;font-size:65%;margin-left:2%;margin-top:5%"> Date range filter displays results for the interval beginning at </p>
#     #   <p style="text-align:left;color:#97999B;font-size:65%;margin-left:2%;margin-bottom:5% ">midnight on the first date until midnight on the second date</p> ;;
#
#     html: <p "text-align:left;color:#97999B;font-size:5%;margin-left:2%;width: 150px;word-break:break-all" >
#     <i>Date range filter displays results for the interval beginning at midnight on the first date until midnight on the second date </i></p> ;;
#   }

  dimension: Note_Tile_Left {
    type: string
    sql: 'Note_2_left' ;;
    # html:  <p style="text-align:left;color:#97999B;font-size:65%;margin-left:2%;margin-top:5%"> Date range filter displays results for the interval beginning at </p>
    #   <p style="text-align:left;color:#97999B;font-size:65%;margin-left:2%;margin-bottom:5% ">midnight on the first date until midnight on the second date</p> ;;

    html: <p style="font-size:60%;text-align:left;color:#97999B;margin-left:1%;margin-top:1px"><i>Note: Results include data from the first date until before the second date</i></p> ;;
  }


  measure: count {
    type: count
    drill_fields: []
  }

  measure: total_amount {
    type: sum
    sql: ${total}/100 ;;
    value_format: "$#,##0.00"
    label: "Sales"
  }


}

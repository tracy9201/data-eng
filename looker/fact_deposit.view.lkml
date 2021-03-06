view: fact_deposit {
  sql_table_name: public.fact_deposit ;;

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
    value_format: "$#,##0.00"
  }

  dimension: card_brand {
    type: string
    sql: ${TABLE}.card_brand ;;
  }

  dimension: merchant_id {
    type: number
    sql: ${TABLE}.merchant_id ;;
  }
#https://i.ibb.co/jbZHvyQ/hint-horiz-mark-purple-tm-598-x-112.png
  dimension: hint_image {
    type: string
    sql: 'abc';;
    #html: <img src="https://logo-core.clearbit.com/looker.com" /> ;;
    html: <img  style="float:left;padding-left:5px;" src="https://i.ibb.co/gg02GjG/Opul-Logo.png" alt="hint-horiz-mark-purple-tm-598-x-112" border="0"> ;;
  }
# html:  <p style="text-align:left;padding-left:5px;font-weight: bold;color:#684A91;font-size:120%"> Summary Analytics </p>;;
  dimension: Title_Summary_Analytics{
    type: string
    sql: 'Summary Analytics' ;;
    html:  <p style="text-align:left;padding-left:5px;font-weight: bold;color:#000000;font-size:100%"> Summary Analytics </p>;;
  }

  dimension_group: settlement {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.settlement_date ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: Transaction_count {
    type: sum
    sql: ${TABLE}.Transaction_count ;;
  }
  measure: fee {
    type: sum
    sql: ${TABLE}.fee ;;
    value_format: "$#,##0.00"
  }

  measure: Tranasction_fee {
    type: sum
    sql: ${TABLE}.Transaction_fee;;
    value_format: "$#,##0.00"
  }

  measure: Total_Amount {
    type: sum
    sql: ${TABLE}.amount/100.0 ;;
    value_format: "$#,##0.00"
  }
  measure: min_Amount {
    type: min
    sql: ${TABLE}.amount/100.0  ;;
    value_format: "$#,##0.00"
  }
  measure: max_amount {
    type: max
    sql: ${TABLE}.amount/100.0 ;;
    value_format: "$#,##0.00"
  }
  measure: median_amount {
    type: median
    sql: ${TABLE}.amount/100.0 ;;
    value_format: "$#,##0.00"
  }
  measure: avg_amount {
    type: average
    sql: ${TABLE}.amount/100.0 ;;
    value_format: "$#,##0.00"
  }

}

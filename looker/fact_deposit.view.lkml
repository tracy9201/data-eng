view: fact_deposit {
  sql_table_name: public.fact_deposit ;;

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: card_brand {
    type: string
    sql: ${TABLE}.card_brand ;;
  }

  dimension: merchant_id {
    type: number
    sql: ${TABLE}.merchant_id ;;
  }

  dimension: hint_image {
    type: string
    sql: 'abc';;
    #html: <img src="https://logo-core.clearbit.com/looker.com" /> ;;
    html: <img src="https://i.ibb.co/jbZHvyQ/hint-horiz-mark-purple-tm-598-x-112.png" alt="hint-horiz-mark-purple-tm-598-x-112" border="0"> ;;
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

  measure: Total_Amount {
    type: sum
    sql: ${TABLE}.amount/100.0 ;;
  }
  measure: min_Amount {
    type: min
    sql: ${TABLE}.amount/100.0  ;;
  }
  measure: max_amount {
    type: max
    sql: ${TABLE}.amount/100.0 ;;
  }
  measure: median_amount {
    type: median
    sql: ${TABLE}.amount/100.0 ;;
  }
  measure: avg_amount {
    type: average
    sql: ${TABLE}.amount/100.0 ;;
  }

}

view: fact_payfac_deposit {
  sql_table_name: dwh.fact_payfac_deposit ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
    value_format: "$#,##0.00"
  }

  dimension: card_brand {
    type: string
    sql: ${TABLE}.card_brand ;;
  }

  dimension: card_identifier {
    type: string
    sql: ${TABLE}.card_identifier ;;
  }

  dimension: cp_or_cnp {
    type: string
    sql: ${TABLE}.cp_or_cnp ;;
  }

  dimension: fee_type {
    type: string
    sql: ${TABLE}.fee_type ;;
  }

  dimension: fixed_fee {
    type: number
    sql: ${TABLE}.fixed_fee ;;
  }

  dimension: merchant_id {
    type: string
    sql: ${TABLE}.merchant_id ;;
  }

  dimension: percent_fee {
    type: number
    sql: ${TABLE}.percent_fee ;;
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

  measure: total_fee {
    type: sum
    sql: ${TABLE}.total_fee ;;
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


  dimension: transaction_id {
    type: string
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

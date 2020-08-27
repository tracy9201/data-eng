view: payfac_chargeback {
  sql_table_name: public.payfac_chargeback ;;

  dimension: amount {
    type: number
    sql: ${TABLE}.amount;;
    value_format: "$#,##0.00"
  }

  dimension: api_response {
    type: string
    sql: ${TABLE}.api_response ;;
  }

  dimension: card_brand {
    type: string
    sql: ${TABLE}.card_brand ;;
  }

  dimension: card_identifier {
    type: number
    value_format_name: id
    sql: ${TABLE}.card_identifier ;;
  }

  dimension: case_number {
    type: number
    sql: ${TABLE}.case_number ;;
  }

  dimension: chargeback_id {
    type: number
    sql: ${TABLE}.chargeback_id ;;
  }

  dimension: chargeback_reason_code {
    type: string
    sql: ${TABLE}.chargeback_reason_code ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension_group: exchange_date_added {
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
    sql: ${TABLE}.exchange_date_added ;;
  }

  dimension: merchant_id {
    type: number
    sql: ${TABLE}.merchant_id ;;
  }

  dimension: merchant_name {
    type: string
    sql: ${TABLE}.merchant_name ;;
  }

  dimension_group: processed {
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
    sql: ${TABLE}.processed_date ;;
  }

  dimension: reference_id {
    type: string
    sql: ${TABLE}.reference_id ;;
  }

  dimension: transaction_id {
    type: string
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: transaction_status {
    type: number
    sql: ${TABLE}.transaction_status ;;
  }

  dimension_group: transaction {
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
    sql: ${TABLE}.transaction_time ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}.transaction_type ;;
  }

  measure: count {
    type: count
    drill_fields: [merchant_name]
  }
}

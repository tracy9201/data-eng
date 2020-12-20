view: fiserv_chargeback {
  sql_table_name: payfac.fiserv_chargeback ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
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
    type: string
    sql: ${TABLE}.card_identifier ;;
  }

  dimension: case_number {
    type: string
    sql: ${TABLE}.case_number ;;
  }

  dimension: chain_merchant_id {
    type: string
    sql: ${TABLE}.chain_merchant_id ;;
  }

  dimension: chargeback_id {
    type: string
    sql: ${TABLE}.chargeback_id ;;
  }

  dimension: chargeback_reason_code {
    type: string
    sql: ${TABLE}.chargeback_reason_code ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: deprecated {
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
    sql: ${TABLE}.deprecated_at ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension_group: exchange_date_added {
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
    sql: ${TABLE}.exchange_date_added ;;
  }

  dimension: merchant_id {
    type: string
    # hidden: yes
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
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.processed_date ;;
  }

  dimension: reference_id {
    type: string
    sql: ${TABLE}.reference_id ;;
  }

  dimension_group: transaction {
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
    sql: ${TABLE}.transaction_date ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}.transaction_type ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}.updated_at ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      merchant_name,
      merchant.id,
      merchant.tax_filing_name,
      merchant.legal_business_name,
      merchant.dba_name
    ]
  }
}

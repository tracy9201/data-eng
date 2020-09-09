view: fiserv_deposit_adjustment {
  sql_table_name: payfac.fiserv_deposit_adjustment ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: adjustment_id {
    type: string
    sql: ${TABLE}.adjustment_id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: api_response {
    type: string
    sql: ${TABLE}.api_response ;;
  }

  dimension: case_number {
    type: string
    sql: ${TABLE}.case_number ;;
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

  dimension_group: exchange_submit {
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
    sql: ${TABLE}.exchange_submit_date ;;
  }

  dimension: merchant_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.merchant_id ;;
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
    drill_fields: [id, merchant.id, merchant.tax_filing_name, merchant.legal_business_name, merchant.dba_name]
  }
}

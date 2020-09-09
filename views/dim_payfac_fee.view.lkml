view: dim_payfac_fee {
  sql_table_name: dwh.dim_payfac_fee ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension_group: end {
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
    sql: ${TABLE}.end_date ;;
  }

  dimension: fee {
    type: string
    sql: ${TABLE}.fee ;;
  }

  dimension: fee_basis {
    type: string
    sql: ${TABLE}.fee_basis ;;
  }

  dimension: fee_basis_calc {
    type: number
    sql: ${TABLE}.fee_basis_calc ;;
  }

  dimension: fee_type {
    type: string
    sql: ${TABLE}.fee_type ;;
  }

  dimension: fixed_rate {
    type: number
    sql: ${TABLE}.fixed_rate ;;
  }

  dimension: merchant_id {
    type: number
    sql: ${TABLE}.merchant_id ;;
  }

  dimension: percentage_rate {
    type: number
    sql: ${TABLE}.percentage_rate ;;
  }

  dimension: service_provider_id {
    type: number
    sql: ${TABLE}.service_provider_id ;;
  }

  dimension_group: start {
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
    sql: ${TABLE}.start_date ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

view: payfac_fee {
  sql_table_name: public.payfac_fee ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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

  dimension: Title_Fee_Detail{
    type: string
    sql: 'Fee Detail' ;;
    html:  <p style="text-align:left;padding-left:5px;font-weight: bold;color:#000000;font-size:100%"> Fee Detail </p>;;
  }


  dimension: fee_type {
    type: string
    sql: ${TABLE}.fee_type ;;
  }

  dimension: fee {
    type: string
    sql: ${TABLE}.fee ;;
  }

  dimension: fee_basis {
    type: string
    sql:${TABLE}.fee_basis ;;
  }

  dimension: fee_basis_calc {
    type: number
    sql:${TABLE}.fee_basis_calc ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  measure: total_fee {
    type: sum
    sql: ${TABLE}.fee_basis_calc * ${payfac_fee_basis.basis} ;;
    value_format: "$#,##0.00"
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

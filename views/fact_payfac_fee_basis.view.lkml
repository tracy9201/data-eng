view: fact_payfac_fee_basis {
  sql_table_name: dwh.fact_payfac_fee_basis ;;

  dimension: basis {
    type: number
    sql: ${TABLE}.basis ;;
  }

  dimension: basis_display {
    type: string
    sql: ${TABLE}.basis_display ;;
  }

  dimension: fee_type {
    type: string
    sql: ${TABLE}.fee_type ;;
  }

  dimension: merchant_id {
    type: string
    sql: ${TABLE}.merchant_id ;;
  }

  dimension_group: settlement {
    type: time
    timeframes: [
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.settlement_month ;;
  }


  measure: count {
    type: count
    drill_fields: []
  }
}

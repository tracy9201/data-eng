view: payfac_deposit_details {
  sql_table_name: public.payfac_deposit_details ;;

  dimension: adjustments {
    type: number
    sql: ${TABLE}.adjustments/100.0 ;;
  }

  dimension: chargebacks {
    type: number
    sql: ${TABLE}.chargebacks/100.0 ;;
  }

  dimension: charges {
    type: number
    sql: ${TABLE}.charges/100.0 ;;
  }

  dimension: merchant_id {
    type: number
    sql: ${TABLE}.merchant_id ;;
  }

  dimension: refunds {
    type: number
    sql: ${TABLE}.refunds/100.0 ;;
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


  dimension: transactions {
    type: number
    sql: ${TABLE}.transactions ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

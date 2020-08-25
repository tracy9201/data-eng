view: payfac_deposit_details {
  sql_table_name: public.payfac_deposit_details ;;

  dimension: adjustments {
    type: number
    sql: ${TABLE}.adjustments ;;
  }

  dimension: chargebacks {
    type: number
    sql: ${TABLE}.chargebacks ;;
  }

  dimension: charges {
    type: number
    sql: ${TABLE}.charges ;;
  }

  dimension: merchant_id {
    type: number
    sql: ${TABLE}.merchant_id ;;
  }

  dimension: refunds {
    type: number
    sql: ${TABLE}.refunds ;;
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

  dimension: settlement {
    type: string
    sql: ${TABLE}.settlement_month ;;
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

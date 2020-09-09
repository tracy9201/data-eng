view: fact_payfac_deposit_details {
  sql_table_name: dwh.fact_payfac_deposit_details ;;

  dimension: chargeback_transaction_amount {
    type: number
    sql: ${TABLE}.chargeback_transaction_amount ;;
  }

  dimension: chargeback_transaction_count {
    type: number
    sql: ${TABLE}.chargeback_transaction_count ;;
  }

  dimension: charges_transaction_amount {
    type: number
    sql: ${TABLE}.charges_transaction_amount ;;
  }

  dimension: charges_transaction_count {
    type: number
    sql: ${TABLE}.charges_transaction_count ;;
  }

  dimension: cnp_transaction_amount {
    type: number
    sql: ${TABLE}.cnp_transaction_amount ;;
  }

  dimension: cnp_transaction_count {
    type: number
    sql: ${TABLE}.cnp_transaction_count ;;
  }

  dimension: cp_transaction_amount {
    type: number
    sql: ${TABLE}.cp_transaction_amount ;;
  }

  dimension: cp_transaction_count {
    type: number
    sql: ${TABLE}.cp_transaction_count ;;
  }

  dimension_group: date {
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
    sql: ${TABLE}.date ;;
  }

  dimension: merchant_id {
    type: number
    sql: ${TABLE}.merchant_id ;;
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

  measure: adjustments {
    type: sum
    sql: ${TABLE}.adjustments/100.0 ;;
    value_format: "$#,##0.00"
  }

  measure: chargebacks {
    type: sum
    sql: ${TABLE}.chargebacks/100.0 ;;
    value_format: "$#,##0.00"
  }

  measure: charges {
    type: sum
    sql: ${TABLE}.charges/100.0 ;;
    value_format: "$#,##0.00"
  }

  measure: total_fee {
    type: sum
    sql:  ${TABLE}.total_fee;;
    value_format: "$#,##0.00"
  }



  measure: refunds {
    type: sum
    sql: ${TABLE}.refunds/100.0 ;;
    value_format: "$#,##0.00"
  }


}

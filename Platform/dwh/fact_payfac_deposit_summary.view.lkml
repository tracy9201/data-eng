view: fact_payfac_deposit_summary {
  sql_table_name: dwh.fact_payfac_deposit_summary ;;

  dimension: adjustments {
    type: number
    sql: ${TABLE}.adjustments ;;
  }

  dimension: chargeback_transaction_amount {
    type: number
    sql: ${TABLE}.chargeback_transaction_amount ;;
  }

  dimension: chargeback_transaction_count {
    type: number
    sql: ${TABLE}.chargeback_transaction_count ;;
  }

  dimension: chargebacks {
    type: number
    sql: ${TABLE}.chargebacks ;;
  }

  dimension: charges {
    type: number
    sql: ${TABLE}.charges ;;
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

  dimension: merchant_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.merchant_id ;;
  }

  dimension: range {
    type: string
    sql: ${TABLE}.range ;;
  }

  dimension: refunds {
    type: number
    sql: ${TABLE}.refunds ;;
  }

  dimension: setl_month {
    type: string
    sql: ${TABLE}.setl_month ;;
  }

  dimension_group: settlement_month {
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
    sql: ${TABLE}.settlement_month ;;
  }

  dimension: total_fee {
    type: number
    sql: ${TABLE}.total_fee ;;
  }

  dimension: transactions {
    type: number
    sql: ${TABLE}.transactions ;;
  }

  measure: count {
    type: count
    drill_fields: [merchant.id, merchant.tax_filing_name, merchant.legal_business_name, merchant.dba_name]
  }
}

view: fact_payfac_deposit_details {
  sql_table_name: dwh.fact_payfac_deposit_details ;;

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
    # hidden: yes
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

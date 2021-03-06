view: payfac_chargeback {
  sql_table_name: public.payfac_chargeback ;;

  measure: amount {
    type: sum
    sql: ${TABLE}.amount;;
    value_format: "$#,##0.00"
  }

  dimension: api_response {
    type: string
    sql: ${TABLE}.api_response ;;
  }

  dimension: card_brand {
    type: string
    sql: ${TABLE}.card_brand ;;
  }

  dimension: Title_chargebacks {
    type: string
    sql: 'Chargebacks' ;;
    html:  <p style="text-align:left;padding-left:5px;font-weight: bold;color:#000000;font-size:100%"> Chargebacks </p>;;
  }

  dimension: Chargeback_text {
    type: string
    sql: 'Chargeback  text' ;;
    html:  <p style="text-align:left;padding-left:5px;color:#1C1C1C;font-size:30%"> The below data represents Deposit Summary of each month. This shows data about transactions, Charges, refunds, Adjustments and any fee if applied </p>
      <p style="text-align:left;padding-left:5px;color:#1C1C1C;font-size:30%"> This may vary by each month. so keep any eye out for this text</p>;;
  }


  dimension: card_identifier {
    type: number
    value_format_name: id
    sql: ${TABLE}.card_identifier ;;
  }

  dimension: case_number {
    type: number
    sql: ${TABLE}.case_number ;;
  }

  dimension: chargeback_id {
    type: number
    sql: ${TABLE}.chargeback_id ;;
  }

  dimension: chargeback_reason_code {
    type: string
    sql: ${TABLE}.chargeback_reason_code ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension_group: exchange_date_added {
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
    sql: ${TABLE}.exchange_date_added ;;
  }

  dimension: merchant_id {
    type: number
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
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.processed_date ;;
  }

  dimension: reference_id {
    type: string
    sql: ${TABLE}.reference_id ;;
  }

  dimension: transaction_id {
    type: string
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: transaction_status {
    type: number
    sql: ${TABLE}.transaction_status ;;
  }

  dimension_group: transaction {
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
    sql: ${TABLE}.transaction_time ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}.transaction_type ;;
  }

  measure: count {
    type: count
    drill_fields: [merchant_name]
  }
}

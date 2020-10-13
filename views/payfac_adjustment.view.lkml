view: payfac_adjustment {
  sql_table_name: public.payfac_adjustment ;;

  dimension: adjustment_id {
    type: number
    sql: ${TABLE}.adjustment_id ;;
  }

  measure: amount {
    type: sum
    sql: ${TABLE}.amount ;;
    value_format: "$#,##0.00"
  }

  dimension: api_response {
    type: string
    sql: ${TABLE}.api_response ;;
  }

  dimension: Title_adjustments {
    type: string
    sql: 'Adjustments' ;;
    html:  <p style="text-align:left;padding-left:5px;font-weight: bold;color:#000000;font-size:100%"> Adjustments </p>;;
  }

  dimension: Adjustment_text {
    type: string
    sql: 'Adjustment text' ;;
    html:  <p style="text-align:left;padding-left:5px;color:#1C1C1C;font-size:30%"> The below data represents Deposit Summary of each month. This shows data about transactions, Charges, refunds, Adjustments and any fee if applied </p>
      <p style="text-align:left;padding-left:5px;color:#1C1C1C;font-size:30%"> This may vary by each month. so keep any eye out for this text</p>;;
  }

  dimension: case_number {
    type: number
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
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.exchange_date_added ;;
  }

  dimension_group: exchange_submit_added {
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
    sql: ${TABLE}.exchange_submit_added ;;
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
    drill_fields: [merchant_name]
  }
}

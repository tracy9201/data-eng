view: payfac_deposit_details {
  sql_table_name: public.payfac_deposit_details ;;

  measure: adjustments {
    type: sum
    sql: ${TABLE}.adjustments ;;
    value_format: "$#,##0.00"
  }

  measure: chargebacks {
    type: sum
    sql: ${TABLE}.chargebacks ;;
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

  dimension: Title_deposit_details {
    type: string
    sql: 'Deposit Detail' ;;
    html:  <p style="text-align:left;padding-left:5px;font-weight: bold;color:#000000;font-size:100%"> Deposit Detail </p>;;
  }

  dimension: deposit_details_text {
    type: string
    sql: 'deposit_details text' ;;
    html:  <p style="text-align:left;padding-left:5px;color:#1C1C1C;font-size:30%"> The below data represents Deposit Summary of each month. This shows data about transactions, Charges, refunds, Adjustments and any fee if applied </p>
      <p style="text-align:left;padding-left:5px;color:#1C1C1C;font-size:30%"> This may vary by each month. so keep any eye out for this text</p>;;
  }


  dimension: merchant_id {
    type: number
    sql: ${TABLE}.merchant_id ;;
  }

  measure: refunds {
    type: sum
    sql: ${TABLE}.refunds/100.0 ;;
    value_format: "$#,##0.00"
  }

  dimension_group: date {
    type: time
    label: "calendar"
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


  measure: transactions {
    type: sum
    sql: ${TABLE}.transactions ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }


}

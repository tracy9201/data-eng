view: payfac_deposit_details {
  sql_table_name: public.payfac_deposit_details ;;

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

  dimension: Title_deposit_details {
    type: string
    sql: 'Deposit Details' ;;
    html:  <p style="text-align:left;font-weight: bold;color:#684A91;font-size:120%"> Deposit Details </p>;;
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

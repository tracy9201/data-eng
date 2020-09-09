view: fact_payfac_deposit_summary {
  sql_table_name: dwh.fact_payfac_deposit_summary ;;


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

  dimension: merchant_id {
    type: number
    sql: ${TABLE}.merchant_id ;;
  }

  dimension: range {
    type: string
    sql: ${TABLE}.range ;;
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

  dimension: transactions {
    type: number
    sql: ${TABLE}.transactions ;;
  }

  dimension: Other_info{
    sql: ${TABLE}.merchant_id  ;;
    type: string
    html:
    <ul>
      <li><p style="text-align:left;padding-left:10px">Statement Periord&emsp;&emsp;{{range}}</p></li>
      <hr style="height:1px;border:none;color:#333;background-color:#333;" />
      <li> <p style="text-align:left;padding-left:10px">Merchant Number&emsp;&emsp;{{value}}</p> </li>
      <hr style="height:1px;border:none;color:#333;background-color:#333;" />
      <li><p style="text-align:left;padding-left:10px">Customer Service&emsp;&emsp;&ensp;Website - <a href="www.hintmd.com" target="_blank"  >www.hintmd.com</a></p></li>
      <li>&ensp;&ensp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Phone - 1-925-621-8866 </li>
    </ul> ;;
  }

  measure: refunds {
    type: sum
    sql: ${TABLE}.refunds/100.0 ;;
    value_format: "$#,##0.00"
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
}

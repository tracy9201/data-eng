view: payfac_deposit_summary {
  sql_table_name: public.payfac_deposit_summary ;;

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

  dimension: merchant_id {
    type: number
    sql: ${TABLE}.merchant_id ;;
  }

  dimension: range {
    type: string
    sql: ${TABLE}.range ;;
  }

#<li>Customer Service&emsp;&emsp;Website - <a href>www.hintmd.com</a> </li>
#<a href="https://www.w3schools.com">Visit W3Schools</a>
  dimension: Other_info{
    sql: ${TABLE}.merchant_id  ;;
    type: string
    html:
    <ul>
      <li><p style="text-align:left;padding-left:10px">Statement Periord&emsp;&emsp;{{range}}</p></li>
      <hr style="height:1px;border:none;color:#333;background-color:#333;" />
      <li> <p style="text-align:left;padding-left:10px">Merchant Number&emsp;&emsp;{{value}}</p> </li>
      <hr style="height:1px;border:none;color:#333;background-color:#333;" />
      <li><p style="text-align:left;padding-left:10px">Customer Service&emsp;&emsp;&ensp;Website - <a href="https://www.hintmd.com" target="_blank"  >www.hintmd.com</a></p></li>
      <li>&ensp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Phone - 1-925-621-8866 </li>
    </ul> ;;
  }

  measure: refunds {
    type: sum
    sql: ${TABLE}.refunds/100.0 ;;
    value_format: "$#,##0.00"
  }

  dimension: Title_deposit_summary {
    type: string
    sql: 'Deposit Summary' ;;
    html:  <p style="text-align:left;font-weight: bold;color:#684A91;font-size:120%"> Deposit Summary </p>;;
  }




  dimension: setl_month {
    type: string
    sql: ${TABLE}.setl_month ;;
  }

  dimension_group: settlement{
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: date
    sql: ${TABLE}.settlement_month;;
  }

  measure: transactions {
    type: sum
    sql: ${TABLE}.transactions ;;
  }

  measure: cp_transaction_amount {
    type: sum
    sql: ${TABLE}.cp_transaction_amount ;;
  }

  measure: cnp_transaction_amount {
    type: sum
    sql: ${TABLE}.cnp_transaction_amount ;;
  }

  measure: Charges_transaction_amount {
    type: sum
    sql: ${TABLE}.Charges_transaction_amount ;;
  }

  measure: Chargeback_transaction_amount {
    type: sum
    sql: ${TABLE}.Chargeback_transaction_amount ;;
  }


  measure: cp_transaction_count {
    type: sum
    sql: ${TABLE}.cp_transaction_count ;;
  }

  measure: cnp_transaction_count {
    type: sum
    sql: ${TABLE}.cnp_transaction_count ;;
  }

  measure: Charges_transaction_count {
    type: sum
    sql: ${TABLE}.Charges_transaction_count ;;
  }

  measure: Chargeback_transaction_count {
    type: sum
    sql: ${TABLE}.Chargeback_transaction_count ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

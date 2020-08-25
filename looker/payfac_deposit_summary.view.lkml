view: payfac_deposit_summary {
  sql_table_name: public.payfac_deposit_summary ;;

  dimension: adjustments {
    type: number
    sql: ${TABLE}.adjustments/100.0 ;;
  }

  dimension: chargebacks {
    type: number
    sql: ${TABLE}.chargebacks/100.0 ;;
  }

  dimension: charges {
    type: number
    sql: ${TABLE}.charges/100.0 ;;
  }

  dimension: merchant_id {
    type: number
    sql: ${TABLE}.merchant_id ;;
  }

  dimension: range {
    type: string
    sql: ${TABLE}.range ;;
  }

  dimension: Other_info{
    sql: ${TABLE}.merchant_id  ;;
    type: string
    html:
    <ul>
      <li>Statement Periord&emsp;&emsp;{{range}}</li>
      <hr style="height:1px;border:none;color:#333;background-color:#333;" />
      <li>Merchant Number&emsp;&emsp;{{ value }} <p style="text-align:left;"</p> </li>
      <hr style="height:1px;border:none;color:#333;background-color:#333;" />
      <li>Customer Service&emsp;&emsp;Website - www.hintmd.com </li>
      <li>&ensp;&ensp;&ensp;&ensp;&ensp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Phone - 1-925-621-8866 </li>
      <hr style="height:1px;border:none;color:#333;background-color:#333;" />
    </ul> ;;
  }

  dimension: refunds {
    type: number
    sql: ${TABLE}.refunds/100.0 ;;
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

  dimension: transactions {
    type: number
    sql: ${TABLE}.transactions ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

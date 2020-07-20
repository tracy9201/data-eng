view: batch_report_details {
  sql_table_name: external_reporting_qa.payment_summary ;;

  measure: count {
    type: count
    drill_fields: [detail*]
  }



  measure: sum_amount {
    type: sum
    sql: coalesce(${sales_amount},0) ;;
    value_format: "$#,##0.00"
    label: "Total amount"
    html: <div  style="text-align:right;font-size:100%;number-format='$#,##0' ">{{ rendered_value }}</div> ;;
  }

  measure: sum_tipping_amount {
    type: sum
    sql: ${gratuity_amount} ;;
    label: "Total Tipping Amount"
    value_format: "$#,##0.00"
  }



  dimension: sales_type {
    type: string
    label: "Payment Method"
    case: {
      when:  {
        sql: ${TABLE}.sales_type = 'cash' and (${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'refund%') ;;
        label: "CASH"
      }
      when:  {
        sql: ${TABLE}.sales_type = 'check' and (${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'refund%') ;;
        label: "CHECK"
      }
      when:  {
        sql: ${TABLE}.sales_type = 'credit_card' and (${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'refund%') ;;
        label: "CREDIT CARD"
      }
      when:  {
        sql: ${TABLE}.sales_type = 'provider credit' and(${TABLE}.sales_id like 'credit%' or ${TABLE}.sales_id like 'refund%');;
        label: "PRACTICE CREDIT"
      }
      when:  {
        sql: ${TABLE}.sales_type in ('reward', 'credit') and ${TABLE}.sales_name = 'BD Payment'
          and (${TABLE}.sales_id like 'credit%' or ${TABLE}.sales_id like 'refund%');;
        label: "BD"
      }
      when:  {
        sql: ${TABLE}.sales_type in ('credit', 'reward') and (${TABLE}.sales_id like 'credit%' or ${TABLE}.sales_id like 'refund%');;
        label: "OTHER"
      }
      when:  {
        sql: ${TABLE}.sales_type ='credit_card' and (${TABLE}.sales_id like 'tran%' ) ;;
        label: "RECURRING PMT"
      }

      when: {
        sql: ${transaction} = 'VOID' and ${payment_method} in('VISA','AMEX','MASTERCARD','DISCOVER','OTHER CREDIT CARD') ;;
        label: "CREDIT CARD"
      }

    }
  }


  dimension: transaction {
    type: string
    case: {
      when: {
        sql: ${TABLE}.sales_id like 'refund%' ;;
        label: "REFUND"
      }
      when: {
        sql: ${TABLE}.sales_id like 'credit%'  and  ${TABLE}.sales_type in ('reward', 'credit') and ${TABLE}.sales_name = 'BD Payment' ;;
        label: "OFFER REDEMPTION"
      }

      when: {
        sql:  ${TABLE}.sales_id like 'credit%'  and  ${TABLE}.sales_type = 'provider credit'  ;;
        label: "DEPOSIT FROM PATIENT"
      }
      when: {
        sql: ${TABLE}.sales_id like 'void%'  ;;
        label: "VOID"
      }

      else: "SALE"
    }
  }

  dimension: payment_method {
    type: string
    label: "Payment Detail"
    case: {
      when:  {
        sql: ${TABLE}.sales_type = 'cash' ;;
        label: "CASH"
      }
      when:  {
        sql: ${TABLE}.sales_type = 'check' ;;
        label: "CHECK"
      }
      when:  {
        sql: ${TABLE}.sales_type = 'credit_card' and ${card_first_2_digits} like '4%' ;;
        label: "VISA"
      }
      when:  {
        sql: ${TABLE}.sales_type = 'credit_card' and (${card_first_2_digits} like '34%' or ${card_first_2_digits} like '37%') ;;
        label: "AMEX"
      }
      when:  {
        sql: ${TABLE}.sales_type = 'credit_card' and (${card_first_2_digits} like '51%' or ${card_first_2_digits} like '52%' or ${card_first_2_digits} like '53%' or ${card_first_2_digits} like '54%' or ${card_first_2_digits} like '55%') ;;
        label: "MASTERCARD"
      }
      when:  {
        sql: ${TABLE}.sales_type = 'credit_card' and (${card_first_2_digits} like '60%' or ${card_first_2_digits} like '65%') ;;
        label: "DISCOVER"
      }
      when:  {
        sql: ${TABLE}.sales_type = 'credit_card' and (${card_first_2_digits} not like '4%' or ${card_first_2_digits} not like '34%' or ${card_first_2_digits} not like '37%' or ${card_first_2_digits} not like '51%' or ${card_first_2_digits} not like '52%' or ${card_first_2_digits} not like '53%' or ${card_first_2_digits} not like '54%' or ${card_first_2_digits} not like '55%' or ${card_first_2_digits} not like '60%' or ${card_first_2_digits} not like '65%') ;;
        label: "OTHER CREDIT CARD"
      }
      when:  {
        sql: ${TABLE}.sales_type = 'reward' ;;
        label: "REWARD"
      }
      when:  {
        sql: ${TABLE}.sales_type = 'provider credit' ;;
        label: "PRACTICE CREDIT"
      }
      when:  {
        sql: ${TABLE}.sales_type = 'adjustment' ;;
        label: "ADJUSTMENT"
      }
      when:  {
        sql: ${TABLE}.sales_type = 'credit' ;;
        label: "COUPON"
      }
      when:  {
        sql: ${TABLE}.sales_type = 'reward' ;;
        label: "REWARD"
      }
      when:  {
        sql: ${TABLE}.sales_type in ('reward', 'credit') and ${TABLE}.sales_name = 'BD';;
        label: "BD"
      }
    }
  }

  dimension: sales_id {
    type: string
    sql: ${TABLE}.sales_id ;;
    primary_key: yes
  }


  dimension: sales_name {
    type: string
    sql: ${TABLE}.sales_name ;;
  }

  dimension: sales_amount {
    type: number
    sql: CASE WHEN ${transaction} = 'REFUND' then coalesce((-1*${TABLE}.sales_amount)/100,0)
          WHEN ${transaction} = 'VOID' then coalesce((-1*${TABLE}.sales_amount)/100,0)
          ELSE coalesce(${TABLE}.sales_amount/100,0) end ;;
    label: "Amount"
    value_format: "$#,##0.00"
  }


  dimension: sales_status {
    type: number
    sql: ${TABLE}.sales_status ;;
  }

  dimension_group: sales_created_at {
    type: time
    sql: case when (${sales_id} like 'void1%' or ${sales_id} like 'void2%')  then ${TABLE}.sales_created_at + INTERVAL '1 DAY' else ${TABLE}."sales_created_at" END ;;
    timeframes: [date, week, month, year, hour12, minute, hour,time,time_of_day,hour_of_day]
    label: "Date & Time"
  }

  dimension_group: sales_created_at_MM_DD_YYYY {
    type: time
    sql: case when (${sales_id} like 'void1%' or ${sales_id} like 'void2%') then ${TABLE}.sales_created_at + INTERVAL '1 DAY' else ${TABLE}."sales_created_at" END ;;
    timeframes: [date, week, month, year, hour12, minute, hour,time,time_of_day,hour_of_day]
    label: "Sales Date"
    html: {{ rendered_value | date: "%m/%d/%Y" }} ;;
  }



  dimension: sales_created_at_Hr_n_Min {
    type: string
    sql:  ${sales_created_at_time_of_day} ;;
    label: "Time "
    html: {{ rendered_value | date: "%I:%M %p" }} ;;
  }



  dimension: gx_customer_id {
    type: string
    sql: ${TABLE}.gx_customer_id ;;
  }

  dimension: gx_provider_id {
    type: string
    sql: ${TABLE}.gx_provider_id ;;
  }

  dimension: payment_id {
    type: string
    sql: case when ${sales_type} = 'CREDIT CARD' or ${payment_method} in('OTHER CREDIT CARD','VISA','AMEX','MASTERCARD','DISCOVER') then CONCAT('**** ',cast(${TABLE}.payment_id as VARCHAR))
              when ${sales_type} = 'CHECK' then ${TABLE}.payment_id
              when ${sales_type} = 'RECURRING PMT' and ${TABLE}.sales_type = 'credit_card' then ${TABLE}.payment_id
              else null end ;;
  }

  dimension: description {
    type: string
    sql: case when ${sales_type} in ('CHECK', 'CREDIT CARD', 'BD') then null
          when ${sales_type} = 'RECURRING PMT' and ${TABLE}.sales_type = 'credit_card' then null
          else ${TABLE}.payment_id end ;;
  }

  dimension: sales_details {
    type: string
    sql: case when ${sales_created_at_date} IS NOT NULL then 'Sales Details' else NULL end ;;
    html:  <p style="text-align:center;color:black;font-size:155%"> Payment Details </p>
      <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
  }


  dimension: tokenization {
    type: string
    sql: ${TABLE}.tokenization;;
  }

  dimension: card_first_2_digits {
    type: string
    sql: substring(${TABLE}.tokenization,2,2) ;;
    label: "card_first_2_digits"
  }

  dimension: category {
    type: string
    sql: case when (${sales_id} like 'void1%' or ${sales_id} like 'void2%') and ${is_voided} = 'Yes'  then 'BAD' else 'GOOD' end ;;

  }

  dimension: staff_user_id {
    type: string
    sql: ${TABLE}.staff_user_id ;;
  }

  dimension: device_id {
    type: string
    sql: ${TABLE}.device_id ;;
  }

  dimension: sales_date {
    type: number
    sql: ${TABLE}.sales_date ;;
  }

  dimension: invoice_id {
    type: number
    sql: ${TABLE}.invoice_id ;;
  }

  dimension: gx_plan_id {
    type: string
    sql: ${TABLE}.gx_plan_id ;;

  }

  dimension: transaction_id {
    type: string
    sql: ${TABLE}.transaction_id ;;

  }

  dimension: gx_subscription_id {
    type: string
    sql: ${TABLE}.gx_subscription_id ;;

  }

  dimension: is_voided {
    type: string
    case: {
      when: {
        sql: ${TABLE}.is_voided in ('t', 'true')  ;;
        label: "Yes"
      }

      when: {
        sql: ${TABLE}.is_voided in ('f', 'false');;
        label: "No"
      }
      else: "No"
    }
    label: "Void"
  }

  dimension: gratuity_amount {
    type: number
    sql: round(cast(${TABLE}.gratuity_amount as numeric)/100,2) ;;
    label: "Tipping Amount"
    value_format: "$#,##0.00"
  }

  dimension: Total_subscription_payment_tile {
    type: string
    sql: 'Recurring PMT';;
    html:  <p style="text-align:center;color:black;font-size:155%"> Total Subscription Payments </p>
      <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
  }

  dimension: Total_tip_payment_tile {
    type: string
    sql: 'Tip PMT';;
    html:  <p style="text-align:center;color:black;font-size:155%"> Total Tip Payments </p>
      <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
  }

  set: detail {
    fields: [
      sales_id,
      sales_name,
      sales_amount,
      sales_status,
      #sales_created_at,
      gx_customer_id,
      gx_provider_id,
      payment_id,
      device_id,
      staff_user_id
    ]
  }
}

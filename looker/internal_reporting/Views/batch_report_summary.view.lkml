
  view: batch_report_summary {
    sql_table_name: external_reporting_qa.payment_summary ;;

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    measure: countTest {
      type: count
      label: " "
      html: <p style="text-align:left;font-weight: bold;color:white;font-size:80%"> {{ rendered_value }} Transactions</p>;;
    }

    measure: sum_amount {
      type: sum
      sql: coalesce(${sales_amount}+${gratuity_amount},0);;
      value_format: "$#,##0.00"
      label: "Total"
      html: <div  style="text-align:center;font-size:250%;number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    }

    measure:sum_total_retail {
      type: sum
      sql: case when ${TABLE}.sales_type in ('cash','check','credit_card','credit','reward','provider credit')
          and (${TABLE}.sales_id like 'credit%' or ${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'refund%' or ${TABLE}.sales_id like 'void%')
         then (coalesce(${sales_amount},0)+coalesce(${gratuity_amount},0)) end;;
      value_format: "$#,##0.00"
      label: "Total Retail Tile"
      html:  <p style="text-align:center;font-weight: bold;color:black;font-size:160%"> TOTAL RETAIL </p>
        <div  style="text-align:center;font-size:260%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    }

    measure: sum_amount_tile {
      type: sum
      sql: case when ${TABLE}.sales_type in ('cash','check','credit_card','credit','reward','provider credit')
          and (${TABLE}.sales_id like 'credit%' or ${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'refund%' or ${TABLE}.sales_id like 'tran%' or ${TABLE}.sales_id like 'void%')
         then (coalesce(${sales_amount},0)+coalesce(${gratuity_amount},0))
        end;;
        value_format: "$#,##0.00"
        label: "Total amount Tile"
        html:  <p style="text-align:center;font-weight: bold;color:black;font-size:160%"> GRAND TOTAL </p>
          <div  style="text-align:center;font-size:260%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_cash {
        type: sum
        sql: case when ${sales_type} = 'CASH' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Total Cash"
        value_format: "$#,##0.00"
        html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> CASH
            <span style = "height: 15px;width: 15px;background-color: #43B772;border-radius: 50%;display: inline-block>"</span></p>
              <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_check {
        type: sum
        sql: case when ${sales_type} = 'CHECK' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Total Check"
        value_format: "$#,##0.00"
        html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> CHECK
            <span style = "height: 15px;width: 15px;background-color: #FFD452;border-radius: 50%;display: inline-block>"</span></p>
              <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_credit_card {
        type: sum
        sql: case when ${sales_type} = 'CREDIT CARD' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Total Credit Card"
        value_format: "$#,##0.00"
        html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> CREDIT CARD
            <span style = "height: 15px;width: 15px;background-color: #4194FB;border-radius: 50%;display: inline-block>"</span></p>
              <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_BD {
        type: sum
        sql: case when ${sales_type} = 'BD' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Total BD"
        value_format: "$#,##0.00"
        html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> BD
            <span style = "height: 15px;width: 15px;background-color: #654054;border-radius: 50%;display: inline-block>"</span></p>
              <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_practice_credit {
        type: sum
        sql: case when ${sales_type} = 'PRACTICE CREDIT' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Total Practice Credit"
        value_format: "$#,##0.00"
        html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> PRACTICE CREDIT
            <span style = "height: 15px;width: 15px;background-color: #F1654F;border-radius: 50%;display: inline-block>"</span></p>
              <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_other {
        type: sum
        sql: case when ${sales_type} = 'OTHER' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Total Others"
        value_format: "$#,##0.00"
        html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> OTHER
            <span style = "height: 15px;width: 15px;background-color: #0064B2;border-radius: 50%;display: inline-block>"</span></p>
              <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_tipping_amount {
        type: sum
        sql: coalesce(${gratuity_amount},0) ;;
        label: "Total Tipping Amount"
        value_format: "$#,##0.00"
        html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> TIPS
            <span style = "height: 15px;width: 15px;background-color: #0B6121;border-radius: 50%;display: inline-block>"</span></p>
            <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_subscription_amount {
        type: sum
        sql: case when ${sales_type} = 'RECURRING PMT' then coalesce(${sales_amount},0) else 0 end;;
        value_format: "$#,##0.00"
        label: "RECURRING PMT"

        html:    <p style="text-align:center;font-weight: bold;color:black;font-size:140%"> TOTAL RECURRING</p>
          <div  style="text-align:center;font-size:260%; number-format='$#,##0' ">{{ rendered_value }}</div>;;
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
            sql: ${TABLE}.sales_type = 'credit_card' and (${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'refund%' or ${TABLE}.sales_id like 'void%') ;;
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
            label: "AMERICAN EXPRESS"
          }
          when:  {
            sql: ${TABLE}.sales_type = 'credit_card' and (${card_first_2_digits} like '51%' or ${card_first_2_digits} like '52%' or ${card_first_2_digits} like '53%' or ${card_first_2_digits} like '54%' or ${card_first_2_digits} like '55%') ;;
            label: "MASTER CARD"
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
        sql:${TABLE}.sales_id ;;
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
        sql: case when (${sales_id} like 'void1%' or ${sales_id} like 'void2%') then ${TABLE}.sales_created_at + INTERVAL '1 DAY' else ${TABLE}."sales_created_at" END ;;
        timeframes: [date, week, month, year, hour12, minute, hour,time,time_of_day,hour_of_day]
        label: "Date & Time"
      }

      dimension_group: gateway_created_at {
        type: time
        sql: case when (${sales_id} like 'void1%' or ${sales_id} like 'void2%') then ${TABLE}.gateway_created_at + INTERVAL '1 DAY' else ${TABLE}."gateway_created_at" END ;;
        timeframes: [date, week, month, year, hour12, minute, hour,time,time_of_day,hour_of_day]
        label: "Date & Time"
      }

      dimension_group: sales_created_at_MM_DD_YYYY {
        type: time
        sql: case when (${sales_id} like 'void1%' or ${sales_id} like 'void2%')  then ${TABLE}.sales_created_at + INTERVAL '1 DAY' else ${TABLE}."sales_created_at" END ;;
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
        sql: case when ${sales_type} = 'CREDIT CARD' or ${payment_method} in('OTHER CREDIT CARD','VISA','AMEX','MASTERCARD','DISCOVER') then CONCAT('**** ',cast(${TABLE}.payment_id as VARCHAR)) else ${TABLE}.payment_id end ;;
      }

      dimension: sales_details {
        type: string
        sql: case when ${sales_created_at_date} IS NOT NULL then 'Sales Details' else NULL end ;;
        html:  <p style="text-align:center;color:black;font-size:155%"> Payment Details </p>
          <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
      }

      dimension: Total_sales_tile {
        type: string
        sql: 'Total Sales';;
        html:  <p style="text-align:center;color:black;font-size:155%"> Total Payments </p>
          <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
      }

      dimension: Sales_by_payment_method_tile {
        type: string
        sql: 'Sales By Payment Method' ;;
        html:  <p style="text-align:center;color:black;font-size:140%"> Transaction Count by Payment Method </p>
          <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
      }

      dimension: Total_subscription_payment_tile {
        type: string
        sql: 'Total Subscription Payment';;
        html:  <p style="text-align:center;color:black;font-size:155%"> Total Subscription Payments </p>
          <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
      }

      dimension: Total_tip_payment_tile {
        type: string
        sql: 'Total Tip Payment';;
        html:  <p style="text-align:center;color:black;font-size:155%"> Total Tip Payments </p>
          <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
      }

      dimension: Funding_details_Tile {
        type: string
        sql: 'Fund Details';;
        html:  <p style="text-align:center;color:black;font-size:120%"> Deposit Summary </p>
          <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
      }

      dimension: Note_Tile {
        type: string
        sql: 'Fund Details';;
        html:  <p style="text-align:right;color:#97999B;font-size:35%;margin-top:3%;margin-right:2%"> Note: Data is refreshed hourly. A maximum of 1000 entries are shown. </p>;;

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
        label: "Terminal ID"
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
        sql:round(cast(${TABLE}.gratuity_amount as numeric)/100,2) ;;
        label: "Tip"
        value_format: "$#,##0.00"
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
        ]
      }

    }

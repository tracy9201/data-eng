view: payment_summary {
  sql_table_name: dwh_hint.fact_payment_summary ;;

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: countTest {
    type: count
    #drill_fields: [detail*]
    label: " "
    html: <p style="text-align:left;font-weight: bold;color:white;font-size:80%"> {{ rendered_value }} Transactions</p>;;
  }

  measure: sum_amount {
    type: sum
    sql: coalesce(${sales_amount}+${gratuity_amount},0);;
    value_format: "$#,##0.00"
    label: "Total"
    # html:
    # <div  style="text-align:center;font-size:140%;number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    html: <div  style="text-align:center;font-size:250%;number-format='$#,##0' ">{{ rendered_value }}</div> ;;
  }

  measure:sum_total_retail {
    type: sum
    sql: case when ${TABLE}.sales_type in ('cash','check','credit_card','credit','reward','provider credit')
          and (${TABLE}.sales_id like 'credit%' or ${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'refund%')
         then (coalesce(${sales_amount},0)+coalesce(${gratuity_amount},0)) end;;
    value_format: "$#,##0.00"
    label: "Total Retail Tile"
    # html:
    # <div  style="text-align:center;font-size:140%;number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    html:  <p style="text-align:center;font-weight: bold;color:black;font-size:160%"> TOTAL RETAIL </p>
      <div  style="text-align:center;font-size:260%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
  }

  measure: sum_amount_tile {
    type: sum
    sql: case when ${TABLE}.sales_type in ('cash','check','credit_card','credit','reward','provider credit')
          and (${TABLE}.sales_id like 'credit%' or ${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'refund%')
         then (coalesce(${sales_amount},0)+coalesce(${gratuity_amount},0))
        when ${TABLE}.sales_type = 'credit_card' and ${TABLE}.sales_id like 'tran%' and ${kronos_subscription.type} in (1,2)
          then coalesce(${gate_amount},0)
        end;;
    #sql:  case when ${kronos_subscription.type} = 0 then ${sales_amount} else 0 end ;;
      value_format: "$#,##0.00"
      label: "Total amount Tile"
      #html: <div style="text-align:center;font-size:250%;number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      html:  <p style="text-align:center;font-weight: bold;color:black;font-size:160%"> GRAND TOTAL </p>
        <div  style="text-align:center;font-size:260%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    }

    measure: sum_cash {
      type: sum
      #sql: ${cash}/100 ;;
      sql: case when ${retail_sales_type} = 'CASH' then coalesce(${sales_amount},0) else 0 end ;;
      label: "Total Cash"
      value_format: "$#,##0.00"
      html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> CASH
            <span style = "height: 15px;width: 15px;background-color: #43B772;border-radius: 50%;display: inline-block>"</span></p>
              <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    }

    measure: sum_check {
      type: sum
      sql: case when ${retail_sales_type} = 'CHECK' then coalesce(${sales_amount},0) else 0 end ;;
      label: "Total Check"
      value_format: "$#,##0.00"
      html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> CHECKS
            <span style = "height: 15px;width: 15px;background-color: #FFD452;border-radius: 50%;display: inline-block>"</span></p>
              <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    }

    measure: sum_credit_card {
      type: sum
      sql: case when ${retail_sales_type} = 'CREDIT CARD' then coalesce(${sales_amount},0) else 0 end ;;
      label: "Total Credit Card"
      value_format: "$#,##0.00"
      html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> CREDIT CARDS
            <span style = "height: 15px;width: 15px;background-color: #4194FB;border-radius: 50%;display: inline-block>"</span></p>
              <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    }

    measure: sum_BD {
      type: sum
      sql: case when ${retail_sales_type} = 'BD' then coalesce(${sales_amount},0) else 0 end ;;
      label: "Total BD"
      value_format: "$#,##0.00"
      html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> BD
            <span style = "height: 15px;width: 15px;background-color: #654054;border-radius: 50%;display: inline-block>"</span></p>
              <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    }

    measure: sum_practice_credit {
      type: sum
      sql: case when ${retail_sales_type} = 'PRACTICE CREDIT' then coalesce(${sales_amount},0) else 0 end ;;
      label: "Total Practice Credit"
      value_format: "$#,##0.00"
      html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> PRACTICE CREDIT
            <span style = "height: 15px;width: 15px;background-color: #F1654F;border-radius: 50%;display: inline-block>"</span></p>
              <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    }

    measure: sum_other {
      type: sum
      sql: case when ${retail_sales_type} = 'OTHER' then coalesce(${sales_amount},0) else 0 end ;;
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
      sql: case when ${TABLE}.sales_type in ('cash','check','credit_card','credit','reward','provider credit')
          and (${TABLE}.sales_id like 'credit%' or ${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'refund%' or ${TABLE}.sales_id like 'tran%')
          and ${kronos_subscription.type} in (1,2) then coalesce(${sales_amount},0) end;;
      value_format: "$#,##0.00"
      label: "RECURRING PMT"

      html:    <p style="text-align:center;font-weight: bold;color:black;font-size:140%"> TOTAL SUBSCRIPTION</p>
            <p style="text-align:center;font-weight: bold;color:black;font-size:140%"> AND INSTALLMENT </p>
              <div  style="text-align:center;font-size:260%; number-format='$#,##0' ">{{ rendered_value }}</div>;;
    }

    measure: sum_RETAIL_CHARGES_RELATED_TO_SUBSCRIPTIONS {
      type: sum
      #sql: coalesce(${sales_amount},0) ;;
      sql: case when ${gateway_sales_type} = 'RETAIL CHARGES RELATED TO SUBSCRIPTIONS' then coalesce(${gate_amount},0) end ;;
      value_format: "$#,##0.00"
      label: "RETAIL CHARGES RELATED TO SUBSCRIPTIONS"

      html:    <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> RETAIL CHARGES </p>
              <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> RELATED TO SUBSCRIPTIONS </p>
              <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div>;;
    }

    measure: sum_MONTHLY_CHARGES {
      type: sum
      #sql: coalesce(${sales_amount},0) ;;
      sql: case when ${gateway_sales_type} = 'MONTHLY CHARGES' then coalesce(${gate_amount},0) end ;;
      value_format: "$#,##0.00"
      label: "MONTHLY CHARGES"

      html:    <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> MONTHLY CHARGES </p>
        <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div>;;
    }

    dimension: retail_sales_type {
      type: string
      label: "Payment Method"
      case: {
        when:  {
          sql: ${TABLE}.sales_type = 'cash' and (${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'refund%');;
          label: "CASH"
        }
        when:  {
          sql: ${TABLE}.sales_type = 'check' and (${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'refund%');;
          label: "CHECK"
        }
        when:  {
          sql: ${TABLE}.sales_type = 'credit_card' and (${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'refund%');;
          label: "CREDIT CARD"
        }
        when:  {
          sql: ${TABLE}.sales_type = 'provider credit' and (${TABLE}.sales_id like 'credit%' or ${TABLE}.sales_id like 'refund%');;
          label: "PRACTICE CREDIT"
        }
        when:  {
          sql: ${TABLE}.sales_type in ('reward', 'credit') and ${TABLE}.sales_name = 'BD Payment' and ${TABLE}.sales_id like 'credit%';;
          label: "BD"
        }
        when:  {
          sql: ${TABLE}.sales_type in ('credit', 'reward') and (${TABLE}.sales_id like 'credit%' or ${TABLE}.sales_id like 'refund%');;
          label: "OTHER"
        }
      }
    }

    dimension: sales_amount {
      type: number
      #sql: case when ${transaction} = ‘REFUND’ then coalesce(round(cast((-1.0*${TABLE}.sales_amount)/100 as numeric),2),0)  else coalesce(round(cast((1.0*${TABLE}.sales_amount)/100 as numeric),2),0)  end ;;
      #sql: CASE WHEN ${transaction} = 'REFUND' then coalesce((-1*${TABLE}.sales_amount)/100,0) WHEN ${transaction} = 'REFUND - VOIDED' then coalesce((-1*${TABLE}.sales_amount)/100,0) WHEN ${transaction} = 'PURCHASE - VOIDED' then coalesce((-1*${TABLE}.sales_amount)/100,0) else coalesce(${TABLE}.sales_amount/100,0) end ;;
      sql: CASE WHEN ${transaction} = 'REFUND' then coalesce((-1*${TABLE}.sales_amount2)/100,0) WHEN ${transaction} = 'REFUND - VOIDED' then coalesce((-1*${TABLE}.sales_amount2)/100,0) WHEN ${transaction} = 'PURCHASE - VOIDED' then coalesce((-1*${TABLE}.sales_amount2)/100,0) else coalesce(${TABLE}.sales_amount2/100,0) end ;;
      label: "Amount"
      value_format: "$#,##0.00"
    }

    dimension: gateway_sales_type {
      type: string
      label: "Payment Method2"
      case: {
        when:  {
          sql: ${TABLE}.sales_type = 'credit_card' and ${TABLE}.sales_id like 'tran%' and ${kronos_subscription.type} in (1,2);;
          label: "MONTHLY CHARGES"
        }
        when:  {
          sql: (${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'credit%') and ${TABLE}.sales_type not in ('adjustment') and ${kronos_subscription.type} in (1,2) ;;
          label: "RETAIL CHARGES RELATED TO SUBSCRIPTIONS"
        }
      }
    }

    dimension: gate_amount {
      type: number
      #sql: case when ${transaction} = ‘REFUND’ then coalesce(round(cast((-1.0*${TABLE}.sales_amount)/100 as numeric),2),0)  else coalesce(round(cast((1.0*${TABLE}.sales_amount)/100 as numeric),2),0)  end ;;
      #sql: CASE WHEN ${transaction} = 'REFUND' then coalesce((-1*${TABLE}.sales_amount)/100,0) WHEN ${transaction} = 'REFUND - VOIDED' then coalesce((-1*${TABLE}.sales_amount)/100,0) WHEN ${transaction} = 'PURCHASE - VOIDED' then coalesce((-1*${TABLE}.sales_amount)/100,0) else coalesce(${TABLE}.sales_amount/100,0) end ;;
      sql: CASE WHEN ${transaction} = 'REFUND' then coalesce((-1*${TABLE}.gate_amount)/100,0) WHEN ${transaction} = 'REFUND - VOIDED' then coalesce((-1*${TABLE}.gate_amount)/100,0) WHEN ${transaction} = 'PURCHASE - VOIDED' then coalesce((-1*${TABLE}.gate_amount)/100,0) else coalesce(${TABLE}.gate_amount/100,0) end ;;
      label: "Gate_Amount"
      value_format: "$#,##0.00"
    }

    dimension: sales_type {
      type: string
      label: "Payment Method"
      case: {
        when:  {
          sql: ${TABLE}.sales_type = 'cash' and ((${customer2.user_type} = 1) or (${customer2.user_type} = 0 and ${kronos_subscription.type} = 0));;
          label: "CASH"
        }
        when:  {
          sql: ${TABLE}.sales_type = 'check' and ((${customer2.user_type} = 1) or (${customer2.user_type} = 0 and ${kronos_subscription.type} = 0)) ;;
          label: "CHECK"
        }
        when:  {
          sql: ${TABLE}.sales_type = 'credit_card' and ((${customer2.user_type} = 1) or (${customer2.user_type} = 0 and ${kronos_subscription.type} = 0)) ;;
          label: "CREDIT CARD"
        }
        when:  {
          sql: ${TABLE}.sales_type = 'provider credit' and ((${customer2.user_type} = 1) or (${customer2.user_type} = 0 and ${kronos_subscription.type} = 0));;
          label: "PRACTICE CREDIT"
        }
        when:  {
          sql: ${TABLE}.sales_type in ('reward', 'credit') and ${TABLE}.sales_name = 'BD Payment'
            and ((${customer2.user_type} = 1) or (${customer2.user_type} = 0 and ${kronos_subscription.type} = 0));;
          label: "BD"
        }
        when:  {
          sql: ${TABLE}.sales_type in ('credit', 'reward') and ((${customer2.user_type} = 1) or (${customer2.user_type} = 0 and ${kronos_subscription.type} = 0));;
          label: "OTHER"
        }
        when:  {
          sql: ${TABLE}.sales_type ='credit_card' and (${kronos_subscription.type} in (1,2) and ${customer2.user_type} = 0) ;;
          label: "RECURRING PMT"
        }
      }
    }


    dimension: transaction {
      type: string
      case: {
        when: {
          sql: ${TABLE}.sales_id like 'refund%';;
          label: "REFUND"
        }
        when: {
          sql: ${TABLE}.sales_type in ('reward', 'credit') and ${TABLE}.sales_name = 'BD Payment';;
          #sql: ${TABLE}.sales_name like 'BD Payment' and ${TABLE}.sales_type = 'reward';;
          label: "OFFER REDEMPTION"
        }

        when: {
          sql:  ${TABLE}.sales_type = 'provider credit' ;;
          label: "DEPOSIT FROM PATIENT"
        }
        when: {
          sql: ${TABLE}.sales_id like 'void%'  ;;
          label: "VOIDED"
        }

        when: {
          sql: ${kronos_subscription.type} in (1,2) ;;
          label: "SUBSCRIPTION FEE"
        }
        else: "SALES"
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
      sql: ${TABLE}.sales_id ;;
      primary_key: yes
    }

    # dimension: customer_id {
    #   type: number
    #   sql: ${TABLE}.customer_id ;;
    # }

    # dimension: provider_id {
    #   type: number
    #   sql: ${TABLE}.provider_id ;;
    # }

    dimension: sales_name {
      type: string
      sql: ${TABLE}.sales_name ;;
    }

#   dimension: sales_amount {
#     type: number
#     #sql: coalesce(${TABLE}.sales_amount/100, 0) ;;
#     sql: case when ${transaction} = 'REFUND' then coalesce((-1*${TABLE}.sales_amount)/100,0) else coalesce(${TABLE}.sales_amount/100,0) end ;;
#     label: "Amount"
#     value_format: "$#,##0.00"
#   }

    dimension: sales_amount1 {
      type: number
      #sql: case when ${transaction} = ‘REFUND’ then coalesce(round(cast((-1.0*${TABLE}.sales_amount)/100 as numeric),2),0)  else coalesce(round(cast((1.0*${TABLE}.sales_amount)/100 as numeric),2),0)  end ;;
      #sql: CASE WHEN ${transaction} = 'REFUND' then coalesce((-1*${TABLE}.sales_amount)/100,0) WHEN ${transaction} = 'REFUND - VOIDED' then coalesce((-1*${TABLE}.sales_amount)/100,0) WHEN ${transaction} = 'PURCHASE - VOIDED' then coalesce((-1*${TABLE}.sales_amount)/100,0) else coalesce(${TABLE}.sales_amount/100,0) end ;;
      sql: CASE WHEN ${transaction} = 'REFUND' then coalesce((-1*${TABLE}.sales_amount)/100,0) WHEN ${transaction} = 'REFUND - VOIDED' then coalesce((-1*${TABLE}.sales_amount)/100,0) WHEN ${transaction} = 'PURCHASE - VOIDED' then coalesce((-1*${TABLE}.sales_amount)/100,0) else coalesce(${TABLE}.sales_amount/100,0) end ;;
      label: "Amount"
      value_format: "$#,##0.00"
    }


    dimension: sales_status {
      type: number
      sql: ${TABLE}.sales_status ;;
    }

    dimension_group: sales_created_at {
      type: time
      #sql: ${TABLE}.sales_created_at ;;
      sql: case when ${sales_id} like 'void%' then ${TABLE}.sales_created_at + INTERVAL '1 DAY' else ${TABLE}."sales_created_at" END ;;
      timeframes: [date, week, month, year, hour12, minute, hour,time,time_of_day,hour_of_day]
      label: "Date & Time"
    }

    dimension_group: gateway_created_at {
      type: time
      #sql: ${TABLE}.gateway_created_at ;;
      sql: case when ${sales_id} like 'void%' then ${TABLE}.gateway_created_at + INTERVAL '1 DAY' else ${TABLE}."gateway_created_at" END ;;
      timeframes: [date, week, month, year, hour12, minute, hour,time,time_of_day,hour_of_day]
      label: "Date & Time"
    }

    dimension_group: sales_created_at_MM_DD_YYYY {
      type: time
      #sql: ${TABLE}.sales_created_at ;;
      sql: case when ${sales_id} like 'void%' then ${TABLE}.sales_created_at + INTERVAL '1 DAY' else ${TABLE}."sales_created_at" END ;;
      timeframes: [date, week, month, year, hour12, minute, hour,time,time_of_day,hour_of_day]
      label: "Sales Date"
      html: {{ rendered_value | date: "%m/%d/%Y" }} ;;
    }





    dimension: sales_created_at_Hr_n_Min {
      type: string
      #sql: substring(${sales_created_at_minute},12,5) ;;
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

    # dimension: external_id {
    #   type: string
    #   sql: ${TABLE}.external_id ;;
    # }

    # dimension: transaction_id {
    #   type: string
    #   sql: ${TABLE}.transaction_id ;;
    # }

    dimension: payment_id {
      type: string
      #sql:  ${TABLE}.payment_id ;;
      sql: case when ${sales_type} = 'CREDIT CARD' then CONCAT('**** ',cast(${TABLE}.payment_id as VARCHAR)) else ${TABLE}.payment_id end ;;
      #html: {% if {{ practice_sales.payment_method._value }} == 'CREDIT CARD' %}
      #<p style="text-align:center;margin-left:20%;margin-top:6%">****<span>{{rendered_value}} </span></p>
      #{% else %}
      #<p style="text-align:center;margin-left:20%;margin-top:6%">{{rendered_value}}</p>
      #{% endif %}
      #;;
    }

    dimension: sales_details {
      type: string
      sql: case when ${sales_created_at_date} IS NOT NULL then 'Sales Details' else NULL end ;;
      html:  <p style="text-align:center;color:black;font-size:155%"> Payment Details </p>
        <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
    }

    dimension: Total_sales_tile {
      type: string
      #sql: case when ${sales_created_at_date} IS NOT NULL then 'Total Sales' else NULL end ;;
      sql: 'Total Sales';;
      html:  <p style="text-align:center;color:black;font-size:155%"> Total Payments </p>
        <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
    }

    dimension: Sales_by_payment_method_tile {
      type: string
      #sql: case when ${sales_created_at_date} IS NOT NULL then 'Sales By Payment Method' else NULL end ;;
      sql: 'Sales By Payment Method' ;;
      html:  <p style="text-align:center;color:black;font-size:140%"> Transaction Count by Payment Methods </p>
        <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
    }

    dimension: Total_subscription_payment_tile {
      type: string
      #sql: case when ${sales_created_at_date} IS NOT NULL then 'Total Sales' else NULL end ;;
      sql: 'Total Subscription Payment';;
      html:  <p style="text-align:center;color:black;font-size:155%"> Total Subscription Payments </p>
        <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
    }

    dimension: Total_tip_payment_tile {
      type: string
      #sql: case when ${sales_created_at_date} IS NOT NULL then 'Total Sales' else NULL end ;;
      sql: 'Total Tip Payment';;
      html:  <p style="text-align:center;color:black;font-size:155%"> Total Tip Payments </p>
        <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
    }

    dimension: Funding_details_Tile {
      type: string
      #sql: case when ${sales_created_at_date} IS NOT NULL then 'Sales By Payment Method' else NULL end ;;
      sql: 'Fund Details';;

      html:  <p style="text-align:center;color:black;font-size:120%"> Deposit Summary </p>

              <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
    }

    dimension: Note_Tile {
      type: string
      #sql: case when ${sales_created_at_date} IS NOT NULL then 'Sales By Payment Method' else NULL end ;;
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
      sql: case when ${sales_id} is not null then 'GOOD' else 'BAD' end ;;

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
      type: number
      sql: cast(${TABLE}.is_voided as numeric(2,0)) ;;
    }

    dimension: gratuity_amount {
      type: number
      sql: ${TABLE}.gratuity_amount ;;
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

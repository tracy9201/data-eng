view: batch_report_summary {
  sql_table_name: dwh_opul.fact_payment_summary ;;

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
          and (${TABLE}.sales_id like 'credit%' or ${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'refund%' or ${TABLE}.sales_id like 'void%')
         then (coalesce(${sales_amount},0)+coalesce(${gratuity_amount},0)) end;;
    value_format: "$#,##0.00"
    label: "Total Retail Tile"
    # html:
    # <div  style="text-align:center;font-size:140%;number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    html:  <p style="text-align:center;color:black; font-weight: bold;font-size:180%;vertical-align: text-top"> TOTAL RETAIL </p>
      <div  style="text-align:center;font-size:230%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
  }

  measure: sum_amount_tile {
    type: sum
    sql: case when ${TABLE}.sales_type in ('cash','check','credit_card','credit','reward','provider credit')
            and (${TABLE}.sales_id like 'credit%' or ${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'refund%' or ${TABLE}.sales_id like 'tran%' or ${TABLE}.sales_id like 'void%')
           then (coalesce(${sales_amount},0)+coalesce(${gratuity_amount},0))
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
      sql: case when ${sales_type} = 'CASH' then coalesce(${sales_amount},0)+coalesce(${gratuity_amount},0) else 0 end ;;
      label: "Total Cash"
      value_format: "$#,##0.00"
      html:  <p style="text-align:center;color:black;font-size:120%"> Cash </p>
        <div  style="text-align:center;font-size:120%;color:#6F6F6F; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    }

    measure: sum_check {
      type: sum
      sql: case when ${sales_type} = 'CHECK' then coalesce(${sales_amount},0)+coalesce(${gratuity_amount},0) else 0 end ;;
      label: "Total Check"
      value_format: "$#,##0.00"
      html:  <p style="text-align:center;color:black;font-size:120%"> Check </p>
        <div  style="text-align:center;font-size:120%;color:#6F6F6F; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    }

    measure: sum_credit_card {
      type: sum
      sql: case when ${sales_type} = 'CREDIT CARD' then coalesce(${sales_amount},0)+coalesce(${gratuity_amount},0) else 0 end ;;
      label: "Total Credit Card"
      value_format: "$#,##0.00"
      html:  <p style="text-align:center;color:black;font-size:120%"> Credit Card </p>
        <div  style="text-align:center;font-size:120%;color:#6F6F6F; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
    }

    ##### Added for PD-801 10/13/2020 #####

    dimension: data_by_device {
      type: string
      sql: case when ${sales_created_at_date} IS NOT NULL then 'Total by Device' else NULL end ;;
      html:  <p style="text-align:center;color:black;font-size:140%"> Total by Device </p>
        <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
    }

    dimension: data_by_card_brand {
      type: string
      sql: case when ${sales_created_at_date} IS NOT NULL then 'Total by Card Brand' else NULL end ;;
      html:  <p style="text-align:center;color:black;font-size:140%"> Total by Credit Card Type </p>
        <div  style="text-align:center; number-format='$#,##0';color:white;font-size:10% ">{{ rendered_value }}</div> ;;
    }

    dimension: Blank_tile {
      type: string
      label: "Blank"
      sql: case when ${sales_created_at_date} IS NOT NULL then ' ' else NULL end ;;
      html:  <hr style="height:1px;border:none;color:#333;background-color:#333;" />;;
    }

    measure: sum_amount_tile_test {
      type: sum
      sql: case when ${TABLE}.sales_type in ('cash','check','credit_card','credit','reward','provider credit')
            and (${TABLE}.sales_id like 'credit%' or ${TABLE}.sales_id like 'payment%' or ${TABLE}.sales_id like 'refund%' or ${TABLE}.sales_id like 'tran%' or ${TABLE}.sales_id like 'void%')
           then (coalesce(${sales_amount},0)+coalesce(${gratuity_amount},0))
          end;;
    #sql:  case when ${kronos_subscription.type} = 0 then ${sales_amount} else 0 end ;;
        value_format: "$#,##0.00"
        label: "Total amount Tile TEST"
        #html: <div style="text-align:center;font-size:250%;number-format='$#,##0' ">{{ rendered_value }}</div> ;;
        # html:  <p style="text-align:center;font-weight: bold;color:black;font-size:160%"> GRAND TOTAL </p>
        #   <div  style="text-align:center;font-size:260%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_credit_card_test {
        type: sum
        sql: case when ${sales_type} = 'CREDIT CARD' then coalesce(${sales_amount},0)+coalesce(${gratuity_amount},0) else 0 end ;;
        label: "Total Credit Card TEST"
        value_format: "$#,##0.00"
        # html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> CREDIT CARD
        #         <span style = "height: 15px;width: 15px;background-color: #4194FB;border-radius: 50%;display: inline-block>"</span></p>
        #           <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_cash_test {
        type: sum
        #sql: ${cash}/100 ;;
        sql: case when ${sales_type} = 'CASH' then coalesce(${sales_amount},0)+coalesce(${gratuity_amount},0) else 0 end ;;
        label: "Total Cash TEST"
        value_format: "$#,##0.00"
        # html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> CASH
        #         <span style = "height: 15px;width: 15px;background-color: #43B772;border-radius: 50%;display: inline-block>"</span></p>
        #           <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_check_test {
        type: sum
        sql: case when ${sales_type} = 'CHECK' then coalesce(${sales_amount},0)+coalesce(${gratuity_amount},0) else 0 end ;;
        label: "Total Check TEST"
        value_format: "$#,##0.00"
        # html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> CHECK
        #         <span style = "height: 15px;width: 15px;background-color: #FFD452;border-radius: 50%;display: inline-block>"</span></p>
        #           <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_BD_test {
        type: sum
        sql: case when ${sales_type} = 'BD' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Total BD TEST"
        value_format: "$#,##0.00"
        # html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> BD
        #         <span style = "height: 15px;width: 15px;background-color: #654054;border-radius: 50%;display: inline-block>"</span></p>
        #           <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_practice_credit_test {
        type: sum
        sql: case when ${sales_type} = 'PRACTICE CREDIT' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Total Practice Credit TEST"
        value_format: "$#,##0.00"
        # html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> PRACTICE CREDIT
        #         <span style = "height: 15px;width: 15px;background-color: #F1654F;border-radius: 50%;display: inline-block>"</span></p>
        #           <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_other_test{
        type: sum
        sql: case when ${sales_type} = 'OTHER' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Total Others TEST"
        value_format: "$#,##0.00"
        # html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> OTHER
        #         <span style = "height: 15px;width: 15px;background-color: #0064B2;border-radius: 50%;display: inline-block>"</span></p>
        #           <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_visa {
        type: sum
        sql: case when ${sales_type} = 'CREDIT CARD' and ${payment_method} = 'Visa' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Visa"
        value_format: "$#,##0.00"
        html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> Visa
            <span style = "height: 15px;width: 15px;background-color: #4194FB;border-radius: 50%;display: inline-block>"</span></p>
              <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_master_card{
        type: sum
        sql: case when ${sales_type} = 'CREDIT CARD' and ${payment_method} = 'Master Card' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Master Card"
        value_format: "$#,##0.00"
        html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> Master Card
              <span style = "height: 15px;width: 15px;background-color: #4194FB;border-radius: 50%;display: inline-block>"</span></p>
                <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_discover{
        type: sum
        sql: case when ${sales_type} = 'CREDIT CARD' and ${payment_method} = 'Discover' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Discover"
        value_format: "$#,##0.00"
        html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> Discover
              <span style = "height: 15px;width: 15px;background-color: #4194FB;border-radius: 50%;display: inline-block>"</span></p>
                <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_american_express{
        type: sum
        sql: case when ${sales_type} = 'CREDIT CARD' and ${payment_method} = 'AMEX' then coalesce(${sales_amount},0) else 0 end ;;
        label: "AMEX"
        value_format: "$#,##0.00"
        html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> AMERICAN EXPRESS
              <span style = "height: 15px;width: 15px;background-color: #4194FB;border-radius: 50%;display: inline-block>"</span></p>
                <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_other_credit_card{
        type: sum
        sql: case when ${sales_type} = 'CREDIT CARD' and ${payment_method} = 'All Other Cards' then coalesce(${sales_amount},0) else 0 end ;;
        label: "All Other Cards"
        value_format: "$#,##0.00"
        html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> All Other Cards
              <span style = "height: 15px;width: 15px;background-color: #4194FB;border-radius: 50%;display: inline-block>"</span></p>
                <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_visa_test {
        type: sum
        sql: case when ${sales_type} = 'CREDIT CARD' and ${payment_method} = 'Visa' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Visa TEST"
        value_format: "$#,##0.00"
        # html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> VISA
        #         <span style = "height: 15px;width: 15px;background-color: #4194FB;border-radius: 50%;display: inline-block>"</span></p>
        #           <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_master_card_test{
        type: sum
        sql: case when ${sales_type} = 'CREDIT CARD' and ${payment_method} = 'Master Card' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Master Card TEST"
        value_format: "$#,##0.00"
        # html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> MASTER CARD
        #           <span style = "height: 15px;width: 15px;background-color: #4194FB;border-radius: 50%;display: inline-block>"</span></p>
        #             <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_discover_test{
        type: sum
        sql: case when ${sales_type} = 'CREDIT CARD' and ${payment_method} = 'Discover' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Discover TEST"
        value_format: "$#,##0.00"
        # html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> DISCOVER
        #           <span style = "height: 15px;width: 15px;background-color: #4194FB;border-radius: 50%;display: inline-block>"</span></p>
        #             <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_american_express_test{
        type: sum
        sql: case when ${sales_type} = 'CREDIT CARD' and ${payment_method} = 'AMEX' then coalesce(${sales_amount},0) else 0 end ;;
        label: "AMEX TEST"
        value_format: "$#,##0.00"
        # html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> AMERICAN EXPRESS
        #           <span style = "height: 15px;width: 15px;background-color: #4194FB;border-radius: 50%;display: inline-block>"</span></p>
        #             <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_other_credit_card_test{
        type: sum
        sql: case when ${sales_type} = 'CREDIT CARD' and ${payment_method} = 'All Other Cards' then coalesce(${sales_amount},0) else 0 end ;;
        label: "All Other Cards TEST"
        value_format: "$#,##0.00"
        # html:  <p style="text-align:center;font-weight: bold;color:black;font-size:80%"> OTHER CREDIT CARD
        #           <span style = "height: 15px;width: 15px;background-color: #4194FB;border-radius: 50%;display: inline-block>"</span></p>
        #             <div  style="text-align:center;font-size:130%; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }


      ##########################################

      measure: sum_BD {
        type: sum
        sql: case when ${sales_type} = 'BD' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Total BD"
        value_format: "$#,##0.00"
        html:  <p style="text-align:center;color:black;font-size:120%"> BD </p>
          <div  style="text-align:center;font-size:120%;color:#6F6F6F;number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_practice_credit {
        type: sum
        sql: case when ${sales_type} = 'PRACTICE CREDIT' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Total Practice Credit"
        value_format: "$#,##0.00"
        html:  <p style="text-align:center;color:black;font-size:120%"> Practice Credit </p>
          <div  style="text-align:center;font-size:120%;color:#6F6F6F; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
      }

      measure: sum_other {
        type: sum
        sql: case when ${sales_type} = 'OTHER' then coalesce(${sales_amount},0) else 0 end ;;
        label: "Total Others"
        value_format: "$#,##0.00"
        html:  <p style="text-align:center;color:black;font-size:120%"> Other </p>
          <div  style="text-align:center;font-size:120%;color:#6F6F6F; number-format='$#,##0' ">{{ rendered_value }}</div> ;;
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

        html:    <p style="text-align:center;font-weight: bold;color:black;font-size:160%"> TOTAL RECURRING</p>
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
            label: "Visa"
          }
          when:  {
            sql: ${TABLE}.sales_type = 'credit_card' and (${card_first_2_digits} like '34%' or ${card_first_2_digits} like '37%') ;;
            label: "AMEX"
          }
          when:  {
            sql: ${TABLE}.sales_type = 'credit_card' and (${card_first_2_digits} like '51%' or ${card_first_2_digits} like '52%' or ${card_first_2_digits} like '53%' or ${card_first_2_digits} like '54%' or ${card_first_2_digits} like '55%') ;;
            label: "Master Card"
          }
          when:  {
            sql: ${TABLE}.sales_type = 'credit_card' and (${card_first_2_digits} like '60%' or ${card_first_2_digits} like '65%') ;;
            label: "Discover"
          }
          when:  {
            sql: ${TABLE}.sales_type = 'credit_card' and (${card_first_2_digits} not like '4%' or ${card_first_2_digits} not like '34%' or ${card_first_2_digits} not like '37%' or ${card_first_2_digits} not like '51%' or ${card_first_2_digits} not like '52%' or ${card_first_2_digits} not like '53%' or ${card_first_2_digits} not like '54%' or ${card_first_2_digits} not like '55%' or ${card_first_2_digits} not like '60%' or ${card_first_2_digits} not like '65%') ;;
            label: "All Other Cards"
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
        #sql: ${TABLE}.sales_created_at ;;
        sql: case when (${sales_id} like 'void1%' or ${sales_id} like 'void2%') then ${TABLE}.sales_created_at + INTERVAL '1 DAY' else ${TABLE}."sales_created_at" END ;;
        timeframes: [date, week, month, year, hour12, minute, hour,time,time_of_day,hour_of_day]
        label: "Date & Time"
      }

      dimension_group: gateway_created_at {
        type: time
        #sql: ${TABLE}.gateway_created_at ;;
        sql: case when (${sales_id} like 'void1%' or ${sales_id} like 'void2%') then ${TABLE}.gateway_created_at + INTERVAL '1 DAY' else ${TABLE}."gateway_created_at" END ;;
        timeframes: [date, week, month, year, hour12, minute, hour,time,time_of_day,hour_of_day]
        label: "Date & Time"
      }

      dimension_group: sales_created_at_MM_DD_YYYY {
        type: time
        #sql: ${TABLE}.sales_created_at ;;
        sql: case when (${sales_id} like 'void1%' or ${sales_id} like 'void2%')  then ${TABLE}.sales_created_at + INTERVAL '1 DAY' else ${TABLE}."sales_created_at" END ;;
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
        sql: case when ${sales_type} = 'CREDIT CARD' or ${payment_method} in('OTHER CREDIT CARD','VISA','AMEX','MASTERCARD','DISCOVER') then CONCAT('**** ',cast(${TABLE}.payment_id as VARCHAR)) else ${TABLE}.payment_id end ;;
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
        html:  <p style="text-align:center;color:black;font-size:140%"> Transaction Count by Payment Method </p>
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

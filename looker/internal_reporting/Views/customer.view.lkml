view: customer {

  sql_table_name: external_reporting_qa.customer ;;

    dimension: gx_customer_id {
      primary_key: yes
      type: string
      sql: ${TABLE}.gx_customer_id ;;
    }

    dimension: customer_birth_year {
      type: number
      sql: ${TABLE}.customer_birth_year ;;
    }

    dimension: customer_city {
      type: string
      sql: ${TABLE}.customer_city ;;
    }

    dimension: customer_email {
      type: string
      sql: ${TABLE}.customer_email ;;
    }

    dimension: customer_gender {
      type: number
      sql: ${TABLE}.customer_gender ;;
    }

    dimension: customer_mobile {
      type: string
      #sql: ${TABLE}.customer_mobile ;;
      #sql: coalesce('(' || substring(${TABLE}.customer_mobile,3,3) || ') ' || substring(${TABLE}.customer_mobile,6,3) || '-' || substring(${TABLE}.customer_mobile,9,4) ,' ');;
      sql: CASE WHEN ${TABLE}.customer_mobile IS NULL or ${TABLE}.customer_mobile = '' then ${TABLE}.customer_mobile else '(' || substring(${TABLE}.customer_mobile,3,3) || ') ' || substring(${TABLE}.customer_mobile,6,3) || '-' || substring(${TABLE}.customer_mobile,9,4)  END;;

    }

    dimension: firstname {
      type: string
      sql: coalesce(${TABLE}.firstname,' ') ;;
      #sql: CASE WHEN ${TABLE}.customer_type = 1 THEN 'Guest Checkout' WHEN ${TABLE}.customer_type = 0  THEN  ${TABLE}.customer_name ELSE 'Not Available' END;;
      #sql:  CASE WHEN ${TABLE}.${customer_type} = 1 THEN 'GUEST Checkout' WHEN ${settlement_funding.settlement_id} like 'adjustment%' THEN 'Not Applicable' WHEN ${TABLE}.customer_type = 0 then ${TABLE}.customer_name ELSE 'Not Available' END;;
      label: "First Name"
    }

    dimension: lastname {
      type: string
      sql: coalesce(${TABLE}.lastname,' ') ;;
      #sql: CASE WHEN ${TABLE}.customer_type = 1 THEN 'Guest Checkout' WHEN ${TABLE}.customer_type = 0  THEN  ${TABLE}.customer_name ELSE 'Not Available' END;;
      #sql:  CASE WHEN ${TABLE}.${customer_type} = 1 THEN 'GUEST Checkout' WHEN ${settlement_funding.settlement_id} like 'adjustment%' THEN 'Not Applicable' WHEN ${TABLE}.customer_type = 0 then ${TABLE}.customer_name ELSE 'Not Available' END;;
      label: "Last Name"
    }

    dimension: customer_name {
      type: string
      #sql: concat(${firstname},' ',${lastname}) ;;
      sql: ${firstname} + ' ' + ${lastname} ;;
      label: "Name"
    }

    dimension: customer_state {
      type: string
      sql: ${TABLE}.customer_state ;;
    }

    dimension: member_type {
      type: string

      #sql: coalesce(${TABLE}.customer_type,'non-member') ;;
      #sql: coalesce(${TABLE}.customer_type,'Non-Member') ;;

      label: "Subscriber"
      # html:
      # {% if value == 'member' %}
      # <p style="align:center;height: 5px;width: 5px;background-color: #9478BA;border-radius: 25%;display: inline-block;margin-left:50%;margin-top:4%"></p>
      # {% elsif value == 'non-member' %}
      # <p style="text-align:center;margin-top:12%"> </p>
      # {% else %}
      # <p style="text-align:center;margin-top:12%"> </p>
      # {% endif %}
      # ;;
      case: {
        when: {
          sql: ${TABLE}.member_type = 'member' ;;
          label: "Member"
        }
        else: "Non-Member"
      }
    }

    dimension: customer_zip {
      type: string
      sql: ${TABLE}.customer_zip ;;
    }

    dimension: customer_type {
      type: string
      #sql: case when ${TABLE}.user_type = 1 then 'Guest' when ${TABLE}.user_type =0 then ${TABLE}.customer_type end;;
      sql: case when ${TABLE}.user_type = 1 then 'Guest' when ${TABLE}.user_type =0 then ${member_type} end;;
    }

    dimension: user_type {
      type: number
      sql: ${TABLE}.user_type ;;
    }

    dimension: k_customer_id {
      type: number
      sql: ${TABLE}.k_customer_id ;;
    }

    dimension_group: member_cancel {
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
      sql: ${TABLE}.member_cancel_date ;;
    }

    dimension_group: member_on_boarding {
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
      sql: ${TABLE}.member_on_boarding_date ;;
    }

    dimension: staff_name {
      type: string
      sql: ${TABLE}.staff_name ;;
      label: "Staff Member"
    }

    ## Added below for daily batch details table ##
    dimension: subscriber {
      type: string
      #sql: coalesce(${TABLE}.customer_name,' ') ;;
      #sql: coalesce(${TABLE}.customer_type,'non-member') ;;
      sql: CASE WHEN ${TABLE}.user_type = 1 THEN 'Guest' WHEN ${TABLE}.member_type = 'member'  THEN  'Subscriber' WHEN  ${TABLE}.member_type = 'non-member' THEN 'Non-Subscriber' ELSE 'Guest' END;;
      #sql:  CASE WHEN ${TABLE}.${customer_type} = 1 THEN 'GUEST Checkout' WHEN ${settlement_funding.settlement_id} like 'adjustment%' THEN 'Not Applicable' WHEN ${TABLE}.customer_type = 0 then ${TABLE}.customer_name ELSE 'Not Available' END;;
      label: "Subscriber Type"
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

# ----- Sets of fields for drilling ------
    set: detail {
      fields: [
        gx_customer_id,
        customer_name,
        staff_name,
        card.count,
        master_id_table.count,
        practice_sales.count,
        v4_g_plan.count
      ]
    }




  }

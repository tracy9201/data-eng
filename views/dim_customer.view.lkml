view: dim_customer {
  sql_table_name: dwh.dim_customer ;;

  dimension: customer_birth_year {
    type: string
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
    sql: CASE WHEN ${TABLE}.customer_mobile IS NULL or ${TABLE}.customer_mobile = '' then ${TABLE}.customer_mobile else '(' || substring(${TABLE}.customer_mobile,3,3) || ') ' || substring(${TABLE}.customer_mobile,6,3) || '-' || substring(${TABLE}.customer_mobile,9,4)  END;;
  }

  dimension: customer_state {
    type: string
    sql: ${TABLE}.customer_state ;;
  }

  dimension: customer_type {
    type: string
    #sql: ${TABLE}.customer_type ;;
    sql: CASE WHEN ${TABLE}.user_type = 1 THEN 'Guest' WHEN ${TABLE}.customer_type = 'member'  THEN  'Subscriber' WHEN  ${TABLE}.customer_type = 'non-member' THEN 'Non-Subscriber' ELSE 'Guest' END;;

  }

  dimension: customer_zip {
    type: string
    sql: ${TABLE}.customer_zip ;;
  }

  dimension: firstname {
    type: string
    sql: ${TABLE}.firstname ;;
  }

  dimension: gx_customer_id {
    type: string
    sql: ${TABLE}.gx_customer_id ;;
  }

  dimension: k_customer_id {
    type: number
    sql: ${TABLE}.k_customer_id ;;
  }

  dimension: lastname {
    type: string
    sql: ${TABLE}.lastname ;;
  }

  dimension: member_cancel_date {
    type: string
    sql: ${TABLE}.member_cancel_date ;;
  }

  dimension: member_on_boarding_date {
    type: string
    sql: ${TABLE}.member_on_boarding_date ;;
  }

  dimension: user_type {
    type: number
    sql: ${TABLE}.user_type ;;
  }

  measure: count {
    type: count
    drill_fields: [lastname, firstname]
  }
}

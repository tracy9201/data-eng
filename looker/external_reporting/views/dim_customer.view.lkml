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
    sql: CASE WHEN ${fact_invoice_item.id} like '%sub%' and ${TABLE}.customer_mobile IS NULL THEN ' ' ELSE ${TABLE}.customer_mobile END  ;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#808080"><i>{{ rendered_value }}</i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;

  }

  dimension: customer_state {
    type: string
    sql: ${TABLE}.customer_state ;;
  }

  dimension: customer_type {
    type: string

    sql: CASE WHEN ${fact_invoice_item.id} like '%sub%' and ${TABLE}.customer_type IS NULL THEN ' ' ELSE ${TABLE}.customer_type END  ;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#808080"><i>{{ rendered_value }}</i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;

  }

  dimension: customer_zip {
    type: string
    sql: ${TABLE}.customer_zip ;;
  }

  dimension: firstname {
    type: string

    sql: CASE WHEN ${fact_invoice_item.id} like '%sub%' and ${TABLE}.firstname IS NULL THEN ' ' ELSE ${TABLE}.firstname END  ;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#808080"><i>{{ rendered_value }}</i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
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

    sql: CASE WHEN ${fact_invoice_item.id} like '%sub%' and ${TABLE}.lastname IS NULL THEN ' ' ELSE ${TABLE}.lastname END  ;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#808080"><i>{{ rendered_value }}</i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
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

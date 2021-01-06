view: dim_offering {
  sql_table_name: dwh_hint.dim_offering ;;

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: gx_subscription_id {
    type: string
    sql: ${TABLE}.gx_subscription_id ;;
  }

  dimension: product_service {
    type: string
    sql: ${TABLE}.product_service ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: subscription_status {
    type: number
    sql: ${TABLE}.subscription_status ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }


}

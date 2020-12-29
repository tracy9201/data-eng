view: kronos_subscription {
  sql_table_name: dwh_hint.dim_kronos_subscription ;;

  dimension: cycles {
    type: number
    sql: ${TABLE}.cycles ;;
  }

  dimension: gx_subscription_id {
    type: string
    sql: ${TABLE}.gx_subscription_id ;;
  }

  dimension: is_subscription {
    type: yesno
    sql: ${TABLE}.is_subscription ;;
  }

  dimension: offering_id {
    type: number
    sql: ${TABLE}.offering_id ;;
  }

  dimension: period {
    type: number
    sql: ${TABLE}.period ;;
  }

  dimension: period_unit {
    type: number
    sql: ${TABLE}.period_unit ;;
  }

  dimension: plan_id {
    type: number
    sql: ${TABLE}.plan_id ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: status {
    type: number
    sql: ${TABLE}.status ;;
  }

  dimension: subscription_id {
    type: number
    sql: ${TABLE}.subscription_id ;;
  }

  dimension: type {
    type: number
    sql: ${TABLE}.type ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

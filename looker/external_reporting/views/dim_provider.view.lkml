view: dim_provider {
  sql_table_name: dwh.dim_provider ;;

  dimension: gx_provider_id {
    type: string
    sql: ${TABLE}.gx_provider_id ;;
  }

  dimension: k_practice_id {
    type: number
    sql: ${TABLE}.k_practice_id ;;
  }

  dimension_group: practice_activated {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.practice_activated_at ;;
  }

  dimension: practice_city {
    type: string
    sql: ${TABLE}.practice_city ;;
  }

  dimension: practice_name {
    type: string
    sql: ${TABLE}.practice_name ;;
  }

  dimension: practice_state {
    type: string
    sql: ${TABLE}.practice_state ;;
  }

  dimension: practice_time_zone {
    type: string
    sql: ${TABLE}.practice_time_zone ;;
  }

  dimension: practice_zip {
    type: string
    sql: ${TABLE}.practice_zip ;;
  }

  measure: count {
    type: count
    drill_fields: [practice_name]
  }
}

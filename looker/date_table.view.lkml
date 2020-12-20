view: date_table {
  sql_table_name: public.date_table ;;

  dimension_group: date {
    type: time
    label: "calendar"
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
    sql: ${TABLE}.date ;;
  }

  dimension: day {
    type: number
    sql: ${TABLE}.day ;;
  }

  dimension: dow {
    type: number
    sql: ${TABLE}.dow ;;
  }

  dimension: doy {
    type: number
    sql: ${TABLE}.doy ;;
  }

  dimension: month {
    type: number
    sql: ${TABLE}.month ;;
  }

  dimension: quarter {
    type: number
    sql: ${TABLE}.quarter ;;
  }

  dimension: week {
    type: number
    sql: ${TABLE}.week ;;
  }

  dimension: year {
    type: number
    sql: ${TABLE}.year ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

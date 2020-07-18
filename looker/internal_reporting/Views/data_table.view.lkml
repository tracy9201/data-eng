view: date_table {
  sql_table_name: external_reporting_qa.date_table ;;

  dimension_group: date {
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
    # link: {
    #   label: "TEST"
    #   #url: "https://hintmdqa.looker.com/dashboards/looker_hintmd::Deposit_Details?Funding_master_id={{ value }}"
    #   url:  "https://www.google.com/"
    #   icon_url: "https://looker.com/favicon.ico"

    # }
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

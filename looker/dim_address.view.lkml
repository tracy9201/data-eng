view: dim_address {
  sql_table_name: public.dim_address ;;

  dimension_group: activated {
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
    sql: ${TABLE}.activated_at ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: deprecated {
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
    sql: ${TABLE}.deprecated_at ;;
  }

  dimension: full_address {
    type: string
    sql: ${TABLE}.full_address ;;
  }


  dimension: full_address1{
    sql: ${TABLE}.street1  ;;
    type: string
    html:
    <ul>
      <li> {{ value }} </li>
      <li> {{ street2._value }} </li>
      <li> {{ city._value }} </li>
      <li> {{ state._value }} </li>
      <li> {{ zip._value }} </li>
    </ul> ;;
  }

  dimension: live {
    type: yesno
    sql: ${TABLE}.live ;;
  }

  dimension: merchant_id {
    type: number
    sql: ${TABLE}.merchant_id ;;
  }

  dimension: merchant_name {
    type: string
    sql: ${TABLE}.merchant_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: status {
    type: number
    sql: ${TABLE}.status ;;
  }

  dimension: street1 {
    type: string
    sql: ${TABLE}.street1 ;;
  }

  dimension: street2 {
    type: string
    sql: ${TABLE}.street2 ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}.updated_at ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [merchant_name]
  }
}

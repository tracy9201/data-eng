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
    sql: ${TABLE}.merchant_name  ;;
    type: string
    html:
    <ul>
      <li> <b> <p style="text-align:left;padding-left:10px;font-size:1.5vw"> {{ value }}  </p> </b> </li>
      <li> <p style="text-align:left;padding-left:10px;font-size:1vw"> {{ street1._value }} </p> </li>
      <li> <p style="text-align:left;padding-left:10px;font-size:1vw"> {{ street2._value }} </p> </li>
      <li> <p style="text-align:left;padding-left:10px;font-size:1vw"> {{ city._value }}  </p></li>
      <li> <p style="text-align:left;padding-left:10px;font-size:1vw"> {{ state._value }} - {{ zip._value }}  </p> </li>
    </ul> ;;
  }

  dimension: your_processing_statement{
    sql: 'Your Card Processing Statement'   ;;
    type: string
    html:
    <ul>
      <li><p style="text-align:left;padding-left:10px;font-size:2vw">Your Card Processing Statement</p></li
    </ul> ;;
  }


  dimension: Hint_Address{
    sql: ${TABLE}.merchant_name  ;;
    type: string
    html:
    <ul>
      <li><p style="text-align:left;padding-left:10px;font-size:0.75vw">7901 Stoneridge Dr #150, Pleasanton, CA 94588</p></li
    </ul> ;;
  }
#<li><p style="text-align:left;padding-left:10px">Statement Periord&emsp;&emsp;{{range}}</p></li>
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

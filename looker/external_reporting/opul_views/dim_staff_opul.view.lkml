view: dim_staff_opul {
  derived_table: {
    sql:
      select
        staff_data.id,
        staff_data.created_at,
        staff_data.updated_at,
        staff_data.deprecated_at,
        staff_data.status,
        user_id,
        commission,
        title,
        firstname,
        lastname,
        role,
        email,
        mobile,
        organization_id
      from kronos.staff_data
      join kronos.users
      on user_id = users.id;;
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

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: firstname {
    type: string
    sql: ${TABLE}.firstname ;;
  }

  dimension: lastname {
    type: string
    sql: ${TABLE}.lastname ;;
  }

  dimension: organization_id {
    type: string
    sql: ${TABLE}.organization_id ;;
  }

  dimension: role {
    type: number
    sql: ${TABLE}.role ;;
  }

  dimension: status {
    type: number
    sql: ${TABLE}.status ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
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

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: staff_name {
    label: "Staff"
    type: string
    sql: ${firstname} || ' ' || ${lastname} ;;
  }

  measure: count {
    type: count
    drill_fields: [lastname, firstname]
  }
}

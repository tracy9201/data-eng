view: contact {
  sql_table_name: payfac.contact ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: address_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.address_id ;;
  }

  dimension: contact_type {
    type: string
    sql: ${TABLE}.contact_type ;;
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

  dimension_group: date_of_birth {
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
    sql: ${TABLE}.date_of_birth ;;
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

  dimension: driver_licence_number {
    type: string
    sql: ${TABLE}.driver_licence_number ;;
  }

  dimension: driver_licence_state {
    type: string
    sql: ${TABLE}.driver_licence_state ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: fax_number {
    type: string
    sql: ${TABLE}.fax_number ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: is_primary {
    type: yesno
    sql: ${TABLE}.is_primary ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: merchant_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.merchant_id ;;
  }

  dimension: middle_name {
    type: string
    sql: ${TABLE}.middle_name ;;
  }

  dimension: mobile_number {
    type: string
    sql: ${TABLE}.mobile_number ;;
  }

  dimension: phone_number {
    type: string
    sql: ${TABLE}.phone_number ;;
  }

  dimension: ssn {
    type: string
    sql: ${TABLE}.ssn ;;
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

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      last_name,
      middle_name,
      first_name,
      address.id,
      merchant.id,
      merchant.tax_filing_name,
      merchant.legal_business_name,
      merchant.dba_name
    ]
  }
}

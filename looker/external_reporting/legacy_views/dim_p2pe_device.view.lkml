view: device_data {
  sql_table_name: dwh_opul.dim_p2pe_device ;;

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: device_id {
    type: number
    sql: ${TABLE}.device_id ;;
  }

  dimension: organization_id {
    type: number
    sql: ${TABLE}.organization_id ;;
  }

  dimension: merchant_id {
    type: string
    sql: ${TABLE}.merchant_id ;;
  }

  dimension: label {
    label: "Device Name"
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: device_uuid {
    type: string
    sql: ${TABLE}.device_uuid ;;
  }

  set: detail {
    fields: [
      device_id,
      organization_id,
      merchant_id,
      label,
      status,
      device_uuid
    ]
  }
}

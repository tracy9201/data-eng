view: v4_k_organization_data2 {
  sql_table_name: public.v4_k_organization_data2 ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: account_id {
    type: number
    sql: ${TABLE}.account_id ;;
  }

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

  dimension: address_id {
    type: number
    sql: ${TABLE}.address_id ;;
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

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
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

  dimension: feature_flags_json {
    type: string
    sql: ${TABLE}.feature_flags_json ;;
  }

  dimension: gx_org_customer_id {
    type: string
    sql: ${TABLE}.gx_org_customer_id ;;
  }

  dimension: gx_provider_id {
    type: string
    sql: ${TABLE}.gx_provider_id ;;
  }

  dimension: live {
    type: yesno
    sql: ${TABLE}.live ;;
  }

  dimension: merchant_id {
    type: number
    sql: ${TABLE}.merchant_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: organization_tax_percentage {
    type: string
    sql: ${TABLE}.organization_tax_percentage ;;
  }

  dimension: per_member_rate {
    type: number
    sql: ${TABLE}.per_member_rate ;;
  }

  dimension: practice_name {
    type: string
    sql: ${TABLE}.practice_name ;;
  }

  dimension: rate {
    type: number
    sql: ${TABLE}.rate ;;
  }

  dimension: signer_id {
    type: number
    sql: ${TABLE}.signer_id ;;
  }

  dimension: status {
    type: number
    sql: ${TABLE}.status ;;
  }

  dimension: suppressed_messages {
    type: number
    sql: ${TABLE}.suppressed_messages ;;
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

  measure: count {
    type: count
    drill_fields: [id, practice_name, name]
  }
}

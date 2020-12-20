view: merchant {
  sql_table_name: payfac.merchant ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: business_entity_type {
    type: string
    sql: ${TABLE}.business_entity_type ;;
  }

  dimension_group: business_start {
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
    sql: ${TABLE}.business_start_date ;;
  }

  dimension: business_tin {
    type: string
    sql: ${TABLE}.business_tin ;;
  }

  dimension_group: contract_sign {
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
    sql: ${TABLE}.contract_sign_date ;;
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

  dimension: dba_name {
    type: string
    sql: ${TABLE}.dba_name ;;
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

  dimension: legal_business_name {
    type: string
    sql: ${TABLE}.legal_business_name ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: tax_filing_name {
    type: string
    sql: ${TABLE}.tax_filing_name ;;
  }

  dimension: time_zone {
    type: string
    sql: ${TABLE}.time_zone ;;
  }

  dimension: tin_type {
    type: string
    sql: ${TABLE}.tin_type ;;
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

  dimension: web_site_url {
    type: string
    sql: ${TABLE}.web_site_url ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      tax_filing_name,
      legal_business_name,
      dba_name,
      contact.count,
      dim_payfac_date_merchant.count,
      dim_payfac_fee.count,
      fact_payfac_deposit_details.count,
      fact_payfac_deposit_summary.count,
      fact_payfac_fee_basis.count,
      fiserv_chargeback.count,
      fiserv_deposit_adjustment.count
    ]
  }
}

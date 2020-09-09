view: fact_payfac_fee_basis {
  sql_table_name: dwh.fact_payfac_fee_basis ;;

  dimension: basis {
    type: number
    sql: ${TABLE}.basis ;;
  }

  dimension: basis_display {
    type: string
    sql: ${TABLE}.basis_display ;;
  }

  dimension: fee_type {
    type: string
    sql: ${TABLE}.fee_type ;;
  }

  dimension: merchant_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.merchant_id ;;
  }

  dimension: settlement_month {
    type: string
    sql: ${TABLE}.settlement_month ;;
  }

  measure: count {
    type: count
    drill_fields: [merchant.id, merchant.tax_filing_name, merchant.legal_business_name, merchant.dba_name]
  }
}

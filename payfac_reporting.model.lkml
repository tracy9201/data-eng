connection: "redshift"

datagroup: external_reporting_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

include: "/looker/*.view"
include: "/views/*.view"
include: "/looker/external_reporting/*.dashboard.lookml"
persist_with: external_reporting_default_datagroup



explore: payfac_deposit_summary {}

#explore: payfac_deposit_details{}

#explore: date_table {}

explore: fact_deposit { }

explore: dim_address { }

explore: payfac_chargeback { }


explore: date_table {
  join: payfac_deposit_details {
    type: full_outer
    relationship: one_to_many
    sql_on: ${date_table.date_date} = ${payfac_deposit_details.settlement_date} ;;
  }
}

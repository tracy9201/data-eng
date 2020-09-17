connection: "qa-redshift"

datagroup: external_reporting_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

include: "/looker/*.view"
include: "/views/*.view"
include: "/looker/external_reporting/*.dashboard.lookml"
persist_with: external_reporting_default_datagroup



explore: dim_payfac_fee{
  join: fact_payfac_fee_basis {
    type: inner
    relationship: one_to_many
    sql_on: ${fact_payfac_fee_basis.merchant_id} = ${dim_payfac_fee.merchant_id} and ${dim_payfac_fee.fee} =  ${fact_payfac_fee_basis.fee_type} ;;
  }
}


explore: fact_payfac_deposit_details{}

#explore: date_table {}

explore: fact_payfac_deposit { }

explore: dim_address { }

explore: fiserv_chargeback { }

explore: fiserv_deposit_adjustment {}

explore: fact_payfac_deposit_summary{}

#explore: payfac_fee {}

#explore: date_table {
#  join: payfac_deposit_details {
#    type: full_outer
#    relationship: one_to_one
#    sql_on: ${date_table.date_date} = ${payfac_deposit_details.settlement_date} ;;
#  }
#}

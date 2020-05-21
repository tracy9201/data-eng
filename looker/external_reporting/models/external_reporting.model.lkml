connection: "qa-redshift"

datagroup: external_reporting_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

include: "/looker/external_reporting/views/*.view"
include: "/looker/external_reporting/*.dashboard.lookml"
persist_with: external_reporting_default_datagroup


explore: fact_invoice_item {
  persist_for: "0 seconds"
  label: "Invoice Details"

  join: dim_customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_invoice_item.gx_customer_id} = ${dim_customer.gx_customer_id} ;;
  }
  join: dim_provider {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_invoice_item.gx_provider_id} = ${dim_provider.gx_provider_id} ;;
  }
  join: dim_date_table {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_invoice_item.pay_date_date} = ${dim_date_table.date_date} ;;
  }

  # access_filter: {
  #   field: dim_provider.k_practice_id
  #   user_attribute: practice_filter_attribute
  # }
}

connection: "qa-redshift"

datagroup: external_reporting_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

include: "/views/*.view"
include: "/*.dashboard.lookml"
persist_with: external_reporting_default_datagroup


explore: fact_invoice_item {

  label: "Transaction Details"
  join: dim_offering {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_invoice_item.gx_subscription_id} = ${dim_offering.gx_subscription_id} ;;
  }
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
}

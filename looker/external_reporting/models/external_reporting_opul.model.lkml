connection: "qa-redshift2"

datagroup: external_reporting_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

include: "/looker/external_reporting/opul_views/*.view"
include: "/looker/external_reporting/opul_dashboards/*.dashboard.lookml"
persist_with: external_reporting_default_datagroup


explore: fact_sales_by_staff {
  persist_for: "0 seconds"
  label: "Invoice Details"

  join: dim_customer_opul {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_sales_by_staff.gx_customer_id} = ${dim_customer_opul.gx_customer_id} ;;
  }
  join: dim_provider_opul {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_sales_by_staff.gx_provider_id} = ${dim_provider_opul.gx_provider_id} ;;
  }
  join: dim_staff_opul {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_sales_by_staff.staff_user_id} = ${dim_staff_opul.user_id} ;;
  }

  access_filter: {
    field: dim_provider_opul.k_practice_id
    user_attribute: opul_organization_id
  }
}

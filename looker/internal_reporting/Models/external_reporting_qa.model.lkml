connection: "redshift"

datagroup: internal_reporting_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

include: "/looker/internal_reporting/Views/*.view"
# include: "/looker/internal_repoarting/Da/*.dashboard.lookml"

persist_with: internal_reporting_default_datagroup

# explore: payment_summary_qa {
#   persist_for: "0 seconds"
#   access_filter: {
#     field: practice2.k_practice_id
#     user_attribute: practice_filter_attribute
#   }

#   join: customer2 {
#     type: left_outer
#     sql_on: ${customer2.gx_customer_id} = ${payment_summary.gx_customer_id};;
#     relationship: many_to_one
#   }

#   join: practice2 {
#     type: left_outer
#     sql_on: ${practice2.gx_provider_id} = ${payment_summary.gx_provider_id};;
#     relationship: many_to_one
#   }
#   join: date_table {
#     type: inner
#     sql_on: ${date_table.date_date} = ${payment_summary.sales_created_at_MM_DD_YYYY_date} ;;
#     relationship: many_to_one
#   }


#   join: kronos_subscription {
#     type: left_outer
#     relationship: one_to_one
#     sql_on: ${kronos_subscription.gx_subscription_id} =  ${payment_summary.gx_subscription_id};;
#   }

#   sql_always_where: ${category} = 'GOOD' ;;
# }



# explore: deposit_summary {
#   persist_for: "0 seconds"

#   access_filter: {
#     field: practice.k_practice_id
#     user_attribute: practice_filter_attribute

#   }

#   join: date_table {
#     type: inner
#     sql_on: ${date_table.date_date} = ${deposit_summary.funding_date_time_date} ;;
#     relationship: many_to_one
#   }

#   join: practice {
#     type: inner
#     sql_on: ${practice.gx_provider_id} = ${deposit_summary.gx_provider_id};;
#     relationship: many_to_one
#   }
# }

# explore: today_upcoming_deposits_derived {
#   persist_for: "0 seconds"

#   access_filter: {
#     field: practice.k_practice_id
#     user_attribute: practice_filter_attribute

#   }

#   join: date_table {
#     type: inner
#     sql_on: ${date_table.date_date} = ${today_upcoming_deposits_derived.uniq_date_date} ;;
#     relationship: many_to_one
#   }

#   join: practice {
#     type: inner
#     sql_on: ${practice.gx_provider_id} = ${today_upcoming_deposits_derived.gx_provider_id};;
#     relationship: many_to_one
#   }
# }


# explore: today_upcoming_deposits_derived_2 {
#   persist_for: "0 seconds"

#   access_filter: {
#     field: practice.k_practice_id
#     user_attribute: practice_filter_attribute

#   }

#   join: date_table {
#     type: inner
#     sql_on: ${date_table.date_date} = ${today_upcoming_deposits_derived_2.uniq_date_date} ;;
#     relationship: many_to_one
#   }

#   join: practice {
#     type: inner
#     sql_on: ${practice.gx_provider_id} = ${today_upcoming_deposits_derived_2.gx_provider_id};;
#     relationship: many_to_one
#   }
# }

explore: date_table {
  persist_for: "0 seconds"

  access_filter: {
    field: practice.k_practice_id
    user_attribute: practice_filter_attribute

  }
  join: practice {
    type: cross
    relationship: many_to_many
  }

  join: batch_report_summary {
    type: left_outer
    sql_on: ${practice.gx_provider_id} = ${batch_report_summary.gx_provider_id}  and ${batch_report_summary.sales_created_at_date} = ${date_table.date_date};;
    relationship: one_to_many
  }
  join: customer {
    type: left_outer
    sql_on: ${customer.gx_customer_id} = ${batch_report_summary.gx_customer_id};;
    relationship: many_to_one
  }

  join: kronos_subscription {
    type: left_outer
    relationship: many_to_one

    sql_on: ${kronos_subscription.gx_subscription_id} = ${batch_report_summary.gx_subscription_id};;

  }
  sql_always_where: ${batch_report_summary.sales_type} IS NOT NULL and ${practice.gx_provider_id} is not NULL and ${batch_report_summary.category} = 'GOOD';;
}



# explore: payment_method {
#   from: date_table
#   persist_for: "0 seconds"

#   access_filter: {
#     field: practice.k_practice_id
#     user_attribute: practice_filter_attribute

#   }

#   join: practice {
#     type: cross
#     relationship: many_to_many
#   }

#   join: payment_summary {
#     type: left_outer
#     sql_on: ${practice.gx_provider_id} = ${payment_summary.gx_provider_id}  and ${payment_summary.sales_created_at_date} = ${payment_method.date_date};;
#     relationship: one_to_many
#   }
#   #sql_always_where: ${qa_practice_sales.sales_type} IS NOT NULL and ${qa_practice.gx_provider_id} is not NULL;;
# }

explore: top_product_sales {
  from: date_table
  persist_for: "0 seconds"

  access_filter: {
    field: practice.k_practice_id
    user_attribute: practice_filter_attribute

  }
  join: practice {
    type: cross
    relationship: many_to_many
  }

  join: product_sales {
    type: left_outer
    sql_on: ${practice.gx_provider_id} = ${product_sales.k_provider_id} and ${product_sales.subscription_created_date} = ${top_product_sales.date_date} ;;
    relationship: one_to_many
  }
  sql_always_where: ${product_sales.subscription_name} IS NOT NULL ;;

}

# explore: settlement_funding {
#   persist_for: "0 seconds"


#   # access_filter: {
#   #   field: practice.k_practice_id
#   #   user_attribute: practice_filter_attribute
#   # }
#   #sql_always_where: ${deposit_summary.ronum_Funding_master} = 1 ;;
#   join: practice {
#     type: left_outer
#     sql_on: ${practice.gx_provider_id} = ${settlement_funding.gx_provider_id};;
#     relationship: many_to_one
#   }

#   join: customer2 {
#     type: left_outer
#     sql_on: ${customer2.gx_customer_id} = ${settlement_funding.gx_customer_id} ;;
#     relationship: many_to_one
#   }

#   join: deposit_summary {
#     type: left_outer
#     relationship: one_to_one
#     sql_on: ${settlement_funding.funding_txn_id} = ${deposit_summary.funding_master_id} ;;
#   }
# }


explore: batch_report_details {
  persist_for: "0 seconds"
  access_filter: {
    field: practice.k_practice_id
    user_attribute: practice_filter_attribute
  }

  join: customer {
    type: left_outer
    sql_on: ${customer.gx_customer_id} = ${batch_report_details.gx_customer_id};;
    relationship: many_to_one
  }

  join: practice {
    type: left_outer
    sql_on: ${practice.gx_provider_id} = ${batch_report_details.gx_provider_id};;
    relationship: many_to_one
  }

  join: date_table {
    type: inner
    sql_on: ${date_table.date_date} = ${batch_report_details.sales_created_at_MM_DD_YYYY_date} ;;
    relationship: many_to_one
  }

  join: staff_details {
    type: left_outer
    relationship: many_to_one
    sql_on: ${staff_details.user_id} = ${batch_report_details.staff_user_id};;
  }

  join: kronos_subscription {
    type: left_outer
    relationship: many_to_one

    sql_on: ${kronos_subscription.gx_subscription_id} =  ${batch_report_details.gx_subscription_id};;
  }

  # join: device_data {
  #   type: left_outer
  #   relationship: many_to_one
  #   sql_on: ${batch_report_details.device_id} = ${device_data.device_uuid} ;;
  # }

  sql_always_where: ${category} = 'GOOD' ;;
}

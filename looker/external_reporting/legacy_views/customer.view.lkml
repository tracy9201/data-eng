include: "customer_parent_extends.view"
view: customer {

  extends: [customer_parent_extends]

  sql_table_name: dwh_hint.dim_customer ;;

}
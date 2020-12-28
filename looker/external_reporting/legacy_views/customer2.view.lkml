include: "customer_parent_extends.view"
view: customer2 {

  extends: [customer_parent_extends]

  sql_table_name: dwh_opul.dim_customer ;;

}

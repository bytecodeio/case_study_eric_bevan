view: order_rollup_users_cross_view {

 measure: percent_customers_with_many_orders {
   type: number
   sql: ${dt_order_rollup_users.count_users_with_many_orders} / ${users.count} ;;
   value_format_name: percent_1
 }

  measure: percent_customers_without_many_orders {
    type: number
    sql: ${dt_order_rollup_users.count_users_without_many_orders} / ${users.count} ;;
    value_format_name: percent_1
  }

}

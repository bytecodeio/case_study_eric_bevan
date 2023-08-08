view: cv_order_items_china {

  measure: count_order_items_china {
    description: "A count of items ordered from users from China"
    view_label: "Order Items"
    type: count_distinct
    sql: ${order_items.id} ;;
    filters: [users.country : "China"]
  }
}

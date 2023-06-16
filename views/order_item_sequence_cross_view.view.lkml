view: order_item_sequence_cross_view {

  dimension: customers_multi_order_items_indicator  {
    type:  yesno
    sql:   ${dt_user_order_items.lifetime_order_items} > 1 ;;
  }

  measure: count_customers_with_subsequent_purchases  {
    type:  count_distinct
    sql:   ${order_items.user_id} ;;
    filters: [dt_user_order_items.lifetime_order_items: "> 1"]
  }

  measure: customer_percent_subsequent_purchase {
    type:  number
    sql:   ${count_customers_with_subsequent_purchases} / NULLIF(${order_items.number_of_customers_with_sales}, 0) ;;
    value_format_name: percent_0
  }

  measure: count_customers_without_subsequent_purchases  {
    type:  count_distinct
    sql:   ${order_items.user_id} ;;
    filters: [dt_user_order_items.lifetime_order_items: "= 1"]
  }

  measure: customer_percent_without_subsequent_purchase {
    type:  number
    sql:   ${count_customers_without_subsequent_purchases} /NULLIF(${order_items.number_of_customers_with_sales}, 0) ;;
    value_format_name: percent_0
  }
}

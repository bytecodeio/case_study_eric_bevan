view: inventory_cross_view {

  measure: total_cost_items_sold {
    description: "Total cost of items sold from inventory"
    type: sum
    sql_distinct_key: ${order_items.id} ;;
    sql: ${inventory_items.cost} ;;
    value_format_name: usd
    filters: [order_items.sale_complete_indicator: "Yes"]
  }

  measure: average_cost_items_sold {
    description: "Average cost of items sold from inventory"
    type: average
    sql_distinct_key: ${order_items.id} ;;
    sql: ${inventory_items.cost} ;;
    filters: [order_items.sale_complete_indicator: "Yes"]
    value_format_name: usd
  }

  measure: total_gross_margin_amount {
    description: "Total difference between the total revenue from completed sales and the cost of the goods that were sold"
    type: sum
    sql_distinct_key: ${order_items.id} ;;
    sql:  ${order_items.sale_price} - ${inventory_items.cost} ;;
    filters: [order_items.sale_complete_indicator: "Yes"]
    value_format_name: usd
    drill_fields: [products.cateogry, products.name, order_items.total_gross_revenue]
  }

  measure: average_gross_margin_amount {
    description: "Average difference between the total revenue from completed sales and the cost of the goods that were sold"
    type: average
    sql_distinct_key: ${order_items.id} ;;
    sql:  ${order_items.sale_price} - ${inventory_items.cost} ;;
    filters: [order_items.sale_complete_indicator: "Yes"]
    value_format_name: usd
  }

  measure: gross_margin_percent {
    description: "Total Gross Margin Amount / Total Gross Revenue"
    type:  number
    sql_distinct_key: ${order_items.id} ;;
    sql:   ${total_gross_margin_amount} / NULLIF(${order_items.total_gross_revenue}, 0);;
    value_format_name: percent_1
    drill_fields: [products.category, products.brand, gross_margin_percent]
  }

}

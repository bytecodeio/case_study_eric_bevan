# The name of this view in Looker is "Order Items"
view: order_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `thelook.order_items`
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Inventory Item ID" in Explore.

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }



  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql:  ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: sale_complete_indicator {
    type: yesno
    sql:  ${status} IN ('Completed','Shipped','Processing') ;;
  }



  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.


  measure: average_sale_price {
    description: "Average sale price of items sold"
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: average_spend_per_customer {
    description: "Total Sale Price / total number of customers"
    type: number
    value_format_name: usd
    sql:  ${total_sale_price} / NULLIF( ${number_of_customers_with_sales}, 0);;
    drill_fields: [users.age_tier, users.gender, average_spend_per_customer]
  }

  measure: count_order_items {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [detail*]
  }

  measure: count_orders {
    type: count_distinct
    sql: ${order_id} ;;
    drill_fields: [detail*]
  }

  measure: cumulative_total_sales_price {
    description: "A cumulative or running total of sales price"
    type: running_total
    sql: ${total_sale_price} ;;
    value_format_name:  usd
  }

  measure: item_return_rate {
    description: "Number of Items Returned / total number of items sold"
    type: number
    sql: ${number_of_items_returned} / NULLIF(${count_order_items}, 0) ;;
    value_format_name: percent_1
  }

  measure: order_date_earliest {
    description: "The earliest or first order date"
    type:  date
    sql:   MIN(${created_raw});;
  }

  measure: order_date_latest {
    description: "The latest or last order date"
    type:  date
    sql:   MAX(${created_raw});;
  }


  measure: number_of_customers_with_sales {
    description: "Number of users who have ordered an item at some point"
    type: count_distinct
    sql: ${user_id} ;;
    # filters: [status: "Returned"]
  }

  measure: number_of_customers_returning_items {
    description: "Number of users who have returned an item at some point"
    type: count_distinct
    sql: ${user_id} ;;
    filters: [status: "Returned"]
  }

  measure: number_of_items_returned {
    description: "Number of items that were returned by dissatisfied customers"
    type: count_distinct
    sql:  ${id} ;;
    filters: [status: "Returned"]
    value_format: "#,###"
  }

  measure: percent_users_with_returns {
    description: "Number of Customer Returning Items / total number of customers"
    type:  number
    value_format_name: percent_1
    sql:  ${number_of_customers_with_sales} / NULLIF(${number_of_customers_returning_items}, 0);;
  }

  measure: item_repeat_customer_indicator {
    type:  yesno
    sql:  ${count_orders} > 1 ;;
  }

  measure: total_gross_revenue {
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: [sale_complete_indicator: "Yes"]
    drill_fields: [products.cateogry, products.name, total_gross_revenue]
  }

  measure: total_sale_price {
    description: "Total sales from Items sold"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }



  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name,
      products.name,
      products.id
    ]
  }
}

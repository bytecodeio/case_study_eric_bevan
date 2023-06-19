view: dt_order_rollup {
  view_label: "Order Rollup"
  derived_table: {
    sql: with users_and_orders as (
        SELECT
          user_id,
          order_id,
          extract(date from created_at) as order_date,
          count(distinct inventory_item_id) as number_of_distinct_items,
          sum(sale_price) as sales_price
        FROM `looker-partners.thelook.order_items`
        group by 1,2,3
        )

      select
      user_id,
      order_id,
      order_date,
      sum(number_of_distinct_items) over (partition by user_id, order_id) as distinct_order_items,
      sum(sales_price) over (partition by user_id, order_id) as order_sales_price,
      rank() over (partition by user_id order by order_id asc) as order_sequence
      from users_and_orders
      qualify row_number() over (partition by user_id, order_id order by order_date desc) = 1
      order by user_id asc, order_id asc, order_date desc
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    # hidden:  yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_id {
    primary_key: yes
    # hidden:  yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_date {
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: distinct_order_items {
    type: number
    sql: ${TABLE}.distinct_order_items ;;
  }

  dimension: order_sales_price {
    type: number
    sql: ${TABLE}.order_sales_price ;;
  }

  dimension: order_sequence {
    type:  number
    sql: ${TABLE}.order_sequence ;;
  }


  set: detail {
    fields: [user_id, order_id, order_date, distinct_order_items, order_sales_price]
  }
}



view: dt_order_rollup_users {

  derived_table: {
  sql: select  user_id,
               COUNT(DISTINCT order_id) as lifetime_order_count
         FROM  ${dt_order_rollup.SQL_TABLE_NAME}
     GROUP BY  user_id ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: user_id {
    primary_key: yes
    hidden: yes
    description: "Unique ID for each user that has ordered"
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_count {
    description: "The total number of orders for each user"
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: user_has_multiple_orders {
    type: yesno
    sql:  ${lifetime_order_count} > 1 ;;
  }

  measure: count_users_with_many_orders {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [user_has_multiple_orders: "Yes"]
  }

    measure: count_users_without_many_orders {
      type: count_distinct
      sql: ${user_id} ;;
      filters: [user_has_multiple_orders: "No"]
  }

}

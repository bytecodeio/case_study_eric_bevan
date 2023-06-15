view: dt_user_order_items {


#   # Or, you could make this view a derived table, like this:
  derived_table: {
    sql:
    SELECT
           user_id as user_id,
           COUNT(id) as lifetime_order_items
     FROM  order_items
 GROUP BY  user_id
      ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: user_id {
    description: "Unique ID for each user that has ordered"
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_items {
    description: "The total number of order items for each user"
    type: number
    sql: ${TABLE}.lifetime_order_items ;;
  }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
 }

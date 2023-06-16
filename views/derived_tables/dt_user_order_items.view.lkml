view: dt_user_order_items {

  derived_table: {
    sql:
    SELECT
           users.id as user_id,
           COUNT(order_items.id) as lifetime_order_items
     FROM  users
           LEFT JOIN order_items
           ON users.id = order_items.user_id
 GROUP BY  users.id
      ;;
  }

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

}

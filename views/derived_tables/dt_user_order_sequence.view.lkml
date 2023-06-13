view: dt_user_order_sequence {
  derived_table: {
    sql:
SELECT  user_id,
        id,
        row_number() over(partition by user_id order by created_at asc) as user_order_sequence,
        LEAD(created_at) OVER(PARTITION BY user_id ORDER BY created_at asc) AS next_order_date,
        DATE_DIFF(LEAD(created_at) OVER(PARTITION BY user_id ORDER BY created_at asc), created_at, DAY) AS days_until_next_order
  FROM  `thelook.order_items`
      ;;
  }

  dimension: user_order_id {
    primary_key: yes
    hidden: yes
    type: number
    sql:  ${TABLE}.user_id || ${TABLE}.user_order_sequence ;;
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: id {
    type: number
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: user_order_sequence {
    type: number
    sql: ${TABLE}.user_order_sequence ;;
  }

  dimension_group: next_order_date {
    type: time
    hidden: yes
    sql: ${TABLE}.next_order_date ;;
  }

  dimension: days_until_next_order {
    type: number
    sql: ${TABLE}.days_until_next_order ;;
  }


  dimension: first_order_indicator {
    type: yesno
    sql:  ${user_order_sequence} = 1 ;;
  }


  measure: customer_has_subequent_orders_indicator {
    description: "Indicator for whether or not a customer placed a subsequent order on the website"
    type: yesno
    sql:  MAX(${user_order_sequence}) > 1 ;;
  }

  ### BEGIN CALCULATING % CUSTOMERS WITH <60 DAY SUBSEQUENCE PURCHASE ###
  dimension: customers_subsequent_60_day_purchase_indicator {
    type: yesno
    sql:  ${days_until_next_order}  <= 60 ;;
  }

  measure: count_customers_with_60_day_subsequent_purchase{
    type:  count_distinct
    sql:   ${user_id} ;;
    filters: [customers_subsequent_60_day_purchase_indicator : "yes"]
  }

  measure: count_customers_with_purchases  {
    type:  count_distinct
    sql:   ${user_id} ;;
  }

  measure: customer_percent_60day_subsequent_purchase {
    type:  number
    sql:   ${count_customers_with_60_day_subsequent_purchase} / NULLIF(${count_customers_with_purchases}, 0) ;;
    value_format_name: percent_0
  }




  set: detail {
    fields: [user_id, id, user_order_sequence, next_order_date_time, days_until_next_order]
  }
}

view: dt_order_item_sequence {
  derived_table: {
    sql:
SELECT  --user_id,
        id,
        row_number() over(partition by user_id order by created_at asc) as user_order_sequence,
        LEAD(created_at) OVER(PARTITION BY user_id ORDER BY created_at asc) AS next_order_date,
        DATE_DIFF(LEAD(created_at) OVER(PARTITION BY user_id ORDER BY created_at asc), created_at, DAY) AS days_until_next_order
  FROM  `thelook.order_items`
      ;;
    interval_trigger: "1 hour"
    # indexes: ["id"]
  }

  # dimension: user_order_id {
  #   primary_key: yes
  #   hidden: yes
  #   type: number
  #   sql:  ${TABLE}.user_id || ${TABLE}.user_order_sequence ;;
  # }

  # dimension: user_id {
  #   type: number
  #   hidden: yes
  #   sql: ${TABLE}.user_id ;;
  # }

  dimension: id {
    primary_key:  yes
    type: number
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: user_order_sequence {
    type: number
    sql: ${TABLE}.user_order_sequence ;;
  }

  dimension: next_order_date {
    description: "Create Date of next order item"
    type: date
    sql: ${TABLE}.next_order_date ;;
  }

  dimension: days_until_next_order {
    description: "The number of days between the current and next order item create date"
    type: number
    sql: ${TABLE}.days_until_next_order ;;
  }


  dimension: first_order_indicator {
    description: "Indicates if the current order items was the first created"
    type: yesno
    sql:  ${user_order_sequence} = 1 ;;
  }

  measure: average_days_between_purchases{
    type:  average
    sql: ${days_until_next_order} ;;
    filters: [days_until_next_order: " not null"]
    value_format_name: decimal_0
  }

  dimension: customer_has_subsequent_orders_indicator {
    description: "Indicator for whether or not a customer placed a subsequent order on the website"
    type: yesno
    sql:  ${user_order_sequence} > 1 ;;
  }


  dimension: subsequent_60_day_purchase_indicator {
    description: "Indicates if next order item was created within 60 days of the current item"
    type: yesno
    sql:  ${days_until_next_order}  <= 60 ;;
  }

  set: detail {
    fields: [user_order_sequence, next_order_date, days_until_next_order]
  }
}

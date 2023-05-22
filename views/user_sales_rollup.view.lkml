
# include: "case_study_eric_bevan.model.lkml"

  view: user_sales_rollup {
    derived_table: {
      explore_source: order_items {
        column: user_id {}
        column: count_orders {}
        column: total_gross_revenue {}
        column: order_date_earliest {}
        column: order_date_latest {}
      }
    }
    dimension: user_id {
      description: "User Id"
      primary_key: yes
      type: number
      value_format_name: id
    }
    dimension: count_orders {
      label: "Total Lifetime Orders"
      description: "Distinct order count per user"
      type: number
    }
    dimension: count_orders_tier {
      description: "Buckets of age groups:
      ● 1 Order
      ● 2 Orders
      ● 3-5 Orders
      ● 6-9 Orders
      ● 10+ Orders"
      type:  tier
      sql: ${count_orders} ;;
      tiers: [1,2,3,6,10]
      style: integer

    }
    dimension: total_gross_revenue {
      label: "Total Lifetime Revenue"
      description: "Total revenue from completed sales (cancelled and returned orders excluded)"
      value_format: "$#,##0.00"
      type: number
    }
    dimension: total_gross_revenue_tier {
      description: "Buckets of Total revenue from completed sales (cancelled and returned orders excluded):
      ● $0.00 - $4.99
      ● $5.00 - $19.99
      ● $20.00 - $49.99
      ● $50.00 - $99.99
      ● $100.00 - $499.99
      ● $500.00 - $999.99
      ● $1000.00 +"
      type:  tier
      sql: ${total_gross_revenue} ;;
      tiers: [0,5,20,50,100,500,1000]
      style: integer
      value_format_name: usd
    }
    dimension: order_date_earliest {
      label: "First Order Date"
      description: "A user's earliest or first order date"
      type: date
    }
    dimension: order_date_latest {
      label: "Latest Order Date"
      description: "A user's latest or last order date"
      type: date
    }
    dimension: days_since_last_order {
      type:  number
      sql: DATE_DIFF(CURRENT_DATE(), ${order_date_latest}, DAY) ;;
    }
    dimension: repeat_customer_indicator {
      type:  yesno
      sql: ${count_orders} > 1 ;;
    }

    measure: average_days_since_last_order {
      type:  average
      sql:  ${days_since_last_order} ;;
    }

    measure: average_order_count {
      label: "Average Lifetime Orders"
      description: "The average number of orders that a customer places over the course of their lifetime as a customer"
      type: average
      sql:  ${count_orders} ;;
      value_format_name: decimal_0
    }
    measure: average_revenue {
      label: "Average Lifetime Revenue"
      description: "The average amount of revenue that a customer brings in over the course of their lifetime as a customer."
      type: average
      sql:  ${total_gross_revenue} ;;
      value_format_name: usd
    }

  }

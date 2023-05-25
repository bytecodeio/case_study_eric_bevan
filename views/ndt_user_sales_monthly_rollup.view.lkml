  view: ndt_user_sales_monthly_rollup {
    derived_table: {
    sql: SELECT
                order_items.created_at  AS order_created_month,
                order_items.user_id  AS user_id,
                COALESCE(SUM(CASE WHEN ( order_items.status IN ('Completed','Shipped','Processing') ) THEN order_items.sale_price  ELSE NULL END), 0) AS monthly_gross_revenue
         FROM  `thelook.order_items`  AS order_items
         GROUP BY
               1,
               2 ;;
      interval_trigger: "1 hour"
      # indexes: ["order_items.order_created_month"]
      }

    dimension: pk {
      type: string
      primary_key: yes
      hidden: yes
      sql: concat(${TABLE}.order_created_month},${TABLE}.user_id) ;;
    }

    dimension: order_created_month {
      # description: ""
      label: "Order Created Month"
      # primary_key: yes
      type:  date_month
      sql: ${TABLE}.order_created_month ;;
    }

    dimension: monthly_gross_revenue {
      type: number
      sql: ${TABLE}.monthly_gross_revenue ;;
      value_format_name: usd
    }

    dimension: user_id {
      # primary_key: yes
      # description: ""
      hidden: yes
      type: number
      sql:  ${TABLE}.user_id ;;
    }

    measure: count_months {
      type: count_distinct
      sql: ${TABLE}.order_created_month ;;
    }

    measure: total_monthly_gross_revenue {
      description: "Total monthly revenue from completed sales (cancelled and returned orders excluded)"
      label: "Total Monthly Gross Revenue"
      value_format: "$#,##0.00"
      type: sum
      sql:  ${monthly_gross_revenue} ;;
    }
    measure: average_monthly_gross_revenue {
      description: "Average total monthly revenue from completed sales (cancelled and returned orders excluded)"
      label: "Average Monthly Gross Revenue"
      value_format: "$#,##0.00"
      type: number
      sql:  ${total_monthly_gross_revenue} / ${count_months} ;;
    }
  }

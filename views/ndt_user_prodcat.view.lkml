# If necessary, uncomment the line below to include explore_source.

# include: "case_study_eric_bevan.model.lkml"

view: ndt_user_prodcat {

    derived_table: {
      explore_source: order_items {
        column: category {field: products.category}
        column: user_id { field: order_items.user_id }
        column: total_orders { field: order_items.count_orders }
        # filters: {
        #   field: order_items.user_id
        #   value: "NOT NULL"
        # }
        # filters: {
        #   field: products.category
          # value: "Swim"
        # }
        # filters: {
        #   field: ndt_user_product_rollup.user_id
        #   value: "93745,27853"
        # }
        # filters: {
        #   field: ndt_user_product_rollup.total_orders
        #   value: "1"
        # }
      }
    }
    # dimension: pk {
    #   primary_key: yes
    #   sql: concat(${TABLE}.category, ${TABLE}.user_id) ;;
    # }

    dimension: category {
      description: ""
    }
    dimension: user_id {
      label: "User Sales Product Rollup User ID"
      description: ""
      type: number
    }
    dimension: total_orders {
      label: "User Sales Product Rollup Total Orders"
      description: ""
      type: number
    }


    measure: count_users {
      type: count_distinct
      sql: ${user_id} ;;
      required_fields: [products.category]
    }

    measure: count_repeat_users {
      type: count_distinct
      sql:  ${user_id} ;;
      filters: [total_orders : ">1"]
      required_fields: [products.category]
    }

  measure: count_nonrepeat_users {
    type: count_distinct
    sql:  ${user_id} ;;
    filters: [total_orders : "=1"]
    required_fields: [products.category]
  }

  measure: repeat_purch_rate {
    type:  number
    sql:  (${count_repeat_users} / NULLIF(${count_users},0)) ;;
    value_format_name: percent_2
  }
  }

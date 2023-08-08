#####################################################################
## Purpose:  This derived table pre-aggregates all sales for use in
##           percent calculation of regional (Country, State) sales
#####################################################################

view: dt_state_sales_rollup {
  derived_table: {
    explore_source: order_items {
      column: country { field: users.country }
      column: state { field: users.state }
      column: total_sale_price {}
      derived_column: all_sales { sql: SUM(total_sale_price) OVER () ;;}
    }
  }

  # dimension: pk {
  #   primary_key: yes
  #   type:  string
  #   sql: ${country}||${state} ;;
  # }


  dimension: country {
    description: ""
    sql: ${TABLE}.country ;;
  }

  dimension: state {
    description: ""
    sql: ${TABLE}.state ;;
  }

  dimension: regional_sales {
    description: ""
    value_format: "$#,##0.00"
    type: number
    sql: ${TABLE}.total_sale_price ;;
  }

  dimension: all_sales {
    type: number
    sql: ${TABLE}.all_sales ;;
    value_format_name: usd
  }

  measure: total_regional_sales {
    type:  number
    sql: SUM(${regional_sales}) ;;
    value_format_name: usd
  }

  measure: regional_percent_all_sales {
    type: number
    sql: ${total_regional_sales} / NULLIF(${all_sales},0) ;;
    value_format_name: percent_3
  }
}

view: parameters {

  parameter: sales_duration {
    type:  string
    description: "Filter to describe the duration of sales desired"
    allowed_value: {
      label: "Day Durations"
      value: "Day"
    }
    allowed_value: {
      label: "Week Durations"
      value: "Week"
    }
    allowed_value: {
      label: "Month Durations"
      value: "Month"
    }
    allowed_value: {
      label: "Quarter Durations"
      value: "Quarter"
    }
    allowed_value: {
      label: "Year Durations"
      value: "Year"
    }
  }

  # parameter: sales_measure {
  #   type:  unquoted
  #   description: "Use this to pick a sales metric on a look"
  #   allowed_value: {label: "Total Gross Revenue" value: "total_gross_revenue"}
    # allowed_value: {label: "Total Sale Price" value: "sale_price"}
    # allowed_value: {value: "total_sale_price"}
  # }

  parameter: param_sales_price {
    type:  unquoted
    description: "Use this to pick a sales price metric on a look"
    allowed_value: {label: "Total Sales Price"  value: "SUM"}
    allowed_value: {label: "Average Sale Price" value: "AVG"}
    allowed_value: {label: "Min Sale Price"     value: "MIN"}
    allowed_value: {label: "Max Sale Price"     value: "MAX"}
  }

  parameter: param_sales_revenue {
    type:  unquoted
    description: "Use this to pick a sales revenue metric on a look"
    allowed_value: {label: "Total Sales Revenue"  value: "SUM"}
    allowed_value: {label: "Average Sale Revenue" value: "AVG"}
    allowed_value: {label: "Min Sale Revenue"     value: "MIN"}
    allowed_value: {label: "Max Sale Revenue"     value: "MAX"}
  }
}

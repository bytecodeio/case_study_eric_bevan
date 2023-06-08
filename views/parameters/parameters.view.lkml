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

  parameter: sales_measure {
    type:  unquoted
    description: "Use this to pick a sales metric on a look"
    allowed_value: {label: "Total Gross Revenue:" value: "sale_price"}
    # allowed_value: {value: "total_sale_price"}
  }
}

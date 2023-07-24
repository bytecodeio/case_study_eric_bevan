include: "/views/pop_support.view" #include the helper fields that are core to the PoP implementation - meaning: include the file in which you pasted the code as described in Step 1 above.
include: "/views/order_items.view" #!Include the file that defines your base view here so you can refine it


view: +order_items {#!Update to point to your view name (with the '+' making it a refinement).  That view's file must be included here, and then THIS file must be included in the explore

  #Refine YOUR date field by simply updating the dimension group name to match your base date field

  dimension_group: created {
    convert_tz: no #we need to inject the conversion before the date manipulation
    datatype: datetime
    sql:{% assign now_converted_to_date_with_timezone_sql = "${pop_support.now_converted_to_date_with_tz_sql::datetime}" %}
        {% assign now_unconverted_sql = pop_support.now_sql._sql %} --{%comment%}pulling in logic from pop support template, within which we'll inject the original sql. Use $ {::date} when we want to get looker to do conversions, but _sql to extract raw sql {%endcomment%}
        {% assign selected_period_size = selected_period_size._sql | strip %}

        {% if    selected_period_size == 'Day' %}  {% assign pop_sql_using_now = "${pop_support.pop_sql_days_using_now}" %}
        {% elsif selected_period_size == 'Month' %}{% assign pop_sql_using_now = "${pop_support.pop_sql_months_using_now}" %}
        {% else %}{% assign pop_sql_using_now = "${pop_support.pop_sql_years_using_now}" %}{% endif %}
        {% assign my_date_converted = now_converted_to_date_with_timezone_sql | replace:now_unconverted_sql,"${EXTENDED}" %}

        {% if pop_support.periods_ago._in_query %}{{ pop_sql_using_now | replace: now_unconverted_sql, my_date_converted }}
        {% else %}{{my_date_converted}}
        {% endif %};;#wraps your original sql (i.e. ${EXTENDED}) inside custom pop logic, leveraging the parameterized selected-period-size-or-smart-default (defined below)

  }


  #Selected Period Size sets up Default Period Lengths to use for each of your timeframes, if the user doesn't adjust the PoP period size parameter
  #If you only wanted YOY to be available, simply hard code this to year and hide the timeframes parameter in pop support

  dimension: selected_period_size {
    hidden: yes
    sql:{% if pop_support.period_size._parameter_value != 'Default' %}{{pop_support.period_size._parameter_value}}
        {% else %}
        {% if created_date._is_selected %}Day
        {% elsif created_month._is_selected %}Month
        {% else %}Year
        {% endif %}
        {% endif %};;#!Update the liquid that mentions created_date and created_month to point to your timeframes, and potentially add more checks for other timeframes, and to consider other pop refined date fields within this view (if any)
  }


  dimension: created_date_periods_ago_pivot {#!Update to match your base field name. This is generic sql logic (so you might expect it to be in pop_support template), but it is helpful to manifest this lynchpin pivot field here so we can create a dedicated pivot field in this specific date dimension's group label.
    label: "{% if _field._in_query %} Pop Period (Created {{selected_period_size._sql}} ) {% else %} Pivot for Period Over Period {%endif%}"#makes the 'PIVOT ME' instruction clear in the field picker, but uses a dynamic output label based on the period size selected
    group_label: "Created Date" #!Update this group label if necessary to make it fall in your date field's group_label
    order_by_field: pop_support.periods_ago #sort numerically/chronologically.
    sql:{% assign period_label_sql = "${pop_support.period_label_sql}" %}
        {% assign selected_period_size = selected_period_size._sql | strip %}
        {% assign label_using_selected_period_size = period_label_sql | replace: 'REPLACE_WITH_PERIOD',selected_period_size %}{{label_using_selected_period_size}};;#makes intuitive period labels

  }


# Optional Validation Support field.  If there's ever any confusion with the results of PoP, it's helpful to see the exact min and max times of your raw data flowing through.
#  measure: pop_validation {
#     view_label: "PoP - VALIDATION - TO BE HIDDEN"
#     label: "Range of Raw Dates Included"
#     description: "Note: does not reflect timezone conversion"
#sql:{%assign base_sql = '${TABLE}.created_at'%}concat(concat(min({{base_sql}}),' to '),max({{base_sql}}));;#!Paste the sql parameter value from the original date fields as the variable value for base_sql
#   }
}

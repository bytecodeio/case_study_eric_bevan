# The name of this view in Looker is "Users"
view: users {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `thelook.users`
    ;;
  drill_fields: [id, age_tier, gender, new_customer_indicator]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Age" in Explore.

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type:  tier
    tiers: [15, 26, 36, 51, 66]
    sql: ${age} ;;
    style:  integer
  }

  dimension: new_customer_indicator {
    description: "Indicates if a customer has signed up on the website in the last 90 days"
    type:  yesno
    sql: ${created_date} >= DATE_ADD(CURRENT_DATE(), INTERVAL -90 DAY);;
  }

  dimension: customer_signup_last_year_indicator {
    description: "Indicates if the customer signup up to the website last year"
    type:  yesno
    # sql: ${created_year} = FORMAT_DATE('%Y', DATE_SUB(current_date(), INTERVAL 1 YEAR)) ;;
    sql: cast( ${created_year} as integer) =    cast ( FORMAT_DATE('%Y',    DATE_SUB(current_date(), INTERVAL 1 YEAR))    as integer) ;;
  }

  dimension: customer_signup_last_month_indicator {
    description: "Indicates if the customer signup up the the website last month"
    type: yesno
    #sql:  ${months_since_signup} = 1 ;;
    sql: cast( ${created_month} as string) =  cast(FORMAT_DATE('%Y-%m',    DATE_SUB(current_date(), INTERVAL 1 MONTH))  as string) ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_age {
    type: sum
    sql: ${age} ;;
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    drill_fields: [state]
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: days_since_signup {
    description: "The number of days since a customer has signed up on the website"
    type: number
    sql:  DATE_DIFF(CURRENT_DATE(), ${created_date} , DAY) ;;
  }

  dimension: months_since_signup {
    description: "The number of months since a customer has signed up on the website"
    type: number
    sql:  DATE_DIFF(CURRENT_DATE(), ${created_date} , MONTH) ;;
  }

  ########## GO BACK AND TEST SUBSTRITUTION FOR DIMS ABOVE   #############
  dimension_group: signup_duration {
    type: duration
    timeframes: [date, month]
    sql_start: ${created_date} ;;
    sql_end:  CURRENT_DATE() ;;
  }

  measure: average_days_since_signup {
    description: "The average number of days since a customer has signed up on the website"
    type: average
    sql:  ${days_since_signup} ;;
  }

  measure: average_months_since_signup {
    description: "The average number of months since a customer has signed up on the website"
    type: average
    sql:  ${months_since_signup} ;;
  }




  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: street_address {
    type: string
    sql: ${TABLE}.street_address ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  measure: count {
    label: "Count of Users"
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [id, last_name, first_name, events.count, order_items.count]
  }
}

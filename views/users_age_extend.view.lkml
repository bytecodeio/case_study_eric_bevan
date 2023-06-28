include: "users.view"
view: users_age_extend {
  extends: [users]

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

  measure: total_age {
    type: sum
    sql: ${age} ;;
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
  }
}

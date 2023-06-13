# Define the database connection to be used for this model.
connection: "looker_partner_demo"

# include all the views
include: "/views/inventory_cross_view.view"
include: "/views/inventory_items.view"
include: "/views/order_items.view"
include: "/views/users.view"
include: "/views/distribution_centers.view"
include: "/views/events.view"
include: "/views/products.view"
include: "/views/ndt_user_sales_rollup.view"
include: "/views/dt_user_sales_monthly_rollup.view"
include: "/views/ndt_user_prodcat.view"
include: "/views/derived_tables/dt_user_order_sequence.view"
include: "/views/parameters/parameters.view"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: case_study_eric_bevan_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
   max_cache_age: "1 hour"
}

persist_with: case_study_eric_bevan_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Case Study Eric Bevan"

# To create more sophisticated Explores that involve multiple views, you can use the join parameter.
# Typically, join parameters require that you define the join type, join relationship, and a sql_on clause.
# Each joined view also needs to define a primary key.

explore: distribution_centers {}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: events {
  label: "Sales Events"
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users {
  label: "Customers"
  join: ndt_user_sales_rollup {
    view_label: "User Sales Rollup"
    type: left_outer
    sql_on: ${users.id} = ${ndt_user_sales_rollup.user_id} ;;
    relationship: one_to_one
  }
  join: dt_user_sales_monthly_rollup {
    view_label: "User Monthly Sales Rollup"
    type:  left_outer
    sql_on: ${users.id} = ${dt_user_sales_monthly_rollup.user_id} ;;
    relationship: one_to_many
  }

}

explore: order_items {
  # group_label: "Online Store Analysis"
  label: "Sales"

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }



  join: ndt_user_sales_rollup {
    view_label: "User Sales Rollup"
    type: left_outer
    sql_on: ${users.id} = ${ndt_user_sales_rollup.user_id} ;;
    relationship: one_to_one
  }

  join: dt_user_order_sequence {
    view_label: "User Frequency"
    type: left_outer
     sql_on:  ${users.id} = ${dt_user_order_sequence.user_id};;
    relationship: one_to_many
  }


  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: inventory_cross_view {
    view_label: "Order Items"
    sql:  ;;
  relationship: one_to_one
  }

  join: parameters {
    view_label: "Order Items"
    sql:  ;;
  relationship: one_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${order_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: ndt_user_prodcat {
    type:  left_outer
    sql_on: ${order_items.user_id} = ${ndt_user_prodcat.user_id} AND ${products.category} = ${ndt_user_prodcat.category};;
    relationship: many_to_many
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

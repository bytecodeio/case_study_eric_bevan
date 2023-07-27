connection: "looker_partner_demo"

include: "/views/training_views/users.view.lkml"                # include all views in the views/ folder in this project
include: "/views/training_views/order_items.view.lkml"                # include all views in the views/ folder in this project

# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.

explore: order_items {
  join: users {
    relationship: many_to_one
    sql_on: ${users.id} = ${order_items.user_id} ;;
    type:  left_outer
  }
}

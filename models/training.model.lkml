# Define one connection for a model file

connection: "looker_partner_demo"


# # Select the views that should be a part of this model,
# # and define the joins that connect them together.

include: "/views/training_views/users.view.lkml"
include: "/views/training_views/order_items.view.lkml"


include: "/explores/order_items.explore.lkml"


# explore: order_items {
#   description: "Provide insight to users and their order items"
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${order_items.user_id} ;;
#     type:  left_outer
#   }
# }

include: "/views/training_views/training_derived_tables/dt_state_sales_rollup.view.lkml"

explore:  regional_sales {
  from: dt_state_sales_rollup
}

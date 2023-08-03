include: "/views/training_views/users.view.lkml"
include: "/views/training_views/order_items.view.lkml"


# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard


explore: order_items {
  description: "Provide insight to users and their order items"
  join: users {
    relationship: many_to_one
    sql_on: ${users.id} = ${order_items.user_id} ;;
    type:  left_outer
  }
}

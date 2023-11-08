include: "/views/training_views/users.view.lkml"
include: "/views/training_views/order_items.view.lkml"
include: "/views/training_views/cross_views/cv_order_items_china.view.lkml"
include: "/views/training_views/pop_order_items.view.lkml"


explore: order_items {
  view_name: pop_order_items
  view_label: "Order Items"
  description: "Provide insight to users and their order items"
  join: users {
    relationship: many_to_one
    sql_on: ${users.id} = ${pop_order_items.user_id} ;;
    type:  left_outer
  }

  join: cv_order_items_china {
    relationship: one_to_one
    sql:  ;;
  }
}

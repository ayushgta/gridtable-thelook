# PRELIMINARIES #
- connection: thelook
- scoping: true                          # for backward compatibility
- include: "*.view.lookml"       # include all the views
- include: "*.dashboard.lookml"  # include all the dashboards
- label: 'The Look'

# EXPLORES #

- explore: order_items
  view: order_items
  joins:

    - join: orders
      foreign_key: order_items.order_id

    - join: products
      foreign_key: inventory_items.product_id

    - join: users
      foreign_key: orders.user_id

    - join: users_orders_facts
      foreign_key: users.id
  
    - join: inventory_items
      foreign_key: order_items.inventory_item_id
      #fields: inventory_items.export        # don't import all of the fields, just the fields in this set.



- explore: inventory_items
  joins:
    - join: products
      foreign_key: inventory_items.product_id
      
- explore: orders
  persist_for: 6 hours
  joins:
    - join: users
      foreign_key: orders.user_id

    - join: users_orders_facts
      foreign_key: users.id

- explore: funnel
  always_filter:
    event_time: 30 days ago for 30 days
  joins:
  - join: users
    foreign_key: user_id
    
  - join: users_orders_facts
    foreign_key: users.id
 
  - join: orders
    foreign_key: order_id
    
    
- explore: products

- explore: users
#   required_joins: [users_orders_facts, users_revenue_facts, users_sales_facts]
  joins:
  - join: users_orders_facts
    foreign_key: users.id

  - join: users_revenue_facts
    foreign_key: users.id   
    relationship: one_to_one

  - join: users_sales_facts
    foreign_key: users.id

- explore: users_cohorts
  from: users
  joins:
  - join: users_orders_facts
    foreign_key: users_cohorts.id

  - join: users_revenue_facts
    foreign_key: users_cohorts.id   
    relationship: one_to_one

  - join: users_sales_facts
    foreign_key: users_cohorts.id
  
  - join: user_transactions_monthly
    sql_on: user_transactions_monthly.user_id = users_cohorts.id
    relationship: many_to_one
  
  - join: user_transactions_monthly_cumulative
    required_joins: [user_transactions_monthly]
    sql_on: user_transactions_monthly_cumulative.user_id = users_cohorts.id
            AND user_transactions_monthly_cumulative.month = user_transactions_monthly.month
    relationship: many_to_one


# - explore: user_order_speed
#   joins:
#   - join: users
#     foreign_key: user_order_speed.user_id


# - explore: order_purchase_affinity
#   joins: 
#     - join: product_a_detail
#       from: products
#       sql_on: order_purchase_affinity.product_a = product_a_detail.item_name
#     
#     - join: product_b_detail
#       from: products
#       sql_on: order_purchase_affinity.product_b = product_b_detail.item_name

#   conditionally_filter:
#     orders.created_date: 30 days
#     unless: [users.name, users.id]

#   conditionally_filter:                     # prevent runaway queries
#     orders.created_date: 30 days          # by always requiring a filter
#     unless:                                 # on one of the fields below.
#       - orders.created_time
#       - orders.created_week
#       - orders.created_month
#       - users.name
#       - users.id
#       - products.id
#       - products.item_name
#     - join: users_first_order_facts_weekly
#       sql_on: ${users_first_order_facts_weekly.first_order_week} = ${users_orders_facts.first_order_week}
#       join_type: many_to_one
# 
#     - join: users_first_order_facts_monthly
#       sql_on: ${users_first_order_facts_monthly.first_order_month} = ${users_orders_facts.first_order_month}
#       join_type: many_to_one

    
# - explore: order_purchase_affinity
#   joins: 
#     - join: product_a_detail
#       from: products
#       sql_on: order_purchase_affinity.product_a = product_a_detail.item_name
#     
#     - join: product_b_detail
#       from: products
#       sql_on: order_purchase_affinity.product_b = product_b_detail.item_name

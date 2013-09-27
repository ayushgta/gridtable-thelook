- view: orders
  fields:

  - dimension: status

  - dimension: total_amount_of_order_usd
    type: number
    decimals: 2
    sql: |
      (SELECT SUM(order_items.sale_price) FROM order_items WHERE order_items.order_id = orders.id)

  - dimension: total_amount_of_order_usd_tier
    type: tier
    sql: ${total_amount_of_order_usd}
    tiers: [0,10,50,150,500,1000]

  - dimension: order_items_list
    sql: |
      (
        SELECT GROUP_CONCAT(products.item_name) 
        FROM order_items
        LEFT JOIN inventory_items ON order_items.inventory_item_id = inventory_items.id
        LEFT JOIN products ON inventory_items.product_id = products.id
        WHERE order_items.order_id = orders.id
      )

  - dimension: average_total_amount_of_order_usd
    type: avg
    sql: ${total_amount_of_order_usd}
    decimals: 2

  - dimension: total_cost_of_order
    type: number
    decimals: 2
    sql: |
      (
        SELECT SUM(inventory_items.cost)
        FROM order_items
        LEFT JOIN inventory_items ON order_items.inventory_item_id = inventory_items.id
        WHERE order_items.order_id = orders.id
      )

  - dimension: total_number_of_items
    type: int
    sql: |
      (SELECT COUNT(order_items.id) FROM order_items WHERE order_items.order_id = orders.id)

  - dimension: order_profit
    type: number
    decimals: 2
    sql: ${total_amount_of_order_usd} - ${total_cost_of_order}
    html: |
      $<%= rendered_value %> 
 
  - dimension: order_sequence_number
    type: number
    sql: |
      (SELECT COUNT(*) 
      FROM orders o
      WHERE o.id < ${TABLE}.id
        AND o.user_id=${TABLE}.user_id)+1
        
  - dimension: is_activation
    type: yesno
    sql: ${order_sequence_number} = 1
    
  - measure: count
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail
 
  - measure: total_activation_revenue
    type: sum
    sql: case when ${order_sequence_number} = 1 then ${total_amount_of_order_usd} else 0 end
    decimals: 2
    
  - measure: total_activation_count
    type: count_distinct
    sql: CASE WHEN ${order_sequence_number} = 1 THEN ${id} ELSE NULL END
    
  - measure: total_returning_shopper_revenue
    type: sum
    sql: case when ${order_sequence_number} > 1 then ${total_amount_of_order_usd} else 0 end
    decimals: 2  
 
  - measure: total_order_profit
    type: sum
    sql: ${order_profit}
    decimals: 2
    html: |
      $<%= rendered_value %>

  - measure: average_order_profit
    type: average
    sql: ${order_profit}
    decimals: 2

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month, month_num, year]
    sql: ${TABLE}.created_at

  - dimension: id
    type: int

  - dimension: user_id
    type: int
    sets:
      - ignore
      

  # ----- Detail ------
  sets:
    detail:
      - id
      - created_time
      - users.name
      - users.history
      - total_cost_of_order
        # Counters for views that join 'orders'
      - order_items.count
      - products.list

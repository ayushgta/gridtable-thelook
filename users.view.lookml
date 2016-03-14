- view: users
  sql_table_name: users
  
  # START PARSE
  my_descriptions:
    description_user_age: &description_user_age
      description: "Hello this is My Descriptiowangiowefnfw"
  # END PARSE
  
  fields:

# DIMENSIONS # 

  - dimension: id
    type: int
    primary_key: true
    sql: ${TABLE}.id 

  - dimension: age
    type: number
    description: "foo" # REPLACEME: users.age

  - measure: average_age
    type: average
    decimals: 2
    sql: ${age}

  - dimension: age_tier
    type: tier
    style: integer
    sql: ${age}
    tiers: [0,10,20,30,40,50,60,70,80]

  - dimension: old
    type: yesno
    sql: ${age} > 30

  - dimension: city

  - dimension: country

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month, year]
    sql: ${TABLE}.created_at

  - dimension: email
    html: |
      {{ linked_value }}
      <a href="/dashboards/thelook/4_user_lookup?email={{ value | encode_uri }}" target="_new">
      <img src="/images/qr-graph-line@2x.png" height=20 width=20></a>  

  - dimension: gender

  - dimension: name
    sql: CONCAT(${TABLE}.first_name,' ', ${TABLE}.last_name)

  - dimension: history
    sql: ${TABLE}.id
    html: |
      <a href="/explore/thelook/orders?fields=orders.detail*&f[users.id]={{ value }}">Orders</a>
      | <a href="/explore/thelook/order_items?fields=order_items.detail*&f[users.id]={{ value }}">Items</a>
  
  - dimension: state


  - dimension: zip
    hidden: true
    type: zipcode

  - dimension: zipcode
    type: zipcode
    sql: ${zip}

# MEASURES #

  - measure: count
    type: count
    sql: COALESCE(${id}, 0)
    drill_fields: detail

  - measure: count_percent_of_total
    label: Count (Percent of Total)
    type: percent_of_total
    drill_fields: detail*
    decimals: 1
    sql: ${count}

# SETS #

  sets:
    detail:
      - id
      - name
      - email
      - city
      - state
      - country
      - zip
      - gender
      - age
      - history
#         # Counters for views that join 'users'
      - orders.count
      - order_items.count 






# kittens for certain demos

- explore: kitten_order_items
  label: 'Order Items (Kittens)' 
  hidden: true
  extends: order_items 
  joins:
    - join: users
      from: kitten_users

- view: kitten_users
  extends: users
  fields:
  - dimension: kitten_portrait
    sql: GREATEST(MOD(${id}*97,867),MOD(${id}*31,881),MOD(${id}*72,893))
    html: |
      <img height=120 width=120 src="http://placekitten.com/g/{{ value }}/{{ value }}">

  - dimension: kitten_name
    sql: CONCAT(${kitten_first_name},' ', ${TABLE}.last_name)

  - dimension: kitten_first_name
    sql_case:
      Bella: MOD(${id},24) = 23
      Bandit: MOD(${id},24) = 22
      Tigger: MOD(${id},24) = 21
      Boots: MOD(${id},24) = 20
      Chloe: MOD(${id},24) = 19
      Maggie: MOD(${id},24) = 18
      Pumpkin: MOD(${id},24) = 17
      Oliver: MOD(${id},24) = 16
      Sammy: MOD(${id},24) = 15
      Shadow: MOD(${id},24) = 14
      Sassy: MOD(${id},24) = 13
      Kitty: MOD(${id},24) = 12
      Snowball: MOD(${id},24) = 11
      Snickers: MOD(${id},24) = 10
      Socks: MOD(${id},24) = 9
      Gizmo: MOD(${id},24) = 8
      Jake: MOD(${id},24) = 7
      Lily: MOD(${id},24) = 6
      Charlie: MOD(${id},24) = 5
      Peanut: MOD(${id},24) = 4
      Zoe: MOD(${id},24) = 3
      Felix: MOD(${id},24) = 2
      Mimi: MOD(${id},24) = 1
      Jasmine: MOD(${id},24) = 0
  
  
  - dimension: age_two
    extends: age
    description: how old people are
  
  
  sets:
    detail: [SUPER*, kitten_first_name, kitten_portrait]

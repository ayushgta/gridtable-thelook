view: users {
  sql_table_name: users ;;
  # DIMENSIONS #

  dimension: id {
    type: number
    primary_key: yes
    sql: ${TABLE}.id ;;
    tags: ["user_id", "braze_id", "external_id"]

    link: {
      label: "View Order History"
      url: "/explore/thelook/orders?fields=orders.detail*&f[users.id]={{ value }}"
    }

    link: {
      label: "View Item History"
      url: "/explore/thelook/order_items?fields=order_items.detail*&f[users.id]={{ value }}"
    }
  }

  dimension: age {
    type: number
  }

  measure: average_age {
    type: average
    value_format_name: decimal_2
    sql: ${age} ;;
  }

  dimension: age_tier {
    type: tier
    style: integer
    sql: ${age} ;;
    tiers: [
      0,
      10,
      20,
      30,
      40,
      50,
      60,
      70,
      80
    ]
  }

  dimension: city {
    drill_fields: [zipcode]
  }

  dimension: state {
    drill_fields: [city, zipcode]
    link: {
      label: "lookup"
      url: "https://google.com?q={{ value }}"
      icon_url : "https://looker.com/favicon.ico"
    }
  }

  dimension: country {
    drill_fields: [state, city, zipcode]
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zip ;;
    alias: [zip]
    drill_fields: [gender, age_tier]
  }

  #   - dimension: country_first_letter
  #     type: string
  #     expression: substring(${country},0,1)

  dimension_group: created {
    type: time
    timeframes: [time, date, week, month, year, raw]
    sql: ${TABLE}.created_at ;;
  }

  dimension: image {
    sql: CONCAT("https://picsum.photos/seed/shadow@mailinator.com/", ROUND(FLOOR(RAND()*(200-50)+50), -1), "/", ROUND(FLOOR(RAND()*(200-50)+50), -1)) ;;
    html: <div>
            <img src="{{ value }}">
          </div>;;
  }

  dimension: bio {
    sql: LEFT("The book certainly focuss. Four prayers that the arithmetic bottles had drunk were the new tools. Until they can relax with its warrant, had the teams that confusions had unbent signed the discoveries of communion without amplitude? Before coal rigid as bus extended, had food rested? Combination hidden as boss lives to mark her. Before succeeding has verged,a cloud is a distinctive shade, and a knee whose awe has cried is a seriously distinguishing figure. The ability-billing voice stretches for candles around algebra. Combination whose world was glancing surrendered; guided near cause,double drawings (triple veils) farmed this. Where agreeing had brought forth every extraordinary crease who can't dream,who were you shaping?", FLOOR(RAND()*(600-10)+10)) ;;
    html:  <div>{{ value }}</div> ;;
  }

  dimension: note {
    sql: CONCAT(LEFT("The original treaty: Babel whose eternity feared to advance. The later drink races cider; and setting: a spring. A whale --  had a panel whose caution ran vibrated? The port sensitive  as tale (a wild dress who learns the class) works. An insect  out of a horn is every caution year. Although a family that  the decree totally dissipated transformed identifying, indeed  ending difference planned to parade. A detailed governor  who blinks paces for twelve paths. The reaction was their  older suitcase whose trial might travel. Why don't carbons  upon a sheep blink? Balancing us, the comfort motor cared  below the string. Though drifting rather attended from August, a border who was balancing would affect the frost strength  that the landing twisted.", FLOOR(RAND()*(600-10)+10))) ;;
    html: <div><details><summary>note</summary><div>{{ value }}</div></details></div> ;;
  }

  dimension: email {
    link: {
      url: "/dashboards/thelook/4_user_lookup?email={{ value | encode_uri }}"
      label: "User Lookup for {{ value }}"
    }
    tags: ["email", "braze_id"]
  }

  dimension: phone {
    sql: CONCAT("165086", ${id})   ;;
    tags: ["phone"]
  }

  dimension: email_500 {
    sql: ${email} ;;
    suggest_dimension: email_500_suggest
  }

  dimension: email_500_suggest {
    sql: CASE
        WHEN ${email} like 'd%' THEN ${email}
        ELSE NULL
      END
       ;;
  }

  dimension: email_1000 {
    sql: ${email} ;;
    suggest_dimension: email_1000_suggest
  }

  dimension: email_1000_suggest {
    sql: CASE
        WHEN ${email} like 'z%' THEN ${email}
        WHEN ${email} like 'y%' THEN ${email}
        WHEN ${email} like 'w%' THEN ${email}
        WHEN ${email} like 'v%' THEN ${email}
        ELSE NULL
      END
       ;;
  }

  dimension: gender {}

  dimension: name {
    sql: CONCAT(${TABLE}.first_name,' ', ${TABLE}.last_name) ;;
  }

  filter: dimension_picker {
    suggestions: ["gender", "age"]
  }

  dimension: dimension_value {
    type: string
    hidden: yes
    sql: {% parameter dimension_picker %}
      ;;
  }

  dimension: dimension {
    sql:
          {% assign dim = dimension_value._sql %}
          {% if dim contains 'gender' %} users.gender
          {% elsif dim contains 'age' %} users.age
          {% else %} NULL
          {% endif %};;
  }

  filter: measure_picker {
    suggestions: ["id", "age"]
  }

  filter: aggregation_picker {
    suggestions: ["count", "sum", "average", "min", "max"]
  }

  dimension: measure_value {
    type: string
    hidden: yes
    sql: {% parameter measure_picker %}
      ;;
  }

  dimension: aggregation_value {
    type: string
    hidden: yes
    sql: {% parameter aggregation_picker %}
      ;;
  }

  measure: measure {
    type:  number
    sql:
          {% assign agg = aggregation_value._sql %}
          {% if agg contains 'count' %} count(
          {% elsif agg contains 'sum' %} sum(
          {% elsif agg contains 'average' %} average(
          {% elsif agg contains 'min' %} min(
          {% elsif agg contains 'max' %} max(
          {% else %} NULL
          {% endif %}
          {% assign mea = measure_value._sql %}
          {% if mea contains 'id' %} users.id)
          {% elsif mea contains 'age' %} users.age)
          {% else %} NULL
          {% endif %};;
    }

  # MEASURES #

  measure: count {
    type: count_distinct
    sql: COALESCE(${id}, 0) ;;
    drill_fields: [detail*]
  }

  measure: count_percent_of_total {
    label: "Count (Percent of Total)"
    type: percent_of_total
    drill_fields: [detail*]
    value_format_name: decimal_1
    sql: ${count} ;;
  }

  # SETS #

  set: detail {
    fields: [
      id,
      name,
      email,
      city,
      state,
      country,
      zipcode,
      gender,
      age,

      #         # Counters for views that join 'users'
      orders.count,
      order_items.count
    ]
  }
}

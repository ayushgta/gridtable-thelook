- dashboard: micahs_dashboard
  title: Micah's Dashboard
  layout: newspaper
  elements:
  - name: Customer List Look
    title: Customer List Look
    model: thelook
    explore: customer_list
    type: looker_scatter
    fields:
    - customer_list.name
    - customer_list.point_of_contact
    - customer_list.release
    - customer_list.size
    - customer_list.standard_premium
    filters:
      customer_list.release: "-NULL"
      customer_list.name: "-NULL"
    sorts:
    - customer_list.release desc
    limit: 500
    query_timezone: America/Los_Angeles
    series_types: {}
    listen: {}
    row: 0
    col: 8
    width: 8
    height: 6
  - name: Event List Count
    title: Event List Count
    model: thelook
    explore: event_list
    type: looker_column
    fields:
    - event_list.zipcode
    - event_list.previous_customer
    - event_list.name
    - event_list.gender
    - event_list.event_name
    - event_list.email
    - event_list.count
    sorts:
    - event_list.zipcode
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    point_style: none
    series_types: {}
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    row: 0
    col: 0
    width: 8
    height: 6

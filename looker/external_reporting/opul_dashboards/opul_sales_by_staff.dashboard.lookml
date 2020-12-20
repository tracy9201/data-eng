- dashboard: opul_sales_by_staff
  title: Sales by Staff Member
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: New Tile
    name: New Tile
    model: external_reporting_opul
    explore: fact_sales_by_staff
    type: table
    fields: [dim_staff_opul.staff_name, fact_sales_by_staff.current_period_sales, fact_sales_by_staff.previous_period_sales,
      fact_sales_by_staff.sales_pop_change]
    filters:
      fact_sales_by_staff.first_start_period_filter: start_date
      fact_sales_by_staff.first_end_period_filter: end_date
      fact_sales_by_staff.second_start_period_filter: comparison_start_date
      fact_sales_by_staff.second_end_period_filter: comparison_end_date
      fact_sales_by_staff.period_selected: "-NULL"
    sorts: [fact_sales_by_staff.current_period_sales desc]
    limit: 500
    total: true
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    transpose: false
    truncate_text: true
    size_to_fit: true
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    title_hidden: true
    listen: {}
    row: 0
    col: 0
    width: 24
    height: 13

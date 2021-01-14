- dashboard: test
  title: test
  layout: newspaper
  preferred_viewer: dashboards
  elements:
  - title: Untitled
    name: Untitled
    model: looker_hintmd
    explore: batch_report_details
    type: looker_grid
    fields: [batch_report_details.sales_amount, batch_report_details.card_first_2_digits,
      batch_report_details.device_id, batch_report_details.gx_subscription_id, batch_report_details.sales_type,
      batch_report_details.sales_details, batch_report_details.sales_id, batch_report_details.sum_amount,
      batch_report_details.sum_total]
    sorts: [batch_report_details.sum_amount desc]
    limit: 500
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    defaults_version: 1
    listen: {}
    row: 0
    col: 1
    width: 22
    height: 14
  - title: abc
    name: abc
    model: matillion_hintmd
    explore: batch_report_details
    type: single_value
    fields: [batch_report_details.blank]
    sorts: [batch_report_details.blank]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    defaults_version: 1
    listen: {}
    row: 0
    col: 0
    width: 2
    height: 14

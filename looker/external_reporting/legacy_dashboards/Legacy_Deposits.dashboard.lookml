- dashboard: Deposits
  title: Deposits2
  layout: newspaper
  elements:
  #- title: Upcoming
  #  name: Upcoming
  #  model: matillion_hintmd
  #  explore: today_upcoming_deposits_derived
  #  type: single_value
  #  fields: [today_upcoming_deposits_derived.upcoming_deposit]
  #  limit: 500
  #  query_timezone: America/Los_Angeles
  #  custom_color_enabled: true
  #  custom_color: "#9478BA"
  #  show_single_value_title: false
  #  show_comparison: false
  #  comparison_type: value
  #  comparison_reverse_colors: false
  #  show_comparison_label: true
  # listen: {}
  #  row: 2
  # col: 12
  #  width: 12
  # height: 6
  - title: Funding_details_Tile
    name: Funding_details_Tile
    model: matillion_hintmd
    explore: payment_summary
    type: single_value
    fields: [payment_summary.Funding_details_Tile]
    sorts: [payment_summary.Funding_details_Tile]
    limit: 500
    query_timezone: user_timezone
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
    listen: {}
    row: 8
    col: 0
    width: 24
    height: 2
  - title: Funding details
    name: Funding details
    model: matillion_hintmd
    explore: deposit_summary
    type: table
    fields: [deposit_summary.funding_date, deposit_summary.funding_master_id, deposit_summary.status, deposit_summary.net_sales,
      deposit_summary.chargebacks, deposit_summary.adjustments, deposit_summary.fees,
      deposit_summary.total_funding ]
    sorts: [deposit_summary.funding_date desc]
    limit: 500
    query_timezone: user_timezone
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: unstyled
    series_labels:
      deposit_summary.funding_date: Date Funded
      deposit_summary.total_funding: Total Deposited
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    title_hidden: true
    listen:
      Date Filter: deposit_summary.funding_date
    row: 10
    col: 0
    width: 24
    height: 16
  - title: Total Deposits
    name: Total Deposits
    model: matillion_hintmd
    explore: deposit_summary
    type: single_value
    fields: [deposit_summary.total_funds]
    sorts: [deposit_summary.total_funds desc]
    limit: 500
    query_timezone: user_timezone
    custom_color_enabled: true
    #custom_color: "#684A91"
    custom_color: "#4194FB"
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    listen:
      Date Filter: deposit_summary.funding_date
    row: 2
    col: 0
    width: 5
    height: 6
  - title: Note_Tile
    name: Note_Tile
    model: matillion_hintmd
    #explore: payment_summary
    explore: top_product_sales
    type: single_value
    fields: [product_sales.Note_Tile]
    sorts: [product_sales.Note_Tile]
    #fields: [payment_summary.Note_Tile]
    #sorts: [payment_summary.Note_Tile]
    limit: 500
    query_timezone: user_timezone
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
    listen: {}
    row: 0
    col: 9
    width: 15
    height: 1
  - title: Note Tile Left
    name: Note Left
    model: matillion_hintmd
    #explore: payment_summary
    explore: top_product_sales
    type: single_value
    fields: [product_sales.Note_Tile_Left]
    sorts: [product_sales.Note_Tile_Left]
    #fields: [payment_summary.Note_Tile_Left]
    #sorts: [payment_summary.Note_Tile_Left]
    limit: 500
    query_timezone: user_timezone
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
    listen: {}
    row: 0
    col: 0
    width: 10
    height: 1
  - title: Total Deposits 7 days
    name: Total Deposits 7 days
    model: matillion_hintmd
    explore: deposit_summary
    type: single_value
    fields: [deposit_summary.total_funds_7_days]
    filters:
      deposit_summary.funding_date_time_date: 7 days
    limit: 500
    query_timezone: user_timezone
    custom_color_enabled: true
    custom_color: "#4194FB"
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen: {}
    row: 2
    col: 5
    width: 5
    height: 6
  - title: Total deposit current month
    name: Total deposit current month
    model: matillion_hintmd
    explore: deposit_summary
    type: single_value
    fields: [deposit_summary.total_funds_current_month]
    filters:
      deposit_summary.funding_date_time_date: this month
    limit: 500
    query_timezone: user_timezone
    custom_color_enabled: true
    custom_color: "#4194FB"
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen: {}
    row: 2
    col: 10
    width: 5
    height: 6
  - title: total deposits Last month
    name: total deposits Last month
    model: matillion_hintmd
    explore: deposit_summary
    type: single_value
    fields: [deposit_summary.total_funds_last_month]
    filters:
      deposit_summary.funding_date_time_date: last month
    limit: 500
    query_timezone: user_timezone
    custom_color_enabled: true
    custom_color: "#4194FB"
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen: {}
    row: 2
    col: 15
    width: 5
    height: 6
  - title: Total deposits current year
    name: Total deposits current year
    model: matillion_hintmd
    explore: deposit_summary
    type: single_value
    fields: [deposit_summary.total_funds_current_year]
    filters:
      deposit_summary.funding_date_time_date: this year
    limit: 500
    query_timezone: user_timezone
    custom_color_enabled: true
    custom_color: "#4194FB"
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    row: 2
    col: 20
    width: 4
    height: 6
  filters:
  - name: Date Filter
    title: Date Filter
    type: date_filter
    #default_value: 1 days
    default_value: today
    allow_multiple_values: true
    required: false

- dashboard: daily_batch_summary
  title: QA Daily Batch Summary
  layout: newspaper
  embed_style:
   background_color: "#ffffff"
   show_title: true
   title_color: "#3a4245"
   show_filters_bar: true
   tile_text_color: "#3a4245"
  elements:
  - title: Note Tile
    name: Note
    model: looker_hintmd
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
    model: looker_hintmd
    explore: top_product_sales
    type: single_value
    fields: [product_sales.Note_Tile_Left]
    sorts: [product_sales.Note_Tile_Left]
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

  - title: Payment_Methods_Tile
    name: Payment_Methods_Tile
    model: looker_hintmd
    #explore: payment_summary
    explore: date_table
    type: single_value
    fields: [batch_report_summary.Sales_by_payment_method_tile]
    sorts: [batch_report_summary.Sales_by_payment_method_tile]
    limit: 500
    custom_color_enabled: true
    query_timezone: user_timezone
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
    col: 8
    width: 8
    height: 2

  - title: Transaction Count By Payment Method
    name: Transaction Count By Payment Method
    model: looker_hintmd
    explore: date_table
    type: looker_pie
    #fields: [payment_summary.sales_type, payment_summary.count]
    fields: [batch_report_summary.sales_type, batch_report_summary.countTest]
    fill_fields: [batch_report_summary.sales_type]
    filters: {}
    sorts: [batch_report_summary.count desc]
    limit: 500
    query_timezone: user_timezone
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    series_colors:
      CASH: "#43B772"
      CHECK: "#FFD452"
      CREDIT CARD: "#4194FB"
      BD: "#654054"
      PRACTICE CREDIT: "#F1654F"
      OTHER: "#0164B2"
      #TIPPING: "#848484"
      RECURRING PMT: "#684A91"
    series_types: {}
    title_hidden: true
    listen:
      Date: date_table.date_date
    row: 3
    col: 8
    width: 8
    height: 7

  - title: Top Product Tile
    name: Top Product Tile
    model: looker_hintmd
    explore: top_product_sales
    type: single_value
    fields: [product_sales.top_five_products]
    sorts: [product_sales.top_five_products]
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
    row: 2
    col: 16
    width: 8
    height: 2

  - title: Top Product Sales
    name: Top Product Sales
    model: looker_hintmd
    explore: top_product_sales
    type: looker_bar
    fields: [product_sales.subscription_name, product_sales.total_amount]
    filters: {}
    sorts: [product_sales.total_amount desc]
    limit: 5
    query_timezone: user_timezone
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: bottom, series: [{axisId: product_sales.total_amount,
            id: product_sales.total_amount, name: Sales}], showLabels: true, showValues: true,
        valueFormat: "$#", unpinAxis: false, tickDensity: custom, tickDensityCustom: 5,
        type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    label_value_format: ''
    series_types: {}
    point_style: none
    series_colors:
      product_sales.total_amount: "#684A91"
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    title_hidden: true
    listen:
      Date: top_product_sales.date_date
    row: 3
    col: 16
    width: 8
    height: 7

  - title: Grand Total
    name: Grand Total
    model: looker_hintmd
    explore: date_table
    type: single_value
    #fields: [payment_summary.sum_amount]
    fields: [batch_report_summary.sum_amount_tile]
    filters: {}
    limit: 500
    query_timezone: user_timezone
    custom_color_enabled: true
    custom_color: "#000000"
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    listen:
      Date: date_table.date_date
    row: 2
    col: 0
    width: 8
    height: 9
  - title: Total Retail Tile
    name: Total Retail Tile
    model: looker_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_total_retail]
    limit: 1000
    query_timezone: user_timezone
    custom_color_enabled: true
    custom_color: "#000000"
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen:
      Date: date_table.date_date
    row: 16
    col: 0
    width: 8
    height: 8

  - title: Total Recurring Payments
    name: Total Recurring Payments
    model: looker_hintmd
    #explore: payment_summary
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_subscription_amount]
    query_timezone: user_timezone
    listen:
      Date: date_table.date_date
    custom_color_enabled: true
    custom_color: "#000000"
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    row: 24
    col: 0
    width: 8
    height: 8

  - title: Cash
    name: Cash
    model: looker_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_cash]
    filters: {}
    limit: 500
    query_timezone: user_timezone
    custom_color_enabled: true
    custom_color: "#43B772"
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    listen:
      Date: date_table.date_date
    row: 16
    col: 8
    width: 4
    height: 4
  - title: Checks
    name: Checks
    model: looker_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_check]
    filters: {}
    limit: 500
    query_timezone: user_timezone
    custom_color_enabled: true
    custom_color: "#FFD452"
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    listen:
      Date: date_table.date_date
    row: 16
    col: 12
    width: 4
    height: 4

  - title: Credit Cards
    name: Credit Cards
    model: looker_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_credit_card]
    filters:
      batch_report_summary.sales_type: CREDIT CARD
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
    listen:
      Date: date_table.date_date
    row: 16
    col: 16
    width: 4
    height: 4
  - title: BD
    name: BD
    model: looker_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_BD]
    filters: {}
    limit: 500
    query_timezone: user_timezone
    custom_color_enabled: true
    custom_color: "#654054"
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    listen:
      Date: date_table.date_date
    row: 20
    col: 8
    width: 4
    height: 4
  - title: Practice Credits
    name: Practice Credits
    model: looker_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_practice_credit]
    filters: {}
    limit: 500
    query_timezone: user_timezone
    custom_color_enabled: true
    custom_color: "#F1654F"
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    listen:
      Date: date_table.date_date
    row: 20
    col: 12
    width: 4
    height: 4
  - title: OTHER
    name: OTHER
    model: looker_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_other]
    filters: {}
    limit: 500
    query_timezone: user_timezone
    custom_color_enabled: true
    custom_color: "#0164B2"
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    listen:
      Date: date_table.date_date
    row: 20
    col: 16
    width: 4
    height: 4

  - title: Total Tipping Payment
    name: Total Tipping Payment
    model: looker_hintmd
    #explore: payment_summary
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_tipping_amount]
    limit: 1000
    query_timezone: user_timezone
    custom_color_enabled: true
    custom_color: "#0B6121"
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen:
      Date: date_table.date_date
    row: 16
    col: 20
    width: 4
    height: 4

  - name: " (5)"
    type: text
    #subtitle_text: USING THE DASHBOARD
    body_text: |-
      USING THE DASHBOARD

      Daily Batch Summary reflects all payments received over the selected time period across retail and recurring charges.


      **Retail** includes all payments received in the practice over the selected time period, including totals for each payment method. The credit card subtotal does not include Tips. Tips only reflects those collected on the HintMini.


      **Recurring Payments** includes all automatic monthly subscription and pay-over-time(installment) payments collected over the selected time period.


      For additional assistance, please use our in-product chat below.
    row: 23
    col: 8
    width: 14
    height: 8


  filters:
  - name: Date
    title: Date
    type: date_filter
    default_value: today
    allow_multiple_values: true
    required: false

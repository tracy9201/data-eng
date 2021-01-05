- dashboard: Payments
  title: Daily Batch Summary
  layout: newspaper
  embed_style:
#    background_color: "#ffffff"
    show_title: true
    title_color: "#3a4245"
    show_filters_bar: true
    tile_text_color: "#3a4245"
  elements:
  - title: Note Tile
    name: Note
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

  - title: Grand Total
    name: Grand Total
    model: matillion_hintmd
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
    row: 1
    col: 0
    width: 8
    height: 9

  - title: Payment_Methods_Tile
    name: Payment_Methods_Tile
    model: matillion_hintmd
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
    row: 1
    col: 8
    width: 8
    height: 2

  - title: Transaction Count By Payment Method
    name: Transaction Count By Payment Method
    model: matillion_hintmd
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
      #PRACTICE CREDIT: "#e22e12"
      OTHER: "#0164B2"
      #TIPPING: "#848484"
      RECURRING PMT: "#684A91"
    series_labels:
      CASH: Cash
      CHECK: Check
      CREDIT CARD: Credit Card
      BD: BD
      PRACTICE CREDIT: Practice Credit
      OTHER: Other
      RECURRING PMT: Recurring Pmt
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
    model: matillion_hintmd
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
    row: 1
    col: 16
    width: 8
    height: 2

  - title: Top Product Sales
    name: Top Product Sales
    model: matillion_hintmd
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
  - title: total card brand tile
    name: total card brand tile
    model: matillion_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.data_by_card_brand]
    # filters:
    #   date_table.date_date: 7 weeks
    sorts: [batch_report_summary.data_by_card_brand]
    limit: 500
    column_limit: 50
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
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
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
    limit_displayed_rows: false
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
    row: 16
    col: 8
    width: 16
    height: 2

  - title: Total By Device Tile
    name: Total By Device Tile
    model: matillion_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.data_by_device]
    # filters:
    #   date_table.date_date: 7 weeks
    sorts: [batch_report_summary.data_by_device]
    limit: 500
    column_limit: 50
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
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
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
    limit_displayed_rows: false
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
    row: 26
    col: 8
    width: 16
    height: 2

  - title: total retail
    name: total retail
    model: matillion_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_total_retail]
    # filters:
    #   date_table.date_date: 7 weeks
    limit: 1000
    column_limit: 50
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
    custom_color: "#000000"
    series_types: {}
    defaults_version: 1
    listen:
      Date: date_table.date_date
    row: 10
    col: 0
    width: 8
    height: 26
  - title: total credit card
    name: total credit card
    model: matillion_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_credit_card]
    filters:
      batch_report_summary.sales_type: CREDIT CARD

    limit: 500
    column_limit: 50
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
    custom_color: "#4194FB"
    defaults_version: 1
    listen:
      Date: date_table.date_date
    row: 13
    col: 14
    width: 5
    height: 3
  - title: Total Check
    name: Total Check
    model: matillion_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_check]
    # filters:
    #   date_table.date_date: 7 weeks
    limit: 500
    column_limit: 50
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
    custom_color: "#FFD452"
    defaults_version: 1
    listen:
      Date: date_table.date_date
    row: 10
    col: 14
    width: 5
    height: 3
  - title: total practice credit
    name: total practice credit
    model: matillion_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_practice_credit]
    # filters:
    #   date_table.date_date: 7 weeks
    limit: 500
    column_limit: 50
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
    #custom_color: "#F1654F"
    custom_color: "#e22e12"
    defaults_version: 1
    listen:
      Date: date_table.date_date
    row: 10
    col: 19
    width: 5
    height: 3
  - title: total BD
    name: total BD
    model: matillion_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_BD]
    # filters:
    #   date_table.date_date: 7 weeks
    limit: 500
    column_limit: 50
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
    custom_color: "#654054"
    defaults_version: 1
    listen:
      Date: date_table.date_date
    row: 13
    col: 8
    width: 6
    height: 3

  - title: Total Cash
    name: Total Cash
    model: matillion_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_cash]
    # filters:
    #   date_table.date_date: 7 weeks
    limit: 500
    column_limit: 50
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
    custom_color: "#43B772"
    defaults_version: 1
    listen:
      Date: date_table.date_date
    row: 10
    col: 8
    width: 6
    height: 3
  - title: total other
    name: total other
    model: matillion_hintmd
    explore: date_table
    type: single_value
    fields: [batch_report_summary.sum_other]
    # filters:
    #   date_table.date_date: 7 weeks
    limit: 500
    column_limit: 50
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
    custom_color: "#0164B2"
    defaults_version: 1
    listen:
      Date: date_table.date_date
    row: 13
    col: 19
    width: 5
    height: 3
  - name: Total by card brand
    title: Total By Card Brand
    model: matillion_hintmd
    explore: date_table
    type: looker_bar
    fields: [batch_report_summary.payment_method, batch_report_summary.sum_amount_tile_test]
    filters:
      batch_report_summary.sales_type: CREDIT CARD
      batch_report_summary.payment_method: Visa,AMEX,Master Card,Discover,All Other
        Cards
    sorts: [batch_report_summary.sum_amount_tile_test desc]
    limit: 500
    column_limit: 50
    total: true
    query_timezone: user_timezone
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: false
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: center
    header_font_size: '18'
    rows_font_size: '18'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      batch_report_summary.sum_visa: VISA
      batch_report_summary.payment_method: Credit Card
      batch_report_summary.sum_amount_tile_test: Net Revenue Last Period
    series_column_widths:
      batch_report_summary.payment_method: 232
      batch_report_summary.sum_amount_tile_test: 309
    series_cell_visualizations:
      batch_report_summary.sum_amount_tile_test:
        is_active: false
        __FILE: looker_hintmd/Payments.dashboard.lookml
        __LINE_NUM: 802
    y_axes: [{label: '', orientation: bottom, series: [{axisId: batch_report_summary.sum_visa,
            id: batch_report_summary.sum_visa, name: VISA, __FILE: looker_hintmd/Payments.dashboard.lookml,
            __LINE_NUM: 807}, {axisId: batch_report_summary.sum_american_express, id: batch_report_summary.sum_american_express,
            name: AMERICAN EXPRESS, __FILE: looker_hintmd/Payments.dashboard.lookml,
            __LINE_NUM: 809}, {axisId: batch_report_summary.sum_discover, id: batch_report_summary.sum_discover,
            name: DISCOVER, __FILE: looker_hintmd/Payments.dashboard.lookml,
            __LINE_NUM: 811}, {axisId: batch_report_summary.sum_master_card, id: batch_report_summary.sum_master_card,
            name: MASTER CARD, __FILE: looker_hintmd/Payments.dashboard.lookml,
            __LINE_NUM: 813}, {axisId: batch_report_summary.sum_other_credit_card, id: batch_report_summary.sum_other_credit_card,
            name: OTHER CREDIT CARD, __FILE: looker_hintmd/Payments.dashboard.lookml,
            __LINE_NUM: 815}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: custom, tickDensityCustom: 5, type: linear, __FILE: looker_hintmd/Payments.dashboard.lookml,
        __LINE_NUM: 807}]
    series_types: {}
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    series_colors:
      batch_report_summary.sum_amount_tile_test: "#684A91"
    defaults_version: 1
    title_hidden: true
    listen:
      Date: date_table.date_date
    row: 18
    col: 8
    width: 8
    height: 8
  - title: Device Data Table
    name: Device Data Table
    model: matillion_hintmd
    explore: batch_report_details
    type: looker_grid
    fields: [batch_report_details.sum_total, device_data.label, device_data.status]
    filters:
      device_data.status: ACTIVE,ARCHIVED

    sorts: [batch_report_details.sum_total desc]
    limit: 5000
    column_limit: 50
    total: true
    query_timezone: user_timezone
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '18'
    rows_font_size: '18'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      batch_report_details.sales_created_at_time: Date & Time
      customer2.customer_type: Customer Type
      staff_details.staff_name: Staff
      customer2.customer_mobile: Phone
      batch_report_details.gratuity_amount: Tip
      customer2.firstname: First name
      customer2.lastname: Last name
      batch_report_details.sum_amount: Amount
      batch_report_details.sum_tipping_amount: Tip
      batch_report_details.sum_total: Total Realized Revenue
    series_column_widths:
      device_data.label: 983
    series_column_widths:
      device_data.label:: 145
      device_data.status:: 125
      batch_report_details.sum_total: 271
    series_cell_visualizations:
      batch_report_details.sum_total:
        is_active: false
    value_labels: legend
    label_type: labPer
    truncate_column_names: false
    defaults_version: 1
    hidden_fields: [batch_report_details.sales_id]
    series_types: {}
    title_hidden: true
    listen:
      Date: date_table.date_date
    row: 28
    col: 16
    width: 8
    height: 8
  - title: Total by Device
    name: Total by Device
    model: matillion_hintmd
    explore: batch_report_details
    type: looker_pie
    fields: [batch_report_details.sum_total, device_data.label]
    filters:
      device_data.status: ACTIVE,ARCHIVED

    sorts: [batch_report_details.sum_total desc]
    limit: 5000
    column_limit: 50
    query_timezone: user_timezone
    value_labels: legend
    label_type: labPer
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    transpose: false
    truncate_text: true
    size_to_fit: true
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    series_labels:
      batch_report_details.sales_created_at_time: Date & Time
      customer2.customer_type: Customer Type
      staff_details.staff_name: Staff
      customer2.customer_mobile: Phone
      batch_report_details.gratuity_amount: Tip
      customer2.firstname: First name
      customer2.lastname: Last name
      batch_report_details.sum_amount: Amount
      batch_report_details.sum_tipping_amount: Tip
    defaults_version: 1
    hidden_fields: [batch_report_details.sales_id]
    show_totals: true
    show_row_totals: true
    title_hidden: true
    listen:
      Date: date_table.date_date
    row: 28
    col: 8
    width: 8
    height: 8

  - name: credit card type table
    title: credit card type table
    model: matillion_hintmd
    explore: date_table
    type: looker_grid
    fields: [ batch_report_summary.payment_method, batch_report_summary.sum_amount_tile_test ]
    filters:
      batch_report_summary.sales_type: CREDIT CARD
      batch_report_summary.payment_method: Visa,AMEX,Master Card,Discover,All Other
        Cards
    sorts: [batch_report_summary.sum_amount_tile_test desc]
    limit: 500
    column_limit: 50
    total: true
    query_timezone: user_timezone
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '18'
    rows_font_size: '18'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      batch_report_summary.sum_visa: VISA
      batch_report_summary.payment_method: Credit Card
      batch_report_summary.sum_amount_tile_test: Net Revenue Last Period
    series_column_widths:
      batch_report_summary.payment_method: 222
      batch_report_summary.sum_amount_tile_test: 319
    series_cell_visualizations:
      batch_report_summary.sum_amount_tile_test:
        is_active: false
        __FILE: looker_hintmd/Payments.dashboard.lookml
        __LINE_NUM: 772
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axes: [{label: '', orientation: bottom, series: [{axisId: batch_report_summary.sum_visa,
            id: batch_report_summary.sum_visa, name: VISA, __FILE: looker_hintmd/Payments.dashboard.lookml,
            __LINE_NUM: 775}, {axisId: batch_report_summary.sum_american_express, id: batch_report_summary.sum_american_express,
            name: AMERICAN EXPRESS, __FILE: looker_hintmd/Payments.dashboard.lookml,
            __LINE_NUM: 776}, {axisId: batch_report_summary.sum_discover, id: batch_report_summary.sum_discover,
            name: DISCOVER, __FILE: looker_hintmd/Payments.dashboard.lookml,
            __LINE_NUM: 778}, {axisId: batch_report_summary.sum_master_card, id: batch_report_summary.sum_master_card,
            name: MASTER CARD, __FILE: looker_hintmd/Payments.dashboard.lookml,
            __LINE_NUM: 779}, {axisId: batch_report_summary.sum_other_credit_card, id: batch_report_summary.sum_other_credit_card,
            name: OTHER CREDIT CARD, __FILE: looker_hintmd/Payments.dashboard.lookml,
            __LINE_NUM: 780}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: custom, tickDensityCustom: 5, type: linear, __FILE: looker_hintmd/Payments.dashboard.lookml,
        __LINE_NUM: 775}]
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
    series_types: {}
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
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    custom_color: "#F1654F"
    defaults_version: 1

    title_hidden: true
    listen:
      Date: date_table.date_date
    row: 18
    col: 16
    width: 8
    height: 8

  - title: Total Recurring Payments
    name: Total Recurring Payments
    model: matillion_hintmd
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
    row: 36
    col: 0
    width: 8
    height: 8




  - name: " (5)"
    type: text
    #subtitle_text: USING THE DASHBOARD
    body_text: |-
      USING THE DASHBOARD

      Daily Batch Summary reflects all payments received over the selected time period across retail and recurring charges.


      **Retail** includes all payments received in the practice over the selected time period, including totals for each payment method. The credit card subtotal does not include Tips. Tips only reflects those collected on the HintMini.


      **Recurring Payments** includes all automatic monthly subscription and pay-over-time(installment) payments collected over the selected time period.


      For additional assistance, please use our in-product chat below.
    row: 36
    col: 10
    width: 8
    height: 8

  filters:
  - name: Date
    title: Date
    type: date_filter
    default_value: today
    allow_multiple_values: true
    required: false

- dashboard: payfac_reporting
  title: Payfac Reporting
  layout: newspaper
  elements:
  - title: Hint Logo
    name: Hint Logo
    model: payfac_reporting
    explore: fact_deposit
    type: single_value
    fields: [fact_deposit.hint_image]
    sorts: [fact_deposit.hint_image]
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
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    defaults_version: 1
    listen:
      Merchant_id: fact_deposit.merchant_id
    row: 0
    col: 0
    width: 23
    height: 5
  - name: YOUR CARD PROCESSING STATEMENT
    type: text
    title_text: YOUR CARD PROCESSING STATEMENT
    row: 5
    col: 0
    width: 23
    height: 2
  - title: Summary Analytics
    name: Summary Analytics
    model: payfac_reporting
    explore: fact_deposit
    type: looker_pie
    fields: [fact_deposit.card_brand, fact_deposit.Total_Amount]
    sorts: [fact_deposit.Total_Amount desc]
    limit: 500
    value_labels: labels
    label_type: labPer
    inner_radius: 34
    series_types: {}
    defaults_version: 1
    listen:
      Merchant_id: fact_deposit.merchant_id
      Month: fact_deposit.settlement_month
    row: 13
    col: 0
    width: 11
    height: 8
  - title: 'Total # of Charges'
    name: 'Total # of Charges'
    model: payfac_reporting
    explore: fact_deposit
    type: single_value
    fields: [fact_deposit.count]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Merchant_id: fact_deposit.merchant_id
      Month: fact_deposit.settlement_month
    row: 13
    col: 11
    width: 4
    height: 4
  - title: Smallest charge amount
    name: Smallest charge amount
    model: payfac_reporting
    explore: fact_deposit
    type: single_value
    fields: [fact_deposit.min_Amount]
    filters:
      fact_deposit.type: Charge
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Merchant_id: fact_deposit.merchant_id
      Month: fact_deposit.settlement_month
    row: 13
    col: 15
    width: 4
    height: 4
  - title: Median charge amount
    name: Median charge amount
    model: payfac_reporting
    explore: fact_deposit
    type: single_value
    fields: [fact_deposit.median_amount]
    filters:
      fact_deposit.type: Charge
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Merchant_id: fact_deposit.merchant_id
      Month: fact_deposit.settlement_month
    row: 17
    col: 11
    width: 4
    height: 4
  - title: Largest charge amount
    name: Largest charge amount
    model: payfac_reporting
    explore: fact_deposit
    type: single_value
    fields: [fact_deposit.max_amount]
    filters:
      fact_deposit.type: Charge
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Merchant_id: fact_deposit.merchant_id
      Month: fact_deposit.settlement_month
    row: 13
    col: 19
    width: 4
    height: 4
  - title: Average charge amount
    name: Average charge amount
    model: payfac_reporting
    explore: fact_deposit
    type: single_value
    fields: [fact_deposit.avg_amount]
    filters:
      fact_deposit.type: Charge
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Merchant_id: fact_deposit.merchant_id
      Month: fact_deposit.settlement_month
    row: 17
    col: 15
    width: 4
    height: 4
  - title: Merchant Info
    name: Merchant Info
    model: payfac_reporting
    explore: dim_address
    type: single_value
    fields: [dim_address.full_address1]
    sorts: [dim_address.full_address1]
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
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    listen:
      Merchant_id: dim_address.merchant_id
    row: 7
    col: 0
    width: 13
    height: 6
  - title: Other Info
    name: Other Info
    model: payfac_reporting
    explore: payfac_deposit_summary
    type: single_value
    fields: [payfac_deposit_summary.Other_info]
    sorts: [payfac_deposit_summary.Other_info]
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
    listen:
      Merchant_id: payfac_deposit_summary.merchant_id
      Month: payfac_deposit_summary.settlement_month
    row: 7
    col: 13
    width: 10
    height: 6
  - title: Merchant Info (copy)
    name: Merchant Info (copy)
    model: payfac_reporting
    explore: dim_address
    type: single_value
    fields: [dim_address.Hint_Address]
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
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    listen:
      Merchant_id: dim_address.merchant_id
    row: 60
    col: 0
    width: 23
    height: 2
  - title: Title Deposit Summary
    name: Title Deposit Summary
    model: payfac_reporting
    explore: payfac_deposit_summary
    type: single_value
    fields: [payfac_deposit_summary.Title_deposit_summary]
    sorts: [payfac_deposit_summary.Title_deposit_summary]
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
    row: 21
    col: 0
    width: 23
    height: 3
  - title: Title Deposit Details
    name: Title Deposit Details
    model: payfac_reporting
    explore: payfac_deposit_details
    type: single_value
    fields: [payfac_deposit_details.Title_deposit_details]
    sorts: [payfac_deposit_details.Title_deposit_details]
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
    row: 26
    col: 0
    width: 23
    height: 3
  - title: Deposit Summary
    name: Deposit Summary
    model: payfac_reporting
    explore: payfac_deposit_summary
    type: looker_grid
    fields: [payfac_deposit_summary.range, payfac_deposit_summary.transactions, payfac_deposit_summary.charges,
      payfac_deposit_summary.refunds, payfac_deposit_summary.chargebacks, payfac_deposit_summary.adjustments]
    sorts: [payfac_deposit_summary.range]
    limit: 500
    dynamic_fields: [{table_calculation: deposits, label: Deposits, expression: "${payfac_deposit_summary.charges}\
          \ -${payfac_deposit_summary.refunds} - ${payfac_deposit_summary.chargebacks}\
          \ - ${payfac_deposit_summary.adjustments}", value_format: !!null '', value_format_name: usd,
        _kind_hint: measure, _type_hint: number}]
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
    series_labels:
      payfac_deposit_summary.range: Date
    series_cell_visualizations:
      payfac_deposit_summary.transactions:
        is_active: false
    header_font_color: "#EFECF3"
    header_background_color: "#684A91"
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
    title_hidden: true
    listen:
      Merchant_id: payfac_deposit_summary.merchant_id
      Month: payfac_deposit_summary.settlement_month
    row: 23
    col: 0
    width: 23
    height: 3
  - title: Title Chargebacks
    name: Title Chargebacks
    model: payfac_reporting
    explore: payfac_chargeback
    type: single_value
    fields: [payfac_chargeback.Title_chargebacks]
    sorts: [payfac_chargeback.Title_chargebacks]
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
    row: 49
    col: 0
    width: 23
    height: 3
  - title: Title Adjustments
    name: Title Adjustments
    model: payfac_reporting
    explore: payfac_adjustment
    type: single_value
    fields: [payfac_adjustment.Title_adjustments]
    sorts: [payfac_adjustment.Title_adjustments]
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
    row: 54
    col: 0
    width: 23
    height: 3
  - title: Title Fee Detail
    name: Title Fee Detail
    model: payfac_reporting
    explore: payfac_fee
    type: single_value
    fields: [payfac_fee.Title_Fee_Detail]
    sorts: [payfac_fee.Title_Fee_Detail]
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
    row: 43
    col: 0
    width: 23
    height: 3
  - title: Chargebacks
    name: Chargebacks
    model: payfac_reporting
    explore: payfac_chargeback
    type: looker_grid
    fields: [payfac_chargeback.transaction_date, payfac_chargeback.reference_id, payfac_chargeback.processed_date,
      payfac_chargeback.description, payfac_chargeback.card_identifier, payfac_chargeback.card_brand,
      payfac_chargeback.amount]
    sorts: [payfac_chargeback.transaction_date desc]
    limit: 500
    total: true
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
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
    series_labels:
      payfac_chargeback.transaction_date: Date
      payfac_chargeback.processed_date: Orig Charge Date
      payfac_chargeback.card_brand: Network
      payfac_chargeback.reference_id: Ref Id
    series_cell_visualizations:
      payfac_chargeback.amount:
        is_active: false
    series_text_format:
      payfac_chargeback.amount:
        align: right
      payfac_chargeback.transaction_date:
        align: center
    header_font_color: "#EFECF3"
    header_background_color: "#684A91"
    truncate_column_names: false
    defaults_version: 1
    series_types: {}
    title_hidden: true
    listen:
      Merchant_id: payfac_chargeback.merchant_id
      Month: payfac_chargeback.transaction_month
    row: 51
    col: 0
    width: 23
    height: 3
  - title: Adjustments
    name: Adjustments
    model: payfac_reporting
    explore: payfac_adjustment
    type: looker_grid
    fields: [payfac_adjustment.processed_date, payfac_adjustment.reference_id, payfac_adjustment.description,
      payfac_adjustment.amount]
    sorts: [payfac_adjustment.processed_date desc]
    limit: 500
    total: true
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
    series_labels:
      payfac_adjustment.processed_date: Date
      payfac_adjustment.reference_id: Ref ID
    series_cell_visualizations:
      payfac_adjustment.amount:
        is_active: false
    series_text_format:
      payfac_adjustment.description:
        align: center
      payfac_adjustment.processed_date:
        align: center
    header_background_color: "#684A91"
    series_types: {}
    defaults_version: 1
    title_hidden: true
    listen:
      Merchant_id: payfac_adjustment.merchant_id
      Month: payfac_adjustment.transaction_month
    row: 56
    col: 0
    width: 23
    height: 4
  - title: Fee Detail
    name: Fee Detail
    model: payfac_reporting
    explore: payfac_fee
    type: looker_grid
    fields: [payfac_fee.fee, payfac_fee.fee_type, payfac_fee.description, payfac_fee.fee_basis,
      payfac_fee.fee_basis_calc, payfac_fee_basis.basis, payfac_fee_basis.basis_display,
      payfac_fee.total_fee]
    filters:
      payfac_fee_basis.settlement_month: 2020/01/01 to 2020/02/01
    sorts: [payfac_fee.total_fee desc]
    limit: 500
    total: true
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
    series_labels:
      payfac_fee_basis.basis_display: Basis
    series_cell_visualizations:
      payfac_fee.total_fee:
        is_active: false
    series_text_format:
      payfac_fee.fee_basis:
        align: right
      payfac_fee_basis.basis_display:
        align: center
      payfac_fee.description:
        align: center
      payfac_fee.fee_type:
        align: center
    header_font_color: "#EFECF3"
    header_background_color: "#684A91"
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
    hidden_fields: [payfac_fee.fee_basis_calc, payfac_fee_basis.basis]
    title_hidden: true
    listen: {}
    row: 45
    col: 0
    width: 23
    height: 4
  - title: Deposit Details
    name: Deposit Details
    model: payfac_reporting
    explore: payfac_deposit_details
    type: looker_grid
    fields: [payfac_deposit_details.date_date, payfac_deposit_details.transactions,
      payfac_deposit_details.charges, payfac_deposit_details.refunds, payfac_deposit_details.chargebacks,
      payfac_deposit_details.adjustments, payfac_deposit_details.total_fee]
    fill_fields: [payfac_deposit_details.date_date]
    sorts: [payfac_deposit_details.date_date]
    limit: 500
    total: true
    dynamic_fields: [{table_calculation: deposits, label: Deposits, expression: "${payfac_deposit_details.charges}\
          \ - ${payfac_deposit_details.refunds} - ${payfac_deposit_details.chargebacks}\
          \ - ${payfac_deposit_details.adjustments} -\n${payfac_deposit_details.total_fee}",
        value_format: !!null '', value_format_name: usd, _kind_hint: measure, _type_hint: number}]
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
    series_labels:
      payfac_deposit_details.date_date: Date
    header_font_color: "#EFECF3"
    header_background_color: "#684A91"
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#654054",
        font_color: !!null '', color_application: {collection_id: 158c6823-0d69-4c97-8dc5-a488504d1fad,
          palette_id: 4c4c1d8a-4d22-4569-816e-9630864f154b, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    truncate_column_names: false
    defaults_version: 1
    series_types: {}
    title_hidden: true
    listen:
      Merchant_id: payfac_deposit_details.merchant_id
      Month: payfac_deposit_details.date_month
    row: 28
    col: 0
    width: 23
    height: 15
  filters:
  - name: Merchant_id
    title: Merchant_id
    type: field_filter
    default_value: '19'
    allow_multiple_values: true
    required: false
    model: payfac_reporting
    explore: fact_deposit
    listens_to_filters: []
    field: fact_deposit.merchant_id
  - name: Month
    title: Month
    type: field_filter
    default_value: 2020/01/01 to 2020/02/01
    allow_multiple_values: true
    required: false
    model: payfac_reporting
    explore: fact_deposit
    listens_to_filters: []
    field: fact_deposit.settlement_month

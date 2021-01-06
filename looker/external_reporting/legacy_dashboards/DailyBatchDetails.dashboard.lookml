- dashboard: DailyBatchDetails
  title: Daily Batch Details
  layout: newspaper

  filters:
    - name: Date
      title: Date
      type: date_filter
      #default_value: 1 days
      default_value: today
      allow_multiple_values: true
      required: false
    - name: Device
      title: device
      type: field_filter
      default_value: ''
      allow_multiple_values: true
      required: false
      model: matillion_hintmd
      explore: batch_report_details
      listens_to_filters: []
      field: device_data.label
    - name: Staff
      title: staff name
      type: field_filter
      default_value: ''
      allow_multiple_values: true
      required: false
      model: matillion_hintmd
      explore: batch_report_details
      listens_to_filters: []
      field: staff_details.staff_name
  elements:
    - name: Daily Batch Report
      title: Daily Batch Report
      model: matillion_hintmd
      explore: batch_report_details
      #type: looker_grid
      type: table

      filters: {}

      # fields: [batch_report_details.sales_created_at_time, batch_report_details.sales_type,
      #   customer2.firstname, customer2.lastname, customer2.customer_mobile, customer2.customer_type,
      #   batch_report_details.transaction, batch_report_details.payment_method,
      #   batch_report_details.payment_id, batch_report_details.description,
      #   staff_details.staff_name,
      #   batch_report_details.sales_amount, batch_report_details.gratuity_amount,
      #   device_data.label]

      fields: [batch_report_details.sales_created_at_time,
        customer2.firstname, customer2.lastname, customer2.customer_mobile, customer2.customer_type, batch_report_details.sales_type,
        batch_report_details.transaction, batch_report_details.payment_method,
        batch_report_details.payment_id, batch_report_details.description,
        staff_details.staff_name,
        batch_report_details.sum_amount, batch_report_details.sum_tipping_amount,
        device_data.label]

      sorts: [batch_report_details.sales_created_at_time desc, batch_report_details.sales_type]
      listen:
        Date: date_table.date_date
      limit: 5000
      dynamic_fields:
      - table_calculation: Total
        label: Total
        expression: "${batch_report_details.sum_amount} + ${batch_report_details.sum_tipping_amount}"
        value_format:
        value_format_name: usd
        _kind_hint: dimension
        _type_hint: number

      query_timezone: user_timezone
      show_view_names: false
      show_row_numbers: true
      transpose: false
      truncate_text: true
      hide_totals: false
      hide_row_totals: false
      size_to_fit: true
      table_theme: white
      limit_displayed_rows: false
      enable_conditional_formatting: true
      header_text_alignment: left
      header_font_size: 12
      rows_font_size: 12
      series_labels:
        batch_report_details.sales_created_at_time: Date & Time
        customer2.customer_type: Customer Type
        staff_details.staff_name: Staff
        customer2.customer_mobile: Phone
        #customer2.subscriber: Member
        batch_report_details.gratuity_amount: Tip
        customer2.firstname: First name
        customer2.lastname: Last name
        batch_report_details.sum_amount: Amount
        batch_report_details.sum_tipping_amount: Tip

      listen:
        Date: date_table.date_date
        Device: device_data.label
        Staff: staff_details.staff_name
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      defaults_version: 1
      hidden_fields: [batch_report_details.sales_id]
      # column_order: ["$$$_row_numbers_$$$", batch_report_details.sales_created_at_time,
      #   batch_report_details.sales_type, customer2.firstname, customer2.lastname, customer2.customer_mobile, customer2.customer_type,
      #   batch_report_details.transaction, batch_report_details.payment_method,
      #   batch_report_details.payment_id, batch_report_details.description,
      #   staff_details.staff_name, device_data.label,  batch_report_details.sales_amount,batch_report_details.gratuity_amount]

      column_order: ["$$$_row_numbers_$$$", batch_report_details.sales_created_at_time,
         customer2.firstname, customer2.lastname, customer2.customer_mobile, customer2.customer_type, batch_report_details.sales_type,
        batch_report_details.transaction, batch_report_details.payment_method,
        batch_report_details.payment_id, batch_report_details.description,
        staff_details.staff_name, device_data.label, batch_report_details.sum_amount, batch_report_details.sum_tipping_amount]
      show_totals: true
      show_row_totals: true
      series_cell_visualizations:
        batch_report_details.sum_amount:
          is_active: false
      series_text_format:
        batch_report_details.sales_amount:
          align: right
        batch_report_details.gratuity_amount:
          align: right
        Total Amount:
          align: right
        Total:
          align: right

      #   subtotal:
      #     bold: true
      #     fg_color: "#EFECF3"
      # conditional_formatting: [{type: not equal to, value: !!null '', background_color: "#654054",
      # font_color: !!null '', color_application: {collection_id: 158c6823-0d69-4c97-8dc5-a488504d1fad,
      #   palette_id: 4edcef28-9514-4b9a-b01b-f7b901be523b}, bold: false, italic: false,
      # strikethrough: false, fields: [subtotal]}, {type: along a scale..., value: !!null '',
      # background_color: "#654054", font_color: !!null '', color_application: {collection_id: 158c6823-0d69-4c97-8dc5-a488504d1fad,
      #   palette_id: 4edcef28-9514-4b9a-b01b-f7b901be523b}, bold: false, italic: false,
      # strikethrough: false, fields: !!null ''}]

      row: 0
      col: 0
      width: 24
      height: 15

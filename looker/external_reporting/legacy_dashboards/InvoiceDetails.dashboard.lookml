- dashboard: InvoiceDetails
  title: Invoice Details
  layout: newspaper
  tile_size: 100

  filters:
    - name: Date
      title: Date
      type: date_filter
      #default_value: 1 days
      default_value: today
      allow_multiple_values: true
      required: false

  elements:
    - name: invoice_details
      model: matillion_hintmd
      explore: fact_invoice_item
      type: table
      fields: [fact_invoice_item.id,fact_invoice_item.invoice, fact_invoice_item.invoice_level, fact_invoice_item.pay_date_time, dim_customer_inv.firstname,
      dim_customer_inv.lastname, dim_customer_inv.customer_mobile, dim_customer_inv.customer_type, fact_invoice_item.brand,
      fact_invoice_item.product_service, fact_invoice_item.sku,  fact_invoice_item.units,  fact_invoice_item.unit_type,
      fact_invoice_item.price_unit,  fact_invoice_item.total_price, fact_invoice_item.recurring_payment,
      fact_invoice_item.invoice_amount, fact_invoice_item.item_discount, fact_invoice_item.discount_reason,
      fact_invoice_item.discounted_price, fact_invoice_item.taxable_amount, fact_invoice_item.tax_charged,
      fact_invoice_item.grand_total]
      sorts: [fact_invoice_item.invoice,fact_invoice_item.id]
      limit: 500
      query_timezone: user_timezone
      show_view_names: false
      show_row_numbers: true
      transpose: false
      truncate_text: true
      hide_totals: false
      hide_row_totals: false
      size_to_fit: true
      table_theme: unstyled
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
      listen:
        Date: date_table.date_date
      series_labels:
        fact_invoice_item.pay_date_time: Date
        dim_customer_inv.firstname: First Name
        dim_customer_inv.lastname: Last Name
        dim_customer_inv.customer_mobile: Phone
        dim_customer_inv.customer_type: Customer Type
        fact_invoice_item.product_service: Product/Service
        fact_invoice_item.price_unit: Price/Unit
        fact_invoice_item.recurring_payment: Recurring Pmt

      series_text_format:
        fact_invoice_item.pay_date_date:
          fg_color: "#684A91"
        dim_customer.firstname:
          fg_color: "#684A91"
        dim_customer.lastname:
          fg_color: "#684A91"
        dim_customer.customer_mobile:
          fg_color: "#684A91"
        dim_customer.user_type:
          fg_color: "#684A91"
        dim_offering.brand:
          fg_color: "#684A91"
        dim_offering.product_service:
          fg_color: "#684A91"
        dim_offering.sku:
          fg_color: "#684A91"
        fact_invoice_item.units:
          fg_color: "#684A91"
        fact_invoice_item.unit_type:
          fg_color: "#684A91"
        fact_invoice_item.price_unit:
          fg_color: "#684A91"
        fact_invoice_item.total_price:
          fg_color: "#684A91"
        fact_invoice_item.recurring_payment:
          fg_color: "#684A91"
        fact_invoice_item.invoice_amount:
          fg_color: "#684A91"
        fact_invoice_item.item_discount:
          fg_color: "#684A91"
        fact_invoice_item.discount_reason:
          fg_color: "#684A91"
        fact_invoice_item.discounted_price:
          fg_color: "#684A91"
        fact_invoice_item.tax_charged:
          fg_color: "#684A91"
        fact_invoice_item.tax_percentage:
          fg_color: "#684A91"
        fact_invoice_item.grand_total:
          fg_color: "#684A91"
        dim_customer.customer_type:
          fg_color: "#684A91"
        fact_invoice_item.invoice:
          fg_color: "#684A91"
      header_font_color: "#684A91"
      hidden_fields: [fact_invoice_item.id, fact_invoice_item.sku]
      truncate_column_names: false
      defaults_version: 1
      series_types: {}
      row: 0
      col: 0
      width: 24
      height: 15

view: fact_invoice_item {
  sql_table_name: dwh.fact_invoice_item ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: discount_reason {
    type: string
    sql: ${TABLE}.discount_reason ;;
  }

  dimension: discounted_price {
    type: number
    sql: ${TABLE}.discounted_price ;;
    value_format: "$#,##0.00"
  }

  dimension: grand_total {
    type: number
    sql: ${TABLE}.grand_total ;;
    value_format: "$#,##0.00"
  }

  dimension: gx_customer_id {
    type: string
    sql: ${TABLE}.gx_customer_id ;;
  }

  dimension: gx_provider_id {
    type: string
    sql: ${TABLE}.gx_provider_id ;;
  }

  dimension: gx_subscription_id {
    type: string
    sql: ${TABLE}.gx_subscription_id ;;
  }

  dimension: invoice {
    type: number
    sql: ${TABLE}.invoice ;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#EFECF3">{{ rendered_value }}</p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
  }

  dimension: invoice_amount {
    type: number
    sql: ${TABLE}.invoice_amount ;;
    value_format: "$#,##0.00"
  }

  dimension: item_discount {
    type: number
    sql: ${TABLE}.item_discount ;;
    value_format: "$#,##0.00"
  }

  dimension_group: pay_date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.pay_date ;;
    #EFECF3
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#EFECF3">{{ rendered_value | date: "%m/%d/%y %I:%M %p" }}</p>
    {% else %}
    <p>{{ rendered_value | date: "%m/%d/%y %I:%M %p" }}</p>
    {% endif %}
    ;;
  }

  dimension_group: test {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.pay_date ;;
    #EFECF3
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#EFECF3">{{ rendered_value | date: "%m/%d/%y %I:%M %p" }}</p>
    {% else %}
    <p>{{ rendered_value | date: "%m/%d/%y %I:%M %p" }}</p>
    {% endif %}
    ;;
  }

  dimension: price_unit {
    type: number
    sql: ${TABLE}.price_unit ;;
  }

  dimension: recurring_payment {
    type: string
    sql: ${TABLE}.recurring_payment  ;;
    html:
    {% if value > 1 %}
    <p style="align:center;height: 5px;width: 5px;background-color: #9478BA;border-radius: 25%;display: inline-block;margin-left:50%;margin-top:4%"></p>
    {% else %}
    <p style="text-align:center;margin-top:12%"> </p>
    {% endif %}
    ;;
  }

  dimension: subscription_cycle {
    type: number
    sql: ${TABLE}.subscription_cycle ;;
  }

  dimension: subscription_id {
    type: number
    sql: ${TABLE}.subscription_id ;;
  }

  dimension: tax_charged {
    type: number
    sql: ${TABLE}.tax_charged ;;
    value_format: "$#,##0.00"
  }

  dimension: tax_percentage {
    type: number
    sql: ${TABLE}.tax_percentage ;;
    value_format: "#,##0.00"
  }

  dimension: total_price {
    type: number
    sql: ${TABLE}.total_price ;;
    value_format: "$#,##0.00"
  }

  dimension: unit_type {
    type: string
    sql: ${TABLE}.unit_type ;;
  }

  dimension: units {
    type: number
    sql: ${TABLE}.units ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

view: fact_invoice_item {
  sql_table_name: dwh.fact_invoice_item ;;
  drill_fields: [id]

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    #sql: CASE WHEN ${id} not like '%sub%' and ${count_distinct_brand} > 1 then 'Various' WHEN ${id} not like '%sub%' and ${TABLE}.brand IS NULL THEN 'Various' else ${TABLE}.brand END;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
  }

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;

  }

  dimension: count_of_invoice_item {
    type: number
    sql: ${TABLE}.count_of_invoice_item ;;
  }

  dimension: count_distinct_brand {
    type: number
    sql: ${TABLE}.count_distinct_brand ;;
  }

  dimension: count_distinct_product {
    type: number
    sql: ${TABLE}.count_distinct_product ;;
  }

  dimension: count_distinct_sku {
    type: number
    sql: ${TABLE}.count_distinct_sku ;;
  }


  dimension: discount_reason {
    type: string
    sql: ${TABLE}.discount_reason ;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
  }

  dimension: discounted_price {
    type: number
    sql: ${TABLE}.discounted_price ;;
    value_format: "$#,##0.00"
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
  }

  dimension: grand_total {
    type: number
    sql: ${TABLE}.grand_total ;;
    value_format: "$#,##0.00"
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
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
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
    value_format: "0"
  }

  dimension: invoice_amount {
    type: number
    sql: ${TABLE}.invoice_amount ;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
    value_format: "$#,##0.00"
  }

  dimension: invoice_level {
    type: string
    sql: CASE WHEN ${id} like '%sub%' then 'NO' else 'YES' END ;;
    html: {% if fact_invoice_item.id._rendered_value contains 'sub' %}
          <p style="color:#999999"><i>{{ rendered_value }}<i></p>
          {% else %}
          <p>{{ rendered_value }}</p>
          {% endif %} ;;

  }

  dimension: item_discount {
    type: number
    sql: ${TABLE}.item_discount ;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
    value_format: "$#,##0.00"
  }



  dimension: invoice_actual_amount {
    type: number
    sql: ${TABLE}.invoice_actual_amount ;;
    value_format: "$#,##0.00"
  }

  dimension: invoice_credit {
    type: number
    sql: ${TABLE}.invoice_credit ;;
    value_format: "$#,##0.00"
  }

  dimension_group: pay_date {
    label: "Date"
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

    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value | date: "%m/%d/%y %I:%M %p" }}</i></p>
    {% else %}
    <p>{{ rendered_value | date: "%m/%d/%y %I:%M %p" }}</p>
    {% endif %}
    ;;
  }

  dimension: product_service {
    type: string
    sql: ${TABLE}.product_service ;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
  }



  dimension: price_unit {
    type: number
    #sql: ${TABLE}.price_unit ;;
    sql: CASE WHEN ${id} not like '%sub%' and ${count_of_invoice_item} > 1 then NULL else ${TABLE}.price_unit END;;
    value_format: "$#,##0.00"
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
  }

  dimension: price_unit_ORIG {
    type: string
    #sql: ${TABLE}.price_unit ;;
    sql: CASE WHEN ${id} not like '%sub%' and ${count_of_invoice_item} > 1 then ' ' else CAST(${TABLE}.price_unit as VARCHAR(20)) END;;
    value_format: "$#,##0.00"
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
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

  dimension: sku {
    type: string
    sql: ${TABLE}.sku;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
  }



  dimension: subscription_cycle {
    type: number
    sql: ${TABLE}.subscription_cycle ;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
  }

  dimension: subscription_id {
    type: number
    sql: ${TABLE}.subscription_id ;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
  }

  dimension: tax_charged {
    type: number
    sql: ${TABLE}.tax_charged ;;
    value_format: "$#,##0.00"
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
  }

  dimension: taxable_amount {
    type: number
    sql: ${TABLE}.taxable_amount ;;
    value_format: "$#,##0.00"
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
  }

  dimension: total_price {
    type: number
    sql: ${TABLE}.total_price ;;
    value_format: "$#,##0.00"
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
  }

  dimension: unit_type {
    type: string
    #sql: ${TABLE}.unit_type ;;
    sql: CASE WHEN ${id} not like '%sub%' then NULL else ${TABLE}.unit_type END;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
  }

  dimension: units {
    type: number
    #sql: ${TABLE}.units ;;
    sql: CASE WHEN ${id} not like '%sub%' then NULL else ${TABLE}.units END;;
    html:
    {% if fact_invoice_item.id._rendered_value contains 'sub' %}
    <p style="color:#999999"><i>{{ rendered_value }}<i></p>
    {% else %}
    <p>{{ rendered_value }}</p>
    {% endif %}
    ;;
  }



  measure: count {
    type: count
    drill_fields: [id]
  }
}

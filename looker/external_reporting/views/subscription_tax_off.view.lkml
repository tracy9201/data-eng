view: subscription_tax_off {
  derived_table: {
    sql: select prov.name as provider_name,
      c.email as customer_email,
      p.next_billing_date,
      p.tax_percentage as plan_tax_percentage,
      s.tax_percentage as subscription_tax_percentage,
      p.tax_percentage/s.tax_percentage as factor,
      s.*
      from rds_data.g_subscription s
      left join rds_data.g_plan p on s.plan_id = p.id
      left join rds_data.g_customer c on p.customer_id = c.id
      left join rds_data.g_provider prov on c.provider_id = prov.id
      where p.next_billing_date > '2020-06-25 21:00:00'
      and p.next_billing_date <'2020-07-26 21:00:00'
      and s.auto_renewal = 't'
      and s.renewal_count in (0, 2147483647)
      and s.canceled_at is null
      and s.status = 1
      and s.tax > 0
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: provider_name {
    type: string
    sql: ${TABLE}.provider_name ;;
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension_group: next_billing_date {
    type: time
    sql: ${TABLE}.next_billing_date ;;
  }

  dimension: plan_tax_percentage {
    type: number
    sql: ${TABLE}.plan_tax_percentage ;;
  }

  dimension: subscription_tax_percentage {
    type: number
    sql: ${TABLE}.subscription_tax_percentage ;;
  }

  dimension: factor {
    type: number
    sql: ${TABLE}.factor ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: plan_id {
    type: number
    sql: ${TABLE}.plan_id ;;
  }

  dimension: payment_plan_id {
    type: number
    sql: ${TABLE}.payment_plan_id ;;
  }

  dimension: fulfillment_plan_id {
    type: number
    sql: ${TABLE}.fulfillment_plan_id ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: unit_name {
    type: string
    sql: ${TABLE}.unit_name ;;
  }

  dimension: remaining_payment {
    type: number
    sql: ${TABLE}.remaining_payment ;;
  }

  dimension: balance {
    type: number
    sql: ${TABLE}.balance ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}.price ;;
  }

  dimension: discount_amts {
    type: number
    sql: ${TABLE}.discount_amts ;;
  }

  dimension: discount_percentages {
    type: number
    sql: ${TABLE}.discount_percentages ;;
  }

  dimension: coupons {
    type: number
    sql: ${TABLE}.coupons ;;
  }

  dimension: credits {
    type: number
    sql: ${TABLE}.credits ;;
  }

  dimension: payments {
    type: number
    sql: ${TABLE}.payments ;;
  }

  dimension: total_installment {
    type: number
    sql: ${TABLE}.total_installment ;;
  }

  dimension: tax {
    type: number
    sql: ${TABLE}.tax ;;
  }

  dimension: tax_percentage {
    type: number
    sql: ${TABLE}.tax_percentage ;;
  }

  dimension: subtotal {
    type: number
    sql: ${TABLE}.subtotal ;;
  }

  dimension: total {
    type: number
    sql: ${TABLE}.total ;;
  }

  dimension_group: start_date {
    type: time
    sql: ${TABLE}.start_date ;;
  }

  dimension_group: end_date {
    type: time
    sql: ${TABLE}.end_date ;;
  }

  dimension: end_count {
    type: number
    sql: ${TABLE}.end_count ;;
  }

  dimension: end_unit {
    type: string
    sql: ${TABLE}.end_unit ;;
  }

  dimension: proration {
    type: string
    sql: ${TABLE}.proration ;;
  }

  dimension: auto_renewal {
    type: string
    sql: ${TABLE}.auto_renewal ;;
  }

  dimension: renewal_count {
    type: number
    sql: ${TABLE}.renewal_count ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension_group: canceled_at {
    type: time
    sql: ${TABLE}.canceled_at ;;
  }

  dimension_group: deleted_at {
    type: time
    sql: ${TABLE}.deleted_at ;;
  }

  dimension: status {
    type: number
    sql: ${TABLE}.status ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: updated_at {
    type: time
    sql: ${TABLE}.updated_at ;;
  }

  dimension: encrypted_ref_id {
    type: string
    sql: ${TABLE}.encrypted_ref_id ;;
  }

  set: detail {
    fields: [
      provider_name,
      customer_email,
      next_billing_date_time,
      plan_tax_percentage,
      subscription_tax_percentage,
      factor,
      id,
      plan_id,
      payment_plan_id,
      fulfillment_plan_id,
      product_id,
      quantity,
      unit_name,
      remaining_payment,
      balance,
      price,
      discount_amts,
      discount_percentages,
      coupons,
      credits,
      payments,
      total_installment,
      tax,
      tax_percentage,
      subtotal,
      total,
      start_date_time,
      end_date_time,
      end_count,
      end_unit,
      proration,
      auto_renewal,
      renewal_count,
      name,
      canceled_at_time,
      deleted_at_time,
      status,
      created_at_time,
      updated_at_time,
      encrypted_ref_id
    ]
  }
}

WITH main as (
SELECT distinct
    'payment'||'_'||p.id as sales_id,
    cud.gx_customer_id,
    card_holder_name
FROM
    gaia_opul${environment}.payment p
LEFT JOIN(
SELECT distinct 
  gt.payment_id, 
  card_payment_gateway_id
FROM  gaia_opul${environment}.gateway_transaction gt
WHERE 
  card_payment_gateway_id IS NOT NULL and card_payment_gateway_id != 0
  and gt.payment_id is not null) gt
        ON gt.payment_id = p.id
LEFT JOIN
    gaia_opul${environment}.card_payment_gateway cpg
        ON cpg.id = gt.card_payment_gateway_id
LEFT JOIN
    gaia_opul${environment}.card card
        ON cpg.card_id = card.id
left join 
    gaia_opul${environment}.plan plan
        on p.plan_id = plan.id
left join 
    gaia_opul${environment}.customer cus
        on cus.id = plan.customer_id
left join 
    kronos_opul${environment}.customer_data cud
        on cus.encrypted_ref_id = cud.gx_customer_id
WHERE
    p.id IS NOT NULL
    AND p.status  in (1,-3)
    AND p.type = 'credit_card'
    AND cud.type = 1
)
select * as main
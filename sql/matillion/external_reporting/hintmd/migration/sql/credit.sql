SELECT
  s_id as sales_id,
  s_n as sales_name,
  s_a as sales_amount,
  s_t as sales_type,
  s_s as sales_status,
  s_c as sales_created_at,
  g_c as gx_customer_id,
  g_p as gx_provider_id,
  t_id as transaction_id,
  case when s_t = 'check' then p_id when s_t = 'credit_card'
  and (
    s_id like 'tran%'
    or s_id like 'payment%'
    or s_id like 'refund%'
  ) then CONCAT(
    '**** ',
    cast(p_id as VARCHAR)
  ) when transaction = 'Void' then CONCAT(
    '**** ',
    cast(
      right(t, 4) as VARCHAR
    )
  ) else null end as payment_id,
  t as tokenization,
  g_s as gx_subscription_id,
  s_u as staff_user_id,
  d_id as device_id,
  g_a as gratuity_amount,
  is_voided
FROM
  (
    SELECT
      *,
      case when s_id like 'refund%' then 'Refund' when s_id like 'credit%'
      and s_t in ('reward', 'credit')
      and s_n = 'BD Payment' then 'Offer Redemption' when s_id like 'credit%'
      and s_t = 'provider credit' then 'Deposit From Patient' when s_id like 'credit%' then 'Redemption' when s_id like 'void%' then 'Void' else 'Sale' end as transaction
    FROM
      (
        SELECT
          'credit_' || cast(c.id AS text) AS s_id,
          c.name AS s_n,
          c.amount AS s_a,
          c.type AS s_t,
          c.status AS s_s,
          c.created_at AS s_c,
          ct.encrypted_ref_id AS g_c,
          pr.encrypted_ref_id AS g_p,
          CASE WHEN c.id IS NOT NULL THEN '' END AS t_id,
          c.name AS p_id,
          '0000000000000000' :: VARCHAR AS t,
          sub.encrypted_ref_id AS g_s,
          c.created_by AS s_u,
          NULL :: TEXT AS d_id,
          NULL :: NUMERIC(20, 9) AS g_a,
          NULL :: TEXT AS is_voided
        FROM
          gaia_hint${environment}.credit c
          LEFT JOIN gaia_hint${environment}.subscription sub ON sub.id = c.subscription_id
          LEFT JOIN gaia_hint${environment}.plan pl ON c.plan_id = pl.id
          LEFT JOIN gaia_hint${environment}.customer ct ON ct.id = pl.customer_id
          LEFT JOIN gaia_hint${environment}.provider pr ON pr.id = provider_id
        WHERE
          c.id IS NOT NULL
          AND c.status = 1
        UNION ALL
        SELECT
          'payment_' || cast(p.id AS text) AS s_id,
          p.name AS s_n,
          p.amount AS s_a,
          p.type AS s_t,
          p.status AS s_s,
          p.created_at AS s_c,
          ct.encrypted_ref_id AS g_c,
          pr.encrypted_ref_id AS g_p,
          p.transaction_id,
          CASE WHEN p.type = 'credit_card' THEN account_number ELSE p.name END AS p_id,
          cpg.tokenization :: varchar as t,
          sub.encrypted_ref_id AS g_s,
          p.created_by AS s_u,
          p.device_id as d_id,
          gr.amount AS g_a,
          NULL :: TEXT AS is_voided
        FROM
          gaia_hint${environment}.payment p
          LEFT JOIN gaia_hint${environment}.subscription sub ON sub.id = p.subscription_id
          LEFT JOIN gaia_hint${environment}.gratuity gr ON gr.id = p.gratuity_id
          LEFT JOIN gaia_hint${environment}.plan pl ON p.plan_id = pl.id
          LEFT JOIN gaia_hint${environment}.customer ct ON ct.id = customer_id
          LEFT JOIN gaia_hint${environment}.provider pr ON pr.id = provider_id
          LEFT JOIN gaia_hint${environment}.gateway_transaction gt ON gt.payment_id = p.id
          LEFT JOIN gaia_hint${environment}.card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
          LEFT JOIN gaia_hint${environment}.card ON cpg.card_id = card.id
        WHERE
          p.id IS NOT NULL
          AND p.status = 1
        UNION ALL
        SELECT
          'refund1_' || cast(r.id AS text) as s_id,
          r.name as s_n,
          r.amount s_a,
          r.type as s_t,
          r.status as s_s,
          r.created_at as s_c,
          ct.encrypted_ref_id as g_c,
          pr.encrypted_ref_id as g_p,
          CASE WHEN r.id IS NOT NULL THEN gt.transaction_id else '' END as t_id,
          CASE WHEN r.type = 'credit_card' THEN last4 ELSE r.reason END as p_id,
          cpg.tokenization :: varchar as t,
          sub.encrypted_ref_id as g_s,
          r.created_by as s_u,
          NULL :: TEXT as d_id,
          gr.amount as g_a,
          NULL :: VARCHAR AS is_voided
        FROM
          gaia_hint${environment}.refund r
          LEFT JOIN gaia_hint${environment}.gratuity gr ON gr.id = r.gratuity_id
          LEFT JOIN gaia_hint${environment}.subscription sub ON subscription_id = sub.id
          LEFT JOIN gaia_hint${environment}.plan pl ON sub.plan_id = pl.id
          LEFT JOIN gaia_hint${environment}.customer ct ON ct.id = pl.customer_id
          LEFT JOIN gaia_hint${environment}.provider pr ON pr.id = provider_id
          LEFT JOIN gaia_hint${environment}.gateway_transaction gt ON r.gateway_transaction_id = gt.id
          LEFT JOIN gaia_hint${environment}.card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
          LEFT JOIN gaia_hint${environment}.card ON cpg.card_id = card.id
        WHERE
          subscription_id IS NOT NULL
          AND r.status = 20
          AND r.is_void = 'f'
        UNION ALL
        SELECT
          'refund3_' || cast(r.id AS text) as s_id,
          r.name as s_n,
          r.amount s_a,
          r.type as s_t,
          r.status as s_s,
          r.created_at as s_c,
          ct.encrypted_ref_id as g_c,
          pr.encrypted_ref_id as g_p,
          gt.transaction_id as t_id,
          CASE WHEN r.type = 'credit_card' THEN last4 ELSE r.reason END as p_id,
          cpg.tokenization :: varchar as t,
          sub.encrypted_ref_id as g_s,
          r.created_by as s_u,
          NULL :: TEXT as d_id,
          gr.amount as g_a,
          null :: TEXT as is_voided
        FROM
          gaia_hint${environment}.refund r
          LEFT JOIN gaia_hint${environment}.gratuity gr ON gr.id = r.gratuity_id
          LEFT JOIN gaia_hint${environment}.gateway_transaction gt ON gateway_transaction_id = gt.id
          LEFT JOIN gaia_hint${environment}.payment p ON gt.payment_id = p.id
          LEFT JOIN gaia_hint${environment}.plan pl ON p.plan_id = pl.id
          LEFT JOIN gaia_hint${environment}.subscription sub ON p.subscription_id = sub.id
          LEFT JOIN gaia_hint${environment}.customer ct ON ct.id = pl.customer_id
          LEFT JOIN gaia_hint${environment}.provider pr ON pr.id = provider_id
          LEFT JOIN gaia_hint${environment}.card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
          LEFT JOIN gaia_hint${environment}.card ON cpg.card_id = card.id
        WHERE
          r.subscription_id IS NULL
          AND gt.invoice_item_id IS NULL
          AND source_object_name = 'refund'
          AND r.status = 20
          AND r.is_void = 'f'
        UNION ALL
        SELECT
          'tran_' || cast(gt.id AS text) as s_id,
          gt.name as s_n,
          gt.amount s_a,
          gt.type as s_t,
          gt.status as s_s,
          gt.created_at as s_c,
          ct.encrypted_ref_id as g_c,
          pr.encrypted_ref_id as g_p,
          transaction_id as t_id,
          last4 as p_id,
          cpg.tokenization :: varchar as t,
          sub.encrypted_ref_id as g_s,
          NULL :: TEXT as s_u,
          NULL :: TEXT as d_id,
          gt.gratuity_amount as g_a,
          NULL :: text AS is_voided
        FROM
          gaia_hint${environment}.gateway_transaction gt
          LEFT JOIN gaia_hint${environment}.invoice inv ON invoice_id = inv.id
          LEFT JOIN gaia_hint${environment}.invoice_item ivi ON invoice_item_id = ivi.id
          LEFT JOIN gaia_hint${environment}.subscription sub ON sub.id = ivi.subscription_id
          LEFT JOIN gaia_hint${environment}.plan pl ON inv.plan_id = pl.id
          LEFT JOIN gaia_hint${environment}.customer ct ON ct.id = pl.customer_id
          LEFT JOIN gaia_hint${environment}.provider pr ON pr.id = provider_id
          LEFT JOIN gaia_hint${environment}.card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
          LEFT JOIN gaia_hint${environment}.card ON cpg.card_id = card.id
        WHERE
          source_object_name = 'card_payment_gateway'
          AND gt.status = 20
          AND gt.payment_id IS NULL
          AND gt.is_voided = 'f'
        UNION ALL
        SELECT
          'void1_' || cast(s.id AS text) as s_id,
          gt.name as s_n,
          s.tendered * 100 s_a,
          gt.type as s_t,
          s.status as s_s,
          s.authd_date as s_c,
          ct.encrypted_ref_id as g_c,
          pr.encrypted_ref_id as g_p,
          gt.transaction_id as t_id,
          s.last_four as p_id,
          token :: varchar as t,
          sub.encrypted_ref_id as g_s,
          NULL :: TEXT as s_u,
          NULL :: TEXT as d_id,
          gt.gratuity_amount as g_a,
          gt.is_voided :: text AS is_voided
        FROM
          gaia_hint${environment}.settlement s
          LEFT JOIN gaia_hint${environment}.gateway_transaction gt ON gt.id = gateway_transaction_id
          LEFT JOIN gaia_hint${environment}.invoice inv ON gt.invoice_id = inv.id
          LEFT JOIN gaia_hint${environment}.invoice_item ivi ON ivi.id = gt.invoice_item_id
          LEFT JOIN gaia_hint${environment}.subscription sub ON sub.id = ivi.subscription_id
          LEFT JOIN gaia_hint${environment}.plan pl ON inv.plan_id = pl.id
          LEFT JOIN gaia_hint${environment}.customer ct ON customer_id = ct.id
          LEFT JOIN gaia_hint${environment}.provider pr ON provider_id = pr.id
          LEFT JOIN (
            SELECT
              CASE WHEN re.id IS NOT NULL THEN gt.transaction_id END as t_id
            FROM
              gaia_hint${environment}.refund re
              LEFT JOIN gaia_hint${environment}.gateway_transaction gt ON re.gateway_transaction_id = gt.id
            WHERE
              re.status = 20
              AND re.is_void = 't'
          ) AS void_3_4 on gt.transaction_id = void_3_4.t_id
        WHERE
          s.settlement_status = 'Voided'
          AND gt.invoice_id IS NOT NULL
          AND gt.is_voided = 'f'
          and void_3_4.t_id is null
        UNION ALL
        SELECT
          'void2_' || cast(s.id AS text) as s_id,
          gt.name as s_n,
          s.tendered * 100 s_a,
          gt.type as s_t,
          s.status as s_s,
          s.authd_date as s_c,
          ct.encrypted_ref_id as g_c,
          pr.encrypted_ref_id as g_p,
          gt.transaction_id as t_id,
          s.last_four p_id,
          token :: varchar as t,
          sub.encrypted_ref_id as g_s,
          NULL :: TEXT as s_u,
          NULL :: TEXT as d_id,
          gt.gratuity_amount as g_a,
          gt.is_voided :: text AS is_voided
        FROM
          gaia_hint${environment}.settlement s
          LEFT JOIN gaia_hint${environment}.gateway_transaction gt ON gt.id = gateway_transaction_id
          LEFT JOIN gaia_hint${environment}.payment p ON payment_id = p.id
          LEFT JOIN gaia_hint${environment}.subscription sub ON sub.id = p.subscription_id
          LEFT JOIN gaia_hint${environment}.plan pl ON p.plan_id = pl.id
          LEFT JOIN gaia_hint${environment}.customer ct ON customer_id = ct.id
          LEFT JOIN gaia_hint${environment}.provider pr ON provider_id = pr.id
          LEFT JOIN (
            SELECT
              CASE WHEN re.id IS NOT NULL THEN gt.transaction_id END as t_id
            FROM
              gaia_hint${environment}.refund re
              LEFT JOIN gaia_hint${environment}.gateway_transaction gt ON re.gateway_transaction_id = gt.id
            WHERE
              re.status = 20
              AND re.is_void = 't'
          ) AS void_3_4 on gt.transaction_id = void_3_4.t_id
        WHERE
          s.settlement_status = 'Voided'
          AND invoice_id IS NULL
          AND gt.is_voided = 'f'
          and void_3_4.t_id is null
        UNION ALL
        SELECT
          'void3_' || cast(r.id AS text) as s_id,
          r.name as s_n,
          r.amount s_a,
          r.type as s_t,
          r.status as s_s,
          r.created_at as s_c,
          ct.encrypted_ref_id as g_c,
          pr.encrypted_ref_id as g_p,
          CASE WHEN r.id IS NOT NULL THEN gt.transaction_id else '' END t_id,
          r.reason p_id,
          cpg.tokenization :: varchar,
          sub.encrypted_ref_id as g_s,
          r.created_by as s_u,
          NULL :: TEXT as d_id,
          gr.amount as g_a,
          r.is_void :: text AS is_voided
        FROM
          gaia_hint${environment}.refund r
          LEFT JOIN gaia_hint${environment}.gratuity gr ON gr.id = r.gratuity_id
          LEFT JOIN gaia_hint${environment}.gateway_transaction gt ON r.gateway_transaction_id = gt.id
          LEFT JOIN gaia_hint${environment}.invoice_item ivi ON gt.invoice_item_id = ivi.id
          LEFT JOIN gaia_hint${environment}.subscription sub ON ivi.subscription_id = sub.id
          LEFT JOIN gaia_hint${environment}.plan pl ON sub.plan_id = pl.id
          LEFT JOIN gaia_hint${environment}.customer ct ON ct.id = pl.customer_id
          LEFT JOIN gaia_hint${environment}.provider pr ON pr.id = provider_id
          LEFT JOIN gaia_hint${environment}.card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
        WHERE
          r.status = 20
          AND r.is_void = 't'
          AND gt.payment_id IS NULL
        UNION ALL
        SELECT
          'void4_' || cast(r.id AS text) as s_id,
          r.name as s_n,
          r.amount s_a,
          r.type as s_t,
          r.status as s_s,
          r.created_at as s_c,
          ct.encrypted_ref_id as g_c,
          pr.encrypted_ref_id as g_p,
          CASE WHEN r.id IS NOT NULL THEN gt.transaction_id else '' END t_id,
          r.reason p_id,
          cpg.tokenization :: varchar,
          sub.encrypted_ref_id as g_s,
          r.created_by as s_u,
          NULL :: TEXT as d_id,
          gr.amount as g_a,
          r.is_void :: text AS is_voided
        FROM
          gaia_hint${environment}.refund r
          LEFT JOIN gaia_hint${environment}.gratuity gr ON gr.id = r.gratuity_id
          LEFT JOIN gaia_hint${environment}.subscription sub ON r.subscription_id = sub.id
          LEFT JOIN gaia_hint${environment}.gateway_transaction gt ON r.gateway_transaction_id = gt.id
          LEFT JOIN gaia_hint${environment}.payment p ON p.id = payment_id
          LEFT JOIN gaia_hint${environment}.plan pl ON p.plan_id = pl.id
          LEFT JOIN gaia_hint${environment}.customer ct ON ct.id = pl.customer_id
          LEFT JOIN gaia_hint${environment}.provider pr ON pr.id = provider_id
          LEFT JOIN gaia_hint${environment}.card_payment_gateway cpg ON cpg.id = gt.card_payment_gateway_id
        WHERE
          r.status = 20
          AND r.is_void = 't'
          AND gt.payment_id IS NOT NULL
      ) UNION_QRY
  ) MAIN
GROUP BY
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16
;

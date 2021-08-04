WITH CTE_Adj AS (
  SELECT
    'adjustment_' || cast(adjustment.id AS text) AS settlement_id,
    funding_master_id AS funding_txn_id,
    CASE WHEN UPPER(adjustment.category) IN (
      'FEES', 'SERVICE CHARGES', 'INTERCHANGE CHARGES',
      'INTERCHANGE FEES'
    ) THEN 'Fees' ELSE adjustment.category END AS settlement_type,
    date_added AS settlement_date,
    CASE WHEN adjustment.id IS NOT NULL THEN 0 END AS interchange_unit_fee,
    CASE WHEN adjustment.id IS NOT NULL THEN 0 END AS interchange_percentage_fee,
    CASE WHEN UPPER(adjustment.type) IN (
      'AUTHORIZATIONS', 'FEES', 'DEBIT',
      'DATA CAPTURE', 'CHARGEBACK TRANSACTION PROCESSING',
      'ACCOUNT MANAGEMENT FEES', 'EQUIPMENT',
      'ASSESSMENT', 'INTERCHANGE CHARGES',
      'INTERCHANGE', 'DEBIT SERVICE CHARGE',
      'SERVICE CHARGES'
    ) THEN 'Processing Fees' ELSE adjustment.type END AS card_brand,
    CASE WHEN adjustment.id IS NOT NULL THEN NULL END AS last_four,
    CASE WHEN adjustment.status = 1 THEN 'Processed' ELSE 'unknown' END AS settlement_status,
    payment_gateway_id AS gateway_transaction_id,
    authorisation_id,
    adjustment.amount AS settlement_amount,
    CASE WHEN adjustment.id IS NOT NULL THEN 'XXXXYYYY' END AS gx_customer_id,
    pr.encrypted_ref_id AS gx_provider_id
  FROM
    gaia_hint${environment}.adjustment
    JOIN gaia_hint${environment}.authorisation authorisation ON authorisation.id = authorisation_id
    JOIN gaia_hint${environment}.provider pr ON object_id = pr.id
),
CTE_Settlement AS (
  (
    SELECT
      'settlement_' || cast(settlement.settlement_id AS text) AS settlement_id,
      funding_txn_id,
      settlement_type,
      settlement_date,
      interchange_unit_fee,
      interchange_percentage_fee,
      card_brand,
      last_four,
      settlement_status,
      gateway_transaction_id,
      authorisation_id,
      settlement_amount,
      A.gx_customer_id,
      A.gx_provider_id
    FROM
      (
        SELECT
          settlement_id,
          funding_txn_id,
          settlement_type,
          settlement_date,
          interchange_unit_fee,
          interchange_percentage_fee,
          card_brand,
          last_four,
          settlement_status,
          gateway_transaction_id,
          authorisation_id,
          settlement_amount
        FROM
          (
            SELECT
              settlement.id AS settlement_id,
              settlement.funding_txn_id,
              settlement.type AS settlement_type,
              settlement.settlement_date,
              settlement.card_brand,
              settlement.last_four,
              settlement.settlement_status AS settlement_status,
              gateway_transaction_id,
              CASE WHEN settlement_status = 'Amount Under Review' THEN tendered ELSE amount END AS settlement_amount,
              count(id) OVER (
                PARTITION by external_id
                ORDER BY
                  gateway_transaction_id
              ) AS order_id,
              authorisation_id,
              interchange_unit_fee,
              interchange_percentage_fee
            FROM
              gaia_hint${environment}.settlement
            WHERE
              (
                (
                  settlement.type = 'Sale'
                  AND settlement.reason = 'Approval'
                )
                OR (
                  settlement.type = 'Refund'
                  AND external_id IS NOT null
                )
              )
              OR (
                gateway_transaction_id IS NULL
                AND external_id IS NOT NULL
                AND reason IS NULL
                AND token IS null
              )
            ORDER BY
              funding_txn_id
          ) settlement1
        WHERE
          order_id = 1
        UNION ALL
        SELECT
          settlement.id AS settlement_id,
          settlement.funding_txn_id,
          settlement.type AS settlement_type,
          settlement.settlement_date,
          interchange_unit_fee,
          interchange_percentage_fee,
          settlement.card_brand,
          settlement.last_four,
          settlement.settlement_status AS settlement_status,
          gateway_transaction_id,
          authorisation_id,
          CASE WHEN settlement_status = 'Amount Under Review' THEN tendered ELSE amount END AS settlement_amount
        FROM
          gaia_hint${environment}.settlement
        WHERE
          (
            external_id IS NULL
            AND gateway_transaction_id IS NULL
            AND reason IS NULL
            AND token IS null
          )
      ) settlement
      LEFT JOIN (
        SELECT
          X.*
        FROM
          (
            SELECT
              gt.settlement_id,
              gt.id,
              gt.invoice_id,
              gt.external_id,
              gt.payment_id,
              row_number() over(PARTITION by settlement_id) AS row_num,
              cg.encrypted_ref_id AS gx_customer_id,
              pr.encrypted_ref_id AS gx_provider_id
            FROM
              gaia_hint${environment}.gateway_transaction gt
              LEFT JOIN gaia_hint${environment}.invoice inv ON inv.id = gt.invoice_id
              LEFT JOIN gaia_hint${environment}.plan pl ON pl.id = inv.plan_id
              LEFT JOIN gaia_hint${environment}.customer cg ON cg.id = pl.customer_id
              LEFT JOIN gaia_hint${environment}.provider pr ON pr.id = cg.provider_id
            WHERE
              gt.settlement_id IS NOT NULL
              AND gt.invoice_id IS NOT null
          ) X
        WHERE
          X.row_num = 1
        UNION
        SELECT
          Y.*
        FROM
          (
            SELECT
              gt.settlement_id,
              gt.id,
              gt.invoice_id,
              gt.external_id,
              gt.payment_id,
              row_number() over(PARTITION by settlement_id) AS row_num,
              cg.encrypted_ref_id AS gx_customer_id,
              pr.encrypted_ref_id AS gx_provider_id
            FROM
              gaia_hint${environment}.gateway_transaction gt
              LEFT JOIN gaia_hint${environment}.payment pt ON pt.id = gt.payment_id
              LEFT JOIN gaia_hint${environment}.plan pl ON pl.id = pt.plan_id
              LEFT JOIN gaia_hint${environment}.customer cg ON cg.id = pl.customer_id
              LEFT JOIN gaia_hint${environment}.provider pr ON pr.id = cg.provider_id
            WHERE
              gt.invoice_id IS NULL
          ) Y
        WHERE
          Y.row_num = 1
      ) A ON A.settlement_id = settlement.settlement_id
  )
)
SELECT
  *
FROM
  CTE_Settlement
UNION ALL
SELECT
  c1.*
FROM
  CTE_Adj c1

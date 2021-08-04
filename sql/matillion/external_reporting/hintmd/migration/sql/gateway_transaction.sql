SELECT
  ROW_NUMBER() OVER (
    ORDER BY
      unique_date,
      gx_provider_id
  ) AS id,
  *
FROM
  (
    SELECT
      gx_provider_id,
      unique_date,
      round(total_fund, 2) AS total_fund,
      total_tran,
      sum(total_tran) OVER (
        PARTITION by gx_provider_id
        ORDER BY
          unique_date ROWS BETWEEN unbounded preceding
          AND CURRENT row
      ) AS sum_tran_to_date1,
      sum(total_fund) OVER (
        PARTITION by gx_provider_id
        ORDER BY
          unique_date ROWS BETWEEN unbounded preceding
          AND CURRENT row
      ) AS sum_fund_to_date1
    FROM
      (
        SELECT
          coalesce(
            tsq1.gx_provider_id, tsq2.gx_provider_id
          ) AS gx_provider_id,
          coalesce(tsq1.tran_date, tsq2.fund_date) AS unique_date,
          tsq1.total_tran,
          tsq2.total_fund
        FROM
          (
            SELECT
              ts.gx_provider_id,
              date(ts.transaction_created_at) AS tran_date,
              sum(ts.tran_tendered) AS total_tran
            FROM
              (
                SELECT
                  gateway_transaction.id AS tran_id,
                  gateway_transaction.tendered AS tran_tendered,
                  gateway_transaction.created_at AS transaction_created_at,
                  provider.encrypted_ref_id AS gx_provider_id
                FROM
                  gaia_hint${environment}.gateway_transaction
                  JOIN gaia_hint${environment}.authorisation ON destination_object_id = authorisation.id
                  JOIN gaia_hint${environment}.provider ON object_id = provider.id
                WHERE
                  source_object_name = 'card_payment_gateway'
                  AND gateway_transaction.status = 20
                  AND destination_object_name = 'authorisation'
                UNION
                SELECT
                  settlement.id AS tran_id,
                  settlement.amount * 100 AS tran_tenderd,
                  settlement.settlement_date AS transaction_created_at,
                  provider.encrypted_ref_id AS gx_provider_id
                FROM
                  gaia_hint${environment}.settlement
                  JOIN gaia_hint${environment}.authorisation ON authorisation_id = authorisation.id
                  JOIN gaia_hint${environment}.provider ON object_id = provider.id
                WHERE
                  gateway_transaction_id IS NULL
              ) ts
            WHERE
              tran_tendered IS NOT NULL
            GROUP BY
              ts.gx_provider_id,
              tran_date
          ) tsq1 FULL
          JOIN (
            SELECT
              tsf.gx_provider_id,
              date(tsf.funding_date) AS fund_date,
              sum(tsf.total_funding * 100) AS total_fund
            FROM
              (
                SELECT
                  provider.encrypted_ref_id AS gx_provider_id,
                  funding_date,
                  total_funding
                FROM
                  gaia_hint${environment}.funding
                  JOIN gaia_hint${environment}.authorisation ON authorisation_id = authorisation.id
                  JOIN gaia_hint${environment}.provider ON object_id = provider.id
                WHERE
                  object = 'provider'
              ) tsf
            WHERE
              total_funding IS NOT NULL
            GROUP BY
              tsf.gx_provider_id,
              fund_date
          ) tsq2 ON tsq1.gx_provider_id = tsq2.gx_provider_id
          AND tsq1.tran_date = tsq2.fund_date
      ) tt
  ) ttt

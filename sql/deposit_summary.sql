SELECT gx_provider_id, funding_master_id, interchange_fee + service_charge + fee + third_party AS fees, adjustment + other_adjustment AS adjustments, net_sales, total_funding, funding_date, date_added, reversal AS chargebacks, status, funding_id
FROM
(
 SELECT funding_master_id, net_sales*100 AS net_sales, third_party*100 AS third_party, adjustment*100 AS adjustment, interchange_fee*100 AS interchange_fee, service_charge*100 AS service_charge, fee*100 AS fee, reversal*100 AS reversal, other_adjustment*100 AS other_adjustment, total_funding*100 AS total_funding, funding_date, date_added,  provider.encrypted_ref_id AS gx_provider_id, funding.status, funding.id AS funding_id
        FROM funding
        JOIN authorisation ON authorisation_id = authorisation.id
        JOIN provider ON object_id = provider.id

) table2

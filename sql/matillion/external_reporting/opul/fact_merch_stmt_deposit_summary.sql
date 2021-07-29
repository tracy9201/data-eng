WITH month_date_range as
(
SELECT
    funding_month
    ,to_char(min( date_trunc('month', funding_date)::date),'MM/DD') || '-' ||to_char(max(last_day(funding_date)),'MM/DD') as range
    ,to_char(min( date_trunc('month', funding_date)::date),'MM/DD/YYYY') || '-' ||to_char(max(last_day(funding_date)),'MM/DD/YYYY') as range_with_year
FROM  
	dwh_opul.fact_merch_stmt_deposit_details
GROUP BY  1

),

main as
(
SELECT
	b.merchant_id
	,a.funding_month
    ,a.range
    ,a.range_with_year
	,sum(coalesce(b.transactions,0)) as Transactions
	,sum(coalesce(b.charges,0)) as Charges
	,sum(coalesce(b.refunds,0)) as Refunds
	,sum(coalesce(b.chargebacks,0)) as Chargebacks
	,sum(coalesce(b.adjustments,0)) as Adjustments
	,sum(coalesce(b.fees,0)) as total_fee
	,sum(coalesce(b.revenue,0)) as revenue
	,extract (epoch from a.funding_month) as epoch_funding_month
	,current_timestamp::timestamp as dwh_created_at
FROM 
	dwh_opul.fact_merch_stmt_deposit_details b
JOIN 
	month_date_range a on a.funding_month = b.funding_month
GROUP BY 1,2,3,4,12,13
)

SELECT * FROM main

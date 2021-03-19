DROP TABLE IF EXISTS ir_commercial.fact_subscription_practice_summary;

CREATE TABLE IF NOT EXISTS ir_commercial.fact_subscription_practice_summary
(
organization_id BIGINT ENCODE raw
, practice_name VARCHAR(MAX) ENCODE raw
, category VARCHAR(20) ENCODE raw
, count_by_category BIGINT ENCODE raw
    ,primary key(organization_id)
)
DISTSTYLE ALL
SORTKEY(organization_id)
;
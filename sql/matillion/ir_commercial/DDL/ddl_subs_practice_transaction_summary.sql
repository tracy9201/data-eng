CREATE TABLE IF NOT EXISTS ir_commercial.subs_practice_transaction_summary
(
organization_id BIGINT ENCODE raw
, practice_name VARCHAR(MAX) ENCODE raw
, category VARCHAR(20) ENCODE raw
, count_by_category BIGINT ENCODE raw
    ,primary key(organization_id)
);

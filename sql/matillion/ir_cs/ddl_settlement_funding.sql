DROP TABLE IF EXISTS ir_cs.settlement_funding;

CREATE TABLE IF NOT EXISTS ir_cs.settlement_funding (
    settlement_id int8,
    transaction_id varchar(64),
    type varchar(64),
    reason varchar(64),
    settlement_status varchar(64),
    settlement_date timestamp,
    funding_txn_id varchar(64),
    funding_created_date timestamp,
    funding_date timestamp,
    total_funding NUMERIC(18,2),
    interchange_fee NUMERIC(18,2),
    net_sales NUMERIC(18,2),
    other_adjustment NUMERIC(18,2),
    reversal NUMERIC(18,2),
    service_charge NUMERIC(18,2),
    third_party NUMERIC(18,2),
    fund_date_added timestamp
    ,primary key(settlement_id)
     ,UNIQUE(settlement_id)
)
DISTKEY (settlement_id)
SORTKEY (settlement_date)

;
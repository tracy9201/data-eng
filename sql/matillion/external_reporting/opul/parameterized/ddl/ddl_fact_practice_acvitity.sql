DROP TABLE IF  EXISTS dwh_opul${environment}.fact_practice_acvitity;

CREATE TABLE IF NOT EXISTS dwh_opul${environment}.fact_practice_acvitity(
transaction_id varchar(50) NOT NULL ENCODE raw,
    organization_id int8 NOT NULL ENCODE raw,
    transaction_status varchar(50) NOT NULL ENCODE raw,
    transaction_type varchar(50) NOT NULL ENCODE raw,
    transaction_method varchar(50) NOT NULL ENCODE raw,
    transaction_detail varchar(255) ENCODE raw,
    transaction_reason varchar(255) ENCODE raw,
    refundable_amount int4 ENCODE raw,
    description varchar(255) ENCODE raw,
    created_at_millis TIMESTAMP NOT NULL ENCODE raw,
    invoice_id varchar(50) NOT NULL ENCODE raw,
    invoice_status varchar(50) NOT NULL ENCODE raw,
    customer_id int4 NOT NULL ENCODE raw,
    customer_has_subscription BOOLEAN ENCODE raw,   
    customer_first_name varchar(50) NOT NULL ENCODE raw,
    customer_last_name varchar(50) NOT NULL ENCODE raw,
    customer_type varchar(50) NOT NULL ENCODE raw,
    customer_mobile varchar(20) ENCODE raw,
    team_member_id int4 ENCODE raw,
    team_member_first_name varchar(50) ENCODE raw,
    team_member_last_name varchar(50) ENCODE raw,
    device_id varchar(50) ENCODE raw,
    devie_hsn varchar(50) ENCODE raw,
    device_nickname varchar(50) ENCODE raw,
    primary key(transaction_id),
    UNIQUE(transaction_id, created_at_millis)
)
DISTKEY (transaction_id)
SORTKEY (transaction_id)
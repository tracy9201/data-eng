DROP TABLE IF EXISTS internal_reporting_hint.ddl_kronos_subscription;

CREATE TABLE IF NOT EXISTS internal_reporting_hint.ddl_kronos_subscription (
    subscription_id int8,
    plan_id int8,
    created_at timestamp,
    updated_at timestamp,
    deprecated_at timestamp,
    multiple_treatments_times int4,
    product_quantity int4,
    product_unit_name varchar(65535),
    subscription_status varchar(16),
    treatment_period int4,
    is_subscription bool,
    subscription_type varchar(32),
    cancelled_at timestamp,
    remaining_payment int4,
    payment_balance int4,
    discount_amts int4,
    tax int4,
    total_payment int4,
    current_period_start_date timestamp,
    current_period_end_date timestamp,
    gx_subscription_id varchar(64),
    offering_id int4,
    subscription_name varchar(65535),
    g_status int4
    ,dwh_created_at timestamp
    ,primary key(subscription_id)
     ,UNIQUE(subscription_id)
)
DISTKEY (subscription_id)
SORTKEY (subscription_id)

;
CREATE TABLE IF NOT EXISTS ${schema}${environment}.subscription
(
id                      bigint NOT NULL,
plan_id                 bigint,
payment_plan_id         bigint,
fulfillment_plan_id     bigint,
product_id              bigint,
quantity                integer,
unit_name               varchar(255),
remaining_payment       integer,
balance                 integer,
price                   integer,
discount_amts           integer,
discount_percentages    integer,
coupons                 integer,
credits                 integer,
payments                integer,
total_installment       integer,
tax                     integer,
tax_percentage          integer,
subtotal                integer,
total                   integer,
start_date              timestamp without time zone,
end_date                timestamp without time zone,
end_count               integer,
end_unit                varchar(64),
proration               boolean,
auto_renewal            boolean,
renewal_count           integer,
name                    varchar(65535),
canceled_at             timestamp without time zone,
deleted_at              timestamp without time zone,
status                  smallint,
created_at              timestamp without time zone,
updated_at              timestamp without time zone,
encrypted_ref_id         varchar(65535),
external_subscription_id varchar(65535),
offering_id              varchar(65535)
) DISTKEY(id)

DROP TABLE IF EXISTS ir_commercial.fact_transactions_to_subscription;

CREATE TABLE IF NOT EXISTS ir_commercial.fact_transactions_to_subscription
(
id VARCHAR(MAX) ENCODE raw
, user_id BIGINT ENCODE raw
, payment_method VARCHAR(255) ENCODE raw
, transaction VARCHAR(255) ENCODE raw
, amount DECIMAL(20,9) ENCODE raw
, created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
, updated_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
, customer_type VARCHAR(MAX) ENCODE raw
, invoice_item_id BIGINT ENCODE raw
, subscription_type BIGINT ENCODE raw
, offering_id BIGINT ENCODE raw
, ad_hoc_offering_id BIGINT ENCODE raw
, organization_id BIGINT ENCODE raw
, live BOOLEAN ENCODE raw
, name VARCHAR(MAX) ENCODE raw
  ,primary key(id,invoice_item_id)
)

DISTKEY (organization_id)
SORTKEY (organization_id, id, invoice_item_id)
;

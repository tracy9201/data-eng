DROP TABLE IF EXISTS ir_commercial.membership_status_derived_practice;

CREATE TABLE IF NOT EXISTS ir_commercial.membership_status_derived_practice
(

  id bigint ENCODE raw
  ,created_date DATE   ENCODE raw
  ,updated_date DATE  ENCODE raw
  ,status VARCHAR(64)   ENCODE raw
  ,gx_customer_id VARCHAR(64)   ENCODE raw
  ,gx_provider_id VARCHAR(64)   ENCODE raw
  ,state VARCHAR(64)   ENCODE raw
  ,business_name bigint ENCODE raw
  ,membership_length bigint ENCODE raw
  ,avg_membership_length bigint ENCODE raw
  ,primary key(id)
)
;

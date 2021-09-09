DROP TABLE IF EXISTS ir_commercial.practice;

CREATE TABLE IF NOT EXISTS ir_commercial.practice
(
   gx_provider_id VARCHAR(64)   ENCODE raw
  ,created_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,deprecated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,status VARCHAR(255)   ENCODE raw
  ,per_member_rate NUMERIC(18,2)   ENCODE raw
  ,practice_rate NUMERIC(18,2)   ENCODE raw
  ,timezone VARCHAR(64)   ENCODE raw 
  ,activated_at TIMESTAMP WITHOUT TIME ZONE   ENCODE raw
  ,live boolean   ENCODE raw
  ,payfac boolean   ENCODE raw
  ,organization_tax_percentage NUMERIC(18,2)   ENCODE raw
  ,city VARCHAR(64)   ENCODE raw
  ,state VARCHAR(64)   ENCODE raw
  ,zip VARCHAR(16) ENCODE raw
  ,business_name VARCHAR(MAX)   ENCODE raw
  ,org_id VARCHAR(64)   ENCODE raw
  ,primary key(gx_provider_id)
)
;
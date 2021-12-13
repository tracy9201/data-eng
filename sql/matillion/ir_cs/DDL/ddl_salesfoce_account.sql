DROP 
  TABLE IF EXISTS internal_reporting_hint.salesforce_account;
CREATE TABLE IF NOT EXISTS internal_reporting_hint.salesforce_account (
  status VARCHAR(64) ENCODE raw, 
  accountsource VARCHAR(64) ENCODE raw, 
  customer_type VARCHAR(64) ENCODE raw, 
  name VARCHAR(max) ENCODE raw, 
  hint_organization_id VARCHAR(max) ENCODE raw, 
  territory VARCHAR(64) ENCODE raw, 
  region VARCHAR(64) ENCODE raw,  
  opul_organization_id VARCHAR(max) ENCODE raw, 
  revance_code VARCHAR(64) ENCODE raw,
  primary key(name)
);

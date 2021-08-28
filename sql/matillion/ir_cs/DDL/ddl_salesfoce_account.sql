DROP 
  TABLE IF EXISTS ir_cs.salesforce_account;
CREATE TABLE IF NOT EXISTS ir_cs.salesforce_account (
  status VARCHAR(64) ENCODE raw, 
  accountsource VARCHAR(64) ENCODE raw, 
  customer_type VARCHAR(64) ENCODE raw, 
  name VARCHAR(max) ENCODE raw, 
  organization_id VARCHAR(max) ENCODE raw, 
  territory VARCHAR(64) ENCODE raw, 
  region VARCHAR(64) ENCODE raw,  
  primary key(name)
);

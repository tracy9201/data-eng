DROP TABLE IF EXISTS dwh_opul${environment}.fact_deposit_details;   

CREATE TABLE IF NOT EXISTS dwh_opul${environment}.fact_deposit_details
(  merchant_id VARCHAR(255) ENCODE raw
  ,funding_instruction_id VARCHAR(255) ENCODE raw
  ,transaction_id VARCHAR(255) ENCODE raw
  ,transaction_date TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,transaction_type VARCHAR(255) ENCODE raw
  ,transaction_amount NUMERIC(18,2)   ENCODE raw
  ,cp_or_cnp  VARCHAR(255) ENCODE raw
  ,funding_date  TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,settled_at_date  TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,card_brand  VARCHAR(255) ENCODE raw
  ,subscriber  VARCHAR(255) ENCODE raw
  ,gx_customer_id  VARCHAR(255) ENCODE raw
  ,payment_id  VARCHAR(255) ENCODE raw
  ,epoch_transaction_date BIGINT ENCODE raw
  ,epoch_funding_date BIGINT ENCODE raw
  ,epoch_settled_at_date BIGINT ENCODE raw
  ,dwh_created_at TIMESTAMP WITHOUT TIME ZONE ENCODE raw
  ,ft_percent_fee NUMERIC(18,2)   ENCODE raw
  ,ft_fees NUMERIC(18,2)   ENCODE raw
  ,primary key(transaction_id)
  ,UNIQUE(merchant_id,transaction_id,funding_instruction_id)  
)
DISTKEY(merchant_id)  
SORTKEY(merchant_id, transaction_date, epoch_transaction_date, settled_at_date, epoch_funding_date);

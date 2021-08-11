DROP TABLE IF EXISTS dwh_hint${environment}.settlement_funding;
CREATE TABLE IF NOT EXISTS dwh_hint${environment}.settlement_funding (
  settlement_id varchar(255) ENCODE RAW,
  funding_txn_id varchar(255) ENCODE RAW,
  settlement_type varchar(255) ENCODE RAW ,
  settlement_date timestamp without time zone ENCODE RAW,
  interchange_unit_fee numeric ENCODE RAW,
  interchange_percentage_fee numeric ENCODE RAW,
  card_brand varchar(255) ENCODE RAW,
  last_four varchar(8) ENCODE RAW,
  settlement_status varchar(255) ENCODE RAW,
  gateway_transaction_id bigint ENCODE RAW,
  authorisation_id bigint ENCODE RAW,
  settlement_amount numeric ENCODE RAW,
  gx_customer_id varchar(255) ENCODE RAW,
  gx_provider_id varchar(255) ENCODE RAW
) DISTKEY(authorisation_id, gx_provider_id);

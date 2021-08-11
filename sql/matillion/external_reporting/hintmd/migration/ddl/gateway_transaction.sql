DROP TABLE IF EXISTS dwh_hint${environment}.gateway_transaction;

CREATE TABLE IF NOT EXISTS dwh_hint${environment}.gateway_transaction
(
  id	                     bigint ENCODE RAW,
  name	                   varchar(65535) ENCODE RAW,
  external_id	             varchar(255) ENCODE RAW,
  idempotency_key	         varchar(255) ENCODE RAW,
  transaction_id	         varchar(255) ENCODE RAW,
  payment_gateway_id	     bigint ENCODE RAW,
  invoice_id	             bigint ENCODE RAW,
  invoice_item_id	         bigint ENCODE RAW,
  card_payment_gateway_id	 bigint ENCODE RAW,
  source_object_name	     varchar(250) ENCODE RAW,
  source_object_id	       bigint  ENCODE RAW,
  payment_id	             bigint  ENCODE RAW,
  amount	                 integer ENCODE RAW,
  tendered	               integer ENCODE RAW,
  type	                   varchar(16) ENCODE RAW,
  reason	                 varchar(255) ENCODE RAW,
  currency	               varchar(8) ENCODE RAW,
  status	                 smallint ENCODE RAW,
  created_at	             timestamp without time zone  ENCODE RAW,
  updated_at	             timestamp without time zone  ENCODE RAW,
  canceled_at	             timestamp without time zone  ENCODE RAW,
  deleted_at	             timestamp without time zone  ENCODE RAW,
  destination_object_name	 varchar(255) ENCODE RAW,
  destination_object_id	   bigint  ENCODE RAW,
  settlement_id	           bigint  ENCODE RAW,
  entry_mode	             varchar(8) ENCODE RAW,
  entry_capability	       varchar(8) ENCODE RAW,
  condition_code	         varchar(8) ENCODE RAW,
  category_code	           varchar(8) ENCODE RAW,
  encrypted_ref_id	       varchar(27) ENCODE RAW,
  is_voided	               boolean,
  gratuity_amount	         bigint  ENCODE RAW,
  credit_id	               bigint ENCODE RAW
) DISTKEY(id);
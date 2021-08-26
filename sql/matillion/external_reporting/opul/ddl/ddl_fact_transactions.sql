drop table IF EXISTS  dwh_opul_qe.fact_transactions;


create table dwh_opul_qe.fact_transactions  (
"transaction_id" varchar(50) NOT NULL ENCODE raw,

"organization_id" int8 NOT NULL ENCODE raw,

"transaction_status" varchar(50) NOT NULL ENCODE raw,

"transaction_type" varchar(50) NOT NULL ENCODE raw,

"transaction_method" varchar(50) NOT NULL ENCODE raw,

"transaction_details" varchar(255) ENCODE raw,

"transaction_reason" varchar(255) ENCODE raw,

"amount" int4 ENCODE raw,

"amount_available_to_refund" int4 ENCODE raw,

"description" varchar(255) ENCODE raw,

"created_at" TIMESTAMP ENCODE raw,

"invoice_id" varchar(50) ENCODE raw,

"invoice_status" varchar(50) ENCODE raw,

"customer_id" int8 ENCODE raw,

"customer_active_subscription" Boolean ENCODE raw, 

"customer_first_name" varchar(50) NOT NULL ENCODE raw,

"customer_last_name" varchar(50) NOT NULL ENCODE raw,

"customer_type" varchar(50) ENCODE raw,

"customer_mobile" varchar(20) ENCODE raw,

"team_member_id" bigint ENCODE raw,

"team_member_first_name" varchar(50) ENCODE raw,

"team_member_last_name" varchar(50) ENCODE raw,

"device_id" varchar(50) ENCODE raw,
  
"device_hsn" varchar(50) ENCODE raw,

"device_nickname" varchar(50) ENCODE raw,

"customer_user_id" int8 ENCODE raw,

"gratuity_amount" int4 ENCODE raw,

 "total" int4 ENCODE raw,
  
"card_id" int8 ENCODE raw,

"card_brand" varchar(50) ENCODE raw,
  
"card_last4" varchar(50) ENCODE raw,
  
"card_exp_month" int4 ENCODE raw,
  
"card_exp_year" int4 ENCODE raw
  
  ,primary key(transaction_id)
  ,UNIQUE(organization_id, invoice_id)
)
DISTSTYLE ALL
INTERLEAVED SORTKEY (transaction_id, transaction_status, transaction_type, transaction_method, transaction_details, transaction_reason, amount, customer_active_subscription,
customer_first_name, customer_last_name, customer_type, customer_mobile, team_member_first_name, team_member_last_name, device_nickname, gratuity_amount, total);
;
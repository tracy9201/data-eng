create table IF NOT EXISTS dwh.dim_customer
(
  k_customer_id BIGINT,
  member_on_boarding_date VARCHAR(10),
  member_cancel_date VARCHAR(10),
  customer_email VARCHAR(255),
  customer_mobile VARCHAR(255),
  customer_gender INTEGER,
  customer_birth_year VARCHAR(4),
  gx_customer_id VARCHAR(32),
  customer_type VARCHAR(64),
  customer_city VARCHAR(64),
  customer_state VARCHAR(64),
  customer_zip VARCHAR(64),
  user_type INTEGER,
  firstname VARCHAR(255),
  lastname VARCHAR(255),
  	primary key(k_customer_id),
    unique(gx_customer_id)
)
DISTSTYLE EVEN;
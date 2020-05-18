create table if not exists dwh.fact_invoice_item
  (
    id VARCHAR(255),
    pay_date timestamp without time zone,
    invoice BIGINT,
    subscription_id BIGINT,
    Units INTEGER,
    unit_type varchar(255),
    price_unit INTEGER,
    subscription_cycle INTEGER,
    total_price BIGINT,
    recurring_payment BIGINT,
    invoice_amount BIGINT,
    discounted_Price BIGINT,
    tax_charged BIGINT,
    tax_percentage INTEGER,
    item_discount BIGINT,
    discount_reason VARCHAR(MAX),
    grand_total BIGINT,
    gx_subscription_id VARCHAR(32),
    gx_customer_id VARCHAR(32),
    gx_provider_id VARCHAR(32),
    count_of_invoice_item BIGINT,
    invoice_level VARCHAR(10),
    	primary key(id),
    	foreign key(gx_subscription_id) references dwh.dim_offering(gx_subscription_id),
    	foreign key(gx_customer_id) references dwh.dim_customer(gx_customer_id),
    	foreign key(gx_provider_id) references dwh.dim_provider(gx_provider_id)

  )
  DISTSTYLE EVEN;
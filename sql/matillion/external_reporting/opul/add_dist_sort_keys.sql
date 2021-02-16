--------------------------- ADDING DIST KEYS ---------------------------

ALTER TABLE dwh_opul.dim_customer
ALTER DISTSTYLE KEY DISTKEY gx_customer_id ;


ALTER TABLE dwh_opul.dim_practice
ALTER DISTSTYLE ALL;

ALTER TABLE dwh_opul.dim_staff
ALTER DISTSTYLE ALL;

ALTER TABLE dwh_opul.dim_p2pe_device
ALTER DISTSTYLE ALL;

ALTER TABLE dwh_opul.fact_product_sales
ALTER DISTSTYLE KEY DISTKEY k_customer_id ;


ALTER TABLE dwh_opul.fact_payment_summary
ALTER DISTSTYLE KEY DISTKEY gx_customer_id;

ALTER TABLE dwh_opul.fact_batch_report_summary
ALTER DISTSTYLE KEY DISTKEY gx_provider_id;

--------------------------- ADDING SORT KEYS ---------------------------

ALTER TABLE dwh_opul.dim_customer
ALTER SORTKEY (gx_customer_id,user_type) ;

ALTER TABLE dwh_opul.dim_practice
ALTER SORTKEY (gx_provider_id,k_practice_id) ;

ALTER TABLE dwh_opul.dim_staff
ALTER SORTKEY (user_id) ;

ALTER TABLE dwh_opul.dim_p2pe_device
ALTER SORTKEY (device_uuid,label,status) ;

ALTER TABLE dwh_opul.fact_batch_report_details
ALTER SORTKEY (epoch_sales_created_at,gx_customer_id,gx_provider_id,staff_user_id,device_id,sales_type,sales_id,category) ;


ALTER TABLE dwh_opul.fact_batch_report_summary
ALTER SORTKEY (gx_provider_id,epoch_sales_created_at,payment_method,category,device_id);



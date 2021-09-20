-- public.encrypt_sensitive_data definition

-- Drop table

-- DROP TABLE public.encrypt_sensitive_data;


CREATE TABLE IF NOT EXISTS public.encrypt_sensitive_data
(
	id INTEGER  DEFAULT "identity"(8548400, 0, '0,1'::text) ENCODE az64
	,_host VARCHAR(1000) NOT NULL DEFAULT 'qa-reporting-cluster.cmmotnszowfl.us-east-1.redshift.amazonaws.com'::CHARACTER varying  ENCODE lzo
	,_database VARCHAR(64) NOT NULL DEFAULT 'reportingdb'::character varying ENCODE lzo
	,_schema VARCHAR(127) NOT NULL  ENCODE lzo
	,_table VARCHAR(127) NOT NULL  ENCODE lzo
	,_column VARCHAR(127) NOT NULL  ENCODE lzo
	,sensitive_data_type VARCHAR(1000) not null DEFAULT 'PII'::character varying  ENCODE lzo
	,is_ready_for_encryption BOOLEAN NOT NULL DEFAULT true ENCODE RAW
	,is_encrypted BOOLEAN NOT NULL DEFAULT false ENCODE RAW
	,encryption_start TIMESTAMP WITH TIME ZONE   ENCODE az64
	,encryption_end TIMESTAMP WITH TIME ZONE   ENCODE az64
	,encrypted_row_count INTEGER   ENCODE RAW
	,is_encryption_confirmed BOOLEAN NOT NULL DEFAULT false ENCODE RAW
	,audit_by VARCHAR(1000)   ENCODE lzo
	,audit_on TIMESTAMP WITH TIME ZONE   ENCODE az64
	,audit_comment VARCHAR(2000)   ENCODE lzo
	,inserted_by VARCHAR(100) NOT NULL  ENCODE lzo
	,inserted_on TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT ('now'::character varying)::timestamp with time zone ENCODE az64
	,inserted_comment VARCHAR(2000)   ENCODE lzo
	,PRIMARY KEY (_host, _database, _schema, _table, _column)
)
DISTSTYLE AUTO
;
ALTER TABLE public.encrypt_sensitive_data owner to qadbadmin;

-- Permissions

GRANT INSERT, SELECT, UPDATE, DELETE, RULE, REFERENCES, TRIGGER ON TABLE public.encrypt_sensitive_data TO qadbadmin;
GRANT SELECT ON TABLE public.encrypt_sensitive_data TO looker;




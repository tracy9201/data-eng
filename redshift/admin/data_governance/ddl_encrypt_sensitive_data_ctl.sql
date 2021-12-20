-- public.encrypt_sensitive_data_ctl definition

-- Drop table

-- DROP TABLE public.encrypt_sensitive_data_ctl;

DROP TABLE public.encrypt_sensitive_data_ctl;
CREATE TABLE IF NOT EXISTS public.encrypt_sensitive_data_ctl
(
	id INTEGER  DEFAULT "identity"(9300294, 0, ('0,1'::character varying)::text) ENCODE az64
	,_env_dw VARCHAR(64) NOT NULL DEFAULT 'qa'::character varying ENCODE lzo
	,_env_type VARCHAR(64)   ENCODE lzo
	,_env_dbtype VARCHAR(64)   ENCODE lzo
	,_host VARCHAR(1000) NOT NULL DEFAULT 'qa-reporting-cluster.cmmotnszowfl.us-east-1.redshift.amazonaws.com'::character varying ENCODE lzo
	,_database VARCHAR(64) NOT NULL DEFAULT 'reportingdb'::character varying ENCODE lzo
	,_schema VARCHAR(127) NOT NULL  ENCODE lzo
	,_table VARCHAR(127) NOT NULL  ENCODE lzo
	,_column VARCHAR(127) NOT NULL  ENCODE lzo
	,_columnlength SMALLINT   ENCODE RAW
	,sensitive_data_type VARCHAR(1000) NOT NULL DEFAULT 'PII'::character varying ENCODE lzo
	,is_ready_for_encryption BOOLEAN NOT NULL DEFAULT true ENCODE RAW
	,is_encrypted BOOLEAN NOT NULL DEFAULT false ENCODE RAW
	,encryption_start TIMESTAMP WITH TIME ZONE   ENCODE az64
	,encryption_end TIMESTAMP WITH TIME ZONE   ENCODE az64
	,encrypted_row_count INTEGER   ENCODE RAW
	,code_message VARCHAR(5000)   ENCODE lzo
	,is_encryption_confirmed BOOLEAN NOT NULL DEFAULT false ENCODE RAW
	,encryption_audit_by VARCHAR(1000)   ENCODE lzo
	,encryption_audit_on TIMESTAMP WITH TIME ZONE   ENCODE az64
	,encryption_audit_comment VARCHAR(2000)   ENCODE lzo
	,is_ready_for_transfer BOOLEAN NOT NULL DEFAULT true ENCODE RAW
	,inserted_by VARCHAR(100) NOT NULL  ENCODE lzo
	,inserted_on TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT ('now'::character varying)::timestamp with time zone ENCODE az64
	,inserted_comment VARCHAR(2000)   ENCODE lzo
	,updated_by VARCHAR(100)   ENCODE lzo
	,updated_on TIMESTAMP WITH TIME ZONE  DEFAULT ('now'::character varying)::timestamp with time zone ENCODE az64
	,updated_comment VARCHAR(2000)   ENCODE lzo
	,_columntype VARCHAR(80)   ENCODE RAW
	,_columnfeed VARCHAR(127)   ENCODE lzo
	,set_column_to_null BOOLEAN NOT NULL DEFAULT false ENCODE RAW
	,PRIMARY KEY (_host, _database, _schema, _table, _column)
)
DISTSTYLE AUTO
;
ALTER TABLE public.encrypt_sensitive_data_ctl owner to qadbadmin;

-- Permissions

GRANT INSERT, SELECT, UPDATE, DELETE, RULE, REFERENCES, TRIGGER ON TABLE public.encrypt_sensitive_data_ctl TO qadbadmin;
GRANT SELECT ON TABLE public.encrypt_sensitive_data_ctl TO looker;
GRANT SELECT ON TABLE public.encrypt_sensitive_data_ctl TO smithap;

ANALYZE VERBOSE public.encrypt_sensitive_data_ctl;


-- public.encrypt_sensitive_data_ctl_dump_table_list_temp definition

-- Drop table

-- DROP TABLE public.encrypt_sensitive_data_ctl_dump_table_list_temp;

--DROP TABLE public.encrypt_sensitive_data_ctl_dump_table_list_temp;
CREATE TABLE IF NOT EXISTS public.encrypt_sensitive_data_ctl_dump_table_list_temp
(
	id INTEGER  DEFAULT "identity"(9117610, 0, ('0,1'::character varying)::text) ENCODE az64
	,_env_dw VARCHAR(64) NOT NULL DEFAULT 'qa'::character varying ENCODE lzo
	,_host VARCHAR(1000) NOT NULL DEFAULT 'qa-reporting-cluster.cmmotnszowfl.us-east-1.redshift.amazonaws.com'::character varying ENCODE lzo
	,_database VARCHAR(64) NOT NULL DEFAULT 'reportingdb'::character varying ENCODE lzo
	,_schema VARCHAR(127) NOT NULL  ENCODE lzo
	,_table VARCHAR(127) NOT NULL  ENCODE lzo
	,code_message VARCHAR(2000)   ENCODE lzo
	,inserted_by VARCHAR(100) NULL  ENCODE lzo
	,inserted_on TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT ('now'::character varying)::timestamp with time zone ENCODE az64
	,inserted_comment VARCHAR(2000)   ENCODE lzo
	,audit_by VARCHAR(1000)   ENCODE lzo
	,audit_on TIMESTAMP WITH TIME ZONE   ENCODE az64
	,audit_comment VARCHAR(2000)   ENCODE lzo
	,PRIMARY KEY (_host, _database, _schema, _table)
)
DISTSTYLE AUTO
;
ALTER TABLE public.encrypt_sensitive_data_ctl_dump_table_list_temp owner to qadbadmin;

-- Permissions;
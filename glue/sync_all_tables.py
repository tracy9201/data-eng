
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

## @params: [TempDir, JOB_NAME]
args = getResolvedOptions(sys.argv, ['TempDir','JOB_NAME'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
            



######v4_g_account######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_account = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_account", transformation_ctx = "datasource_v4_g_account", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_account = ApplyMapping.apply(frame = datasource_v4_g_account, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('business_id', 'string', 'business_id', 'string'), ('bank_name', 'string', 'bank_name', 'string'), ('bank_account', 'string', 'bank_account', 'string'), ('bank_routing', 'string', 'bank_routing', 'string'), ('identifier', 'string', 'identifier', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_account")

resolvechoice_v4_g_account = ResolveChoice.apply(frame = applymapping_v4_g_account, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_account")

dropnullfields_v4_g_account = DropNullFields.apply(frame = resolvechoice_v4_g_account, transformation_ctx = "dropnullfields_v4_g_account")

target_table = "v4data_public_v4_g_account"

stage_table = "test.stage_v4data_public_v4_g_account"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    business_id,
    bank_name,
    bank_account,
    bank_routing,
    identifier,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_account = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_account, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_account", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_account")

job.commit()



######v4_g_account_payment_gateway######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_account_payment_gateway = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_account_payment_gateway", transformation_ctx = "datasource_v4_g_account_payment_gateway", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_account_payment_gateway = ApplyMapping.apply(frame = datasource_v4_g_account_payment_gateway, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('account_id', 'long', 'account_id', 'long'), ('payment_gateway_id', 'long', 'payment_gateway_id', 'long'), ('reference_id', 'string', 'reference_id', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_account_payment_gateway")

resolvechoice_v4_g_account_payment_gateway = ResolveChoice.apply(frame = applymapping_v4_g_account_payment_gateway, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_account_payment_gateway")

dropnullfields_v4_g_account_payment_gateway = DropNullFields.apply(frame = resolvechoice_v4_g_account_payment_gateway, transformation_ctx = "dropnullfields_v4_g_account_payment_gateway")

target_table = "v4data_public_v4_g_account_payment_gateway"

stage_table = "test.stage_v4data_public_v4_g_account_payment_gateway"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    account_id,
    payment_gateway_id,
    reference_id,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_account_payment_gateway = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_account_payment_gateway, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_account_payment_gateway", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_account_payment_gateway")

job.commit()



######v4_g_address######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_address = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_address", transformation_ctx = "datasource_v4_g_address", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_address = ApplyMapping.apply(frame = datasource_v4_g_address, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('street_line1', 'string', 'street_line1', 'string'), ('street_line2', 'string', 'street_line2', 'string'), ('city', 'string', 'city', 'string'), ('state', 'string', 'state', 'string'), ('zip', 'string', 'zip', 'string'), ('country', 'string', 'country', 'string'), ('addr_validate', 'string', 'addr_validate', 'string'), ('owner_object', 'string', 'owner_object', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_address")

resolvechoice_v4_g_address = ResolveChoice.apply(frame = applymapping_v4_g_address, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_address")

dropnullfields_v4_g_address = DropNullFields.apply(frame = resolvechoice_v4_g_address, transformation_ctx = "dropnullfields_v4_g_address")

target_table = "v4data_public_v4_g_address"

stage_table = "test.stage_v4data_public_v4_g_address"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    street_line1,
    street_line2,
    city,
    state,
    zip,
    country,
    addr_validate,
    owner_object,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_address = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_address, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_address", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_address")

job.commit()



######v4_g_authorisation######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_authorisation = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_authorisation", transformation_ctx = "datasource_v4_g_authorisation", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_authorisation = ApplyMapping.apply(frame = datasource_v4_g_authorisation, mappings =  [('id', 'int', 'id', 'int'), ('name', 'string', 'name', 'string'), ('object_id', 'int', 'object_id', 'int'), ('object', 'string', 'object', 'string'), ('site', 'string', 'site', 'string'), ('type', 'string', 'type', 'string'), ('status', 'int', 'status', 'int'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp')], transformation_ctx = "applymapping_v4_g_authorisation")

resolvechoice_v4_g_authorisation = ResolveChoice.apply(frame = applymapping_v4_g_authorisation, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_authorisation")

dropnullfields_v4_g_authorisation = DropNullFields.apply(frame = resolvechoice_v4_g_authorisation, transformation_ctx = "dropnullfields_v4_g_authorisation")

target_table = "v4data_public_v4_g_authorisation"

stage_table = "test.stage_v4data_public_v4_g_authorisation"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    object_id,
    object,
    site,
    type,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_authorisation = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_authorisation, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_authorisation", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_authorisation")

job.commit()



######v4_g_billing_plan######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_billing_plan = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_billing_plan", transformation_ctx = "datasource_v4_g_billing_plan", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_billing_plan = ApplyMapping.apply(frame = datasource_v4_g_billing_plan, mappings =  [('id', 'long', 'id', 'long'), ('provider_id', 'long', 'provider_id', 'long'), ('name', 'string', 'name', 'string'), ('billing_frequency', 'string', 'billing_frequency', 'string'), ('billing_count', 'int', 'billing_count', 'int'), ('currency', 'string', 'currency', 'string'), ('deposit_to', 'string', 'deposit_to', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_billing_plan")

resolvechoice_v4_g_billing_plan = ResolveChoice.apply(frame = applymapping_v4_g_billing_plan, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_billing_plan")

dropnullfields_v4_g_billing_plan = DropNullFields.apply(frame = resolvechoice_v4_g_billing_plan, transformation_ctx = "dropnullfields_v4_g_billing_plan")

target_table = "v4data_public_v4_g_billing_plan"

stage_table = "test.stage_v4data_public_v4_g_billing_plan"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    provider_id,
    name,
    billing_frequency,
    billing_count,
    currency,
    deposit_to,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_billing_plan = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_billing_plan, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_billing_plan", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_billing_plan")

job.commit()



######v4_g_charge_back######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_charge_back = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_charge_back", transformation_ctx = "datasource_v4_g_charge_back", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_charge_back = ApplyMapping.apply(frame = datasource_v4_g_charge_back, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('payment_gateway_id', 'long', 'payment_gateway_id', 'long'), ('authorisation_id', 'long', 'authorisation_id', 'long'), ('funding_charge_back_id', 'string', 'funding_charge_back_id', 'string'), ('deposit_date', 'timestamp', 'deposit_date', 'timestamp'), ('amount', 'decimal(38,0)', 'amount', 'decimal(38,0)'), ('transaction_date', 'timestamp', 'transaction_date', 'timestamp'), ('reason_description', 'string', 'reason_description', 'string'), ('reason_code', 'string', 'reason_code', 'string'), ('date_changed', 'timestamp', 'date_changed', 'timestamp'), ('source_transaction_id', 'string', 'source_transaction_id', 'string'), ('transaction_amount', 'string', 'transaction_amount', 'string'), ('charge_back_date', 'timestamp', 'charge_back_date', 'timestamp'), ('sequence_number', 'string', 'sequence_number', 'string'), ('date_added', 'timestamp', 'date_added', 'timestamp'), ('auth_code', 'string', 'auth_code', 'string'), ('funding_master_id', 'string', 'funding_master_id', 'string'), ('case_number', 'string', 'case_number', 'string'), ('acquire_reference_number', 'string', 'acquire_reference_number', 'string'), ('card_number', 'string', 'card_number', 'string'), ('transaction_id', 'string', 'transaction_id', 'string'), ('invoice_number', 'string', 'invoice_number', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_charge_back")

resolvechoice_v4_g_charge_back = ResolveChoice.apply(frame = applymapping_v4_g_charge_back, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_charge_back")

dropnullfields_v4_g_charge_back = DropNullFields.apply(frame = resolvechoice_v4_g_charge_back, transformation_ctx = "dropnullfields_v4_g_charge_back")

target_table = "v4data_public_v4_g_charge_back"

stage_table = "test.stage_v4data_public_v4_g_charge_back"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    payment_gateway_id,
    authorisation_id,
    funding_charge_back_id,
    deposit_date,
    amount,
    transaction_date,
    reason_description,
    reason_code,
    date_changed,
    source_transaction_id,
    transaction_amount,
    charge_back_date,
    sequence_number,
    date_added,
    auth_code,
    funding_master_id,
    case_number,
    acquire_reference_number,
    card_number,
    transaction_id,
    invoice_number,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_charge_back = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_charge_back, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_charge_back", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_charge_back")

job.commit()



######v4_g_coupon######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_coupon = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_coupon", transformation_ctx = "datasource_v4_g_coupon", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_coupon = ApplyMapping.apply(frame = datasource_v4_g_coupon, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('status', 'short', 'status', 'short'), ('subscription_id', 'long', 'subscription_id', 'long'), ('provider_id', 'long', 'provider_id', 'long'), ('description', 'string', 'description', 'string'), ('code', 'string', 'code', 'string'), ('amount_off', 'int', 'amount_off', 'int'), ('redemption_limit', 'int', 'redemption_limit', 'int'), ('currency', 'string', 'currency', 'string'), ('start_date', 'timestamp', 'start_date', 'timestamp'), ('end_date', 'timestamp', 'end_date', 'timestamp'), ('count', 'int', 'count', 'int'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_coupon")

resolvechoice_v4_g_coupon = ResolveChoice.apply(frame = applymapping_v4_g_coupon, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_coupon")

dropnullfields_v4_g_coupon = DropNullFields.apply(frame = resolvechoice_v4_g_coupon, transformation_ctx = "dropnullfields_v4_g_coupon")

target_table = "v4data_public_v4_g_coupon"

stage_table = "test.stage_v4data_public_v4_g_coupon"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    canceled_at,
    deleted_at,
    status,
    subscription_id,
    provider_id,
    description,
    code,
    amount_off,
    redemption_limit,
    currency,
    start_date,
    end_date,
    count,
    created_at,
    updated_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_coupon = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_coupon, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_coupon", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_coupon")

job.commit()



######v4_g_credit######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_credit = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_credit", transformation_ctx = "datasource_v4_g_credit", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_credit = ApplyMapping.apply(frame = datasource_v4_g_credit, mappings =  [('id', 'long', 'id', 'long'), ('plan_id', 'long', 'plan_id', 'long'), ('subscription_id', 'long', 'subscription_id', 'long'), ('fulfillment_id', 'long', 'fulfillment_id', 'long'), ('amount', 'int', 'amount', 'int'), ('balance', 'int', 'balance', 'int'), ('currency', 'string', 'currency', 'string'), ('name', 'string', 'name', 'string'), ('type', 'string', 'type', 'string'), ('use_type', 'string', 'use_type', 'string'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string'), ('created_by', 'string', 'created_by', 'string'), ('updated_by', 'string', 'updated_by', 'string'), ('card_brand', 'string', 'card_brand', 'string')], transformation_ctx = "applymapping_v4_g_credit")

resolvechoice_v4_g_credit = ResolveChoice.apply(frame = applymapping_v4_g_credit, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_credit")

dropnullfields_v4_g_credit = DropNullFields.apply(frame = resolvechoice_v4_g_credit, transformation_ctx = "dropnullfields_v4_g_credit")

target_table = "v4data_public_v4_g_credit"

stage_table = "test.stage_v4data_public_v4_g_credit"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    plan_id,
    subscription_id,
    fulfillment_id,
    amount,
    balance,
    currency,
    name,
    type,
    use_type,
    canceled_at,
    deleted_at,
    status,
    created_at,
    updated_at,
    encrypted_ref_id,
    created_by,
    updated_by,
    card_brand
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_credit = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_credit, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_credit", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_credit")

job.commit()



######v4_g_customer######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_customer = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_customer", transformation_ctx = "datasource_v4_g_customer", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_customer = ApplyMapping.apply(frame = datasource_v4_g_customer, mappings =  [('id', 'int', 'id', 'int'), ('shipping_address_id', 'int', 'shipping_address_id', 'int'), ('provider_id', 'int', 'provider_id', 'int'), ('mobile_number', 'string', 'mobile_number', 'string'), ('email', 'string', 'email', 'string'), ('addr_validate', 'string', 'addr_validate', 'string'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('status', 'int', 'status', 'int')], transformation_ctx = "applymapping_v4_g_customer")

resolvechoice_v4_g_customer = ResolveChoice.apply(frame = applymapping_v4_g_customer, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_customer")

dropnullfields_v4_g_customer = DropNullFields.apply(frame = resolvechoice_v4_g_customer, transformation_ctx = "dropnullfields_v4_g_customer")

target_table = "v4data_public_v4_g_customer"

stage_table = "test.stage_v4data_public_v4_g_customer"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    shipping_address_id,
    provider_id,
    mobile_number,
    email,
    addr_validate,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    status
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_customer = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_customer, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_customer", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_customer")

job.commit()



######v4_g_customer_payment_gateway######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_customer_payment_gateway = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_customer_payment_gateway", transformation_ctx = "datasource_v4_g_customer_payment_gateway", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_customer_payment_gateway = ApplyMapping.apply(frame = datasource_v4_g_customer_payment_gateway, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('customer_id', 'long', 'customer_id', 'long'), ('payment_gateway_id', 'long', 'payment_gateway_id', 'long'), ('reference_id', 'string', 'reference_id', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_customer_payment_gateway")

resolvechoice_v4_g_customer_payment_gateway = ResolveChoice.apply(frame = applymapping_v4_g_customer_payment_gateway, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_customer_payment_gateway")

dropnullfields_v4_g_customer_payment_gateway = DropNullFields.apply(frame = resolvechoice_v4_g_customer_payment_gateway, transformation_ctx = "dropnullfields_v4_g_customer_payment_gateway")

target_table = "v4data_public_v4_g_customer_payment_gateway"

stage_table = "test.stage_v4data_public_v4_g_customer_payment_gateway"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    customer_id,
    payment_gateway_id,
    reference_id,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_customer_payment_gateway = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_customer_payment_gateway, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_customer_payment_gateway", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_customer_payment_gateway")

job.commit()



######v4_g_discount######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_discount = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_discount", transformation_ctx = "datasource_v4_g_discount", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_discount = ApplyMapping.apply(frame = datasource_v4_g_discount, mappings =  [('id', 'long', 'id', 'long'), ('subscription_id', 'long', 'subscription_id', 'long'), ('percentage_off', 'int', 'percentage_off', 'int'), ('amount_off', 'int', 'amount_off', 'int'), ('name', 'string', 'name', 'string'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string'), ('note', 'string', 'note', 'string')], transformation_ctx = "applymapping_v4_g_discount")

resolvechoice_v4_g_discount = ResolveChoice.apply(frame = applymapping_v4_g_discount, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_discount")

dropnullfields_v4_g_discount = DropNullFields.apply(frame = resolvechoice_v4_g_discount, transformation_ctx = "dropnullfields_v4_g_discount")

target_table = "v4data_public_v4_g_discount"

stage_table = "test.stage_v4data_public_v4_g_discount"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    subscription_id,
    percentage_off,
    amount_off,
    name,
    canceled_at,
    deleted_at,
    status,
    created_at,
    updated_at,
    encrypted_ref_id,
    note
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_discount = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_discount, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_discount", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_discount")

job.commit()



######v4_g_distributor######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_distributor = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_distributor", transformation_ctx = "datasource_v4_g_distributor", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_distributor = ApplyMapping.apply(frame = datasource_v4_g_distributor, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('type', 'string', 'type', 'string'), ('address_id', 'long', 'address_id', 'long'), ('email', 'string', 'email', 'string'), ('phone_number', 'string', 'phone_number', 'string'), ('note', 'string', 'note', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_distributor")

resolvechoice_v4_g_distributor = ResolveChoice.apply(frame = applymapping_v4_g_distributor, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_distributor")

dropnullfields_v4_g_distributor = DropNullFields.apply(frame = resolvechoice_v4_g_distributor, transformation_ctx = "dropnullfields_v4_g_distributor")

target_table = "v4data_public_v4_g_distributor"

stage_table = "test.stage_v4data_public_v4_g_distributor"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    type,
    address_id,
    email,
    phone_number,
    note,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_distributor = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_distributor, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_distributor", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_distributor")

job.commit()



######v4_g_fulfillment######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_fulfillment = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_fulfillment", transformation_ctx = "datasource_v4_g_fulfillment", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_fulfillment = ApplyMapping.apply(frame = datasource_v4_g_fulfillment, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('subscription_id', 'long', 'subscription_id', 'long'), ('quantity_balance', 'string', 'quantity_balance', 'string'), ('quantity_rendered', 'string', 'quantity_rendered', 'string'), ('next_service_date', 'timestamp', 'next_service_date', 'timestamp'), ('service_date', 'timestamp', 'service_date', 'timestamp'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('shipping_address_id', 'long', 'shipping_address_id', 'long'), ('distributor_id', 'long', 'distributor_id', 'long'), ('shipping_id', 'long', 'shipping_id', 'long'), ('shipping_cost', 'int', 'shipping_cost', 'int'), ('type', 'string', 'type', 'string'), ('tracking_id', 'string', 'tracking_id', 'string'), ('order_id', 'string', 'order_id', 'string'), ('note', 'string', 'note', 'string'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_fulfillment")

resolvechoice_v4_g_fulfillment = ResolveChoice.apply(frame = applymapping_v4_g_fulfillment, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_fulfillment")

dropnullfields_v4_g_fulfillment = DropNullFields.apply(frame = resolvechoice_v4_g_fulfillment, transformation_ctx = "dropnullfields_v4_g_fulfillment")

target_table = "v4data_public_v4_g_fulfillment"

stage_table = "test.stage_v4data_public_v4_g_fulfillment"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    canceled_at,
    deleted_at,
    status,
    subscription_id,
    quantity_balance,
    quantity_rendered,
    next_service_date,
    service_date,
    created_at,
    updated_at,
    shipping_address_id,
    distributor_id,
    shipping_id,
    shipping_cost,
    type,
    tracking_id,
    order_id,
    note,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_fulfillment = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_fulfillment, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_fulfillment", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_fulfillment")

job.commit()






######v4_g_funding######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_funding = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_funding", transformation_ctx = "datasource_v4_g_funding", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_funding = ApplyMapping.apply(frame = datasource_v4_g_funding, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('payment_gateway_id', 'long', 'payment_gateway_id', 'long'), ('authorisation_id', 'long', 'authorisation_id', 'long'), ('funding_master_id', 'string', 'funding_master_id', 'string'), ('funding_id', 'string', 'funding_id', 'string'), ('net_sales', 'decimal(38,0)', 'net_sales', 'decimal(38,0)'), ('third_party', 'decimal(38,0)', 'third_party', 'decimal(38,0)'), ('adjustment', 'decimal(38,0)', 'adjustment', 'decimal(38,0)'), ('interchange_fee', 'decimal(38,0)', 'interchange_fee', 'decimal(38,0)'), ('service_charge', 'decimal(38,0)', 'service_charge', 'decimal(38,0)'), ('fee', 'decimal(38,0)', 'fee', 'decimal(38,0)'), ('reversal', 'decimal(38,0)', 'reversal', 'decimal(38,0)'), ('other_adjustment', 'decimal(38,0)', 'other_adjustment', 'decimal(38,0)'), ('total_funding', 'decimal(38,0)', 'total_funding', 'decimal(38,0)'), ('funding_date', 'timestamp', 'funding_date', 'timestamp'), ('currency', 'string', 'currency', 'string'), ('dda_number', 'string', 'dda_number', 'string'), ('aba_number', 'string', 'aba_number', 'string'), ('date_changed', 'timestamp', 'date_changed', 'timestamp'), ('date_added', 'timestamp', 'date_added', 'timestamp'), ('deposit_trancode', 'string', 'deposit_trancode', 'string'), ('deposit_ach_tracenumber', 'string', 'deposit_ach_tracenumber', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_funding")

resolvechoice_v4_g_funding = ResolveChoice.apply(frame = applymapping_v4_g_funding, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_funding")

dropnullfields_v4_g_funding = DropNullFields.apply(frame = resolvechoice_v4_g_funding, transformation_ctx = "dropnullfields_v4_g_funding")

target_table = "v4data_public_v4_g_funding"

stage_table = "test.stage_v4data_public_v4_g_funding"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    payment_gateway_id,
    authorisation_id,
    funding_master_id,
    funding_id,
    net_sales,
    third_party,
    adjustment,
    interchange_fee,
    service_charge,
    fee,
    reversal,
    other_adjustment,
    total_funding,
    funding_date,
    currency,
    dda_number,
    aba_number,
    date_changed,
    date_added,
    deposit_trancode,
    deposit_ach_tracenumber,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_funding = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_funding, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_funding", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_funding")

job.commit()






######v4_g_invoice######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_invoice = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_invoice", transformation_ctx = "datasource_v4_g_invoice", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_invoice = ApplyMapping.apply(frame = datasource_v4_g_invoice, mappings =  [('id', 'long', 'id', 'long'), ('plan_id', 'long', 'plan_id', 'long'), ('quantity', 'int', 'quantity', 'int'), ('amount', 'int', 'amount', 'int'), ('due_date', 'timestamp', 'due_date', 'timestamp'), ('pay_date', 'timestamp', 'pay_date', 'timestamp'), ('application_fee', 'int', 'application_fee', 'int'), ('attempts', 'short', 'attempts', 'short'), ('amount_paid', 'int', 'amount_paid', 'int'), ('charge_id', 'string', 'charge_id', 'string'), ('total_credit', 'int', 'total_credit', 'int'), ('total_discount', 'int', 'total_discount', 'int'), ('total_coupon', 'int', 'total_coupon', 'int'), ('total_payment', 'int', 'total_payment', 'int'), ('currency', 'string', 'currency', 'string'), ('total_tax', 'int', 'total_tax', 'int'), ('tax_percentage', 'int', 'tax_percentage', 'int'), ('subtotal', 'int', 'subtotal', 'int'), ('total', 'int', 'total', 'int'), ('starting_balance', 'int', 'starting_balance', 'int'), ('ending_balance', 'int', 'ending_balance', 'int'), ('name', 'string', 'name', 'string'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_invoice")

resolvechoice_v4_g_invoice = ResolveChoice.apply(frame = applymapping_v4_g_invoice, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_invoice")

dropnullfields_v4_g_invoice = DropNullFields.apply(frame = resolvechoice_v4_g_invoice, transformation_ctx = "dropnullfields_v4_g_invoice")

target_table = "v4data_public_v4_g_invoice"

stage_table = "test.stage_v4data_public_v4_g_invoice"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    plan_id,
    quantity,
    amount,
    due_date,
    pay_date,
    application_fee,
    attempts,
    amount_paid,
    charge_id,
    total_credit,
    total_discount,
    total_coupon,
    total_payment,
    currency,
    total_tax,
    tax_percentage,
    subtotal,
    total,
    starting_balance,
    ending_balance,
    name,
    canceled_at,
    deleted_at,
    status,
    created_at,
    updated_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_invoice = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_invoice, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_invoice", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_invoice")

job.commit()



######v4_g_invoice_item######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_invoice_item = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_invoice_item", transformation_ctx = "datasource_v4_g_invoice_item", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_invoice_item = ApplyMapping.apply(frame = datasource_v4_g_invoice_item, mappings =  [('id', 'long', 'id', 'long'), ('subscription_id', 'long', 'subscription_id', 'long'), ('invoice_id', 'long', 'invoice_id', 'long'), ('charge_id', 'string', 'charge_id', 'string'), ('price', 'int', 'price', 'int'), ('quantity', 'int', 'quantity', 'int'), ('amount', 'int', 'amount', 'int'), ('discounts', 'int', 'discounts', 'int'), ('coupons', 'int', 'coupons', 'int'), ('credits', 'int', 'credits', 'int'), ('payments', 'int', 'payments', 'int'), ('currency', 'string', 'currency', 'string'), ('tax', 'int', 'tax', 'int'), ('tax_percentage', 'int', 'tax_percentage', 'int'), ('subtotal', 'int', 'subtotal', 'int'), ('total', 'int', 'total', 'int'), ('balance', 'int', 'balance', 'int'), ('name', 'string', 'name', 'string'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string'), ('card_brand', 'string', 'card_brand', 'string')], transformation_ctx = "applymapping_v4_g_invoice_item")

resolvechoice_v4_g_invoice_item = ResolveChoice.apply(frame = applymapping_v4_g_invoice_item, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_invoice_item")

dropnullfields_v4_g_invoice_item = DropNullFields.apply(frame = resolvechoice_v4_g_invoice_item, transformation_ctx = "dropnullfields_v4_g_invoice_item")

target_table = "v4data_public_v4_g_invoice_item"

stage_table = "test.stage_v4data_public_v4_g_invoice_item"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    subscription_id,
    invoice_id,
    charge_id,
    price,
    quantity,
    amount,
    discounts,
    coupons,
    credits,
    payments,
    currency,
    tax,
    tax_percentage,
    subtotal,
    total,
    balance,
    name,
    canceled_at,
    deleted_at,
    status,
    created_at,
    updated_at,
    encrypted_ref_id,
    card_brand
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_invoice_item = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_invoice_item, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_invoice_item", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_invoice_item")

job.commit()



######v4_g_payment######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_payment = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_payment", transformation_ctx = "datasource_v4_g_payment", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_payment = ApplyMapping.apply(frame = datasource_v4_g_payment, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('plan_id', 'long', 'plan_id', 'long'), ('subscription_id', 'long', 'subscription_id', 'long'), ('payment_gateway_id', 'long', 'payment_gateway_id', 'long'), ('transferred_from_payment_id', 'long', 'transferred_from_payment_id', 'long'), ('external_id', 'string', 'external_id', 'string'), ('transaction_id', 'string', 'transaction_id', 'string'), ('amount', 'int', 'amount', 'int'), ('balance', 'int', 'balance', 'int'), ('type', 'string', 'type', 'string'), ('bank_name', 'string', 'bank_name', 'string'), ('account_number', 'string', 'account_number', 'string'), ('routing_number', 'string', 'routing_number', 'string'), ('reason', 'string', 'reason', 'string'), ('currency', 'string', 'currency', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string'), ('created_by', 'string', 'created_by', 'string'), ('updated_by', 'string', 'updated_by', 'string'), ('device_id', 'string', 'device_id', 'string'), ('gratuity_id', 'long', 'gratuity_id', 'long'), ('card_brand', 'string', 'card_brand', 'string')], transformation_ctx = "applymapping_v4_g_payment")

resolvechoice_v4_g_payment = ResolveChoice.apply(frame = applymapping_v4_g_payment, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_payment")

dropnullfields_v4_g_payment = DropNullFields.apply(frame = resolvechoice_v4_g_payment, transformation_ctx = "dropnullfields_v4_g_payment")

target_table = "v4data_public_v4_g_payment"

stage_table = "test.stage_v4data_public_v4_g_payment"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    plan_id,
    subscription_id,
    payment_gateway_id,
    transferred_from_payment_id,
    external_id,
    transaction_id,
    amount,
    balance,
    type,
    bank_name,
    account_number,
    routing_number,
    reason,
    currency,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id,
    created_by,
    updated_by,
    device_id,
    gratuity_id,
    card_brand
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_payment = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_payment, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_payment", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_payment")

job.commit()



######v4_g_payment_gateway######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_payment_gateway = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_payment_gateway", transformation_ctx = "datasource_v4_g_payment_gateway", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_payment_gateway = ApplyMapping.apply(frame = datasource_v4_g_payment_gateway, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('business_id', 'string', 'business_id', 'string'), ('end_point', 'string', 'end_point', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_payment_gateway")

resolvechoice_v4_g_payment_gateway = ResolveChoice.apply(frame = applymapping_v4_g_payment_gateway, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_payment_gateway")

dropnullfields_v4_g_payment_gateway = DropNullFields.apply(frame = resolvechoice_v4_g_payment_gateway, transformation_ctx = "dropnullfields_v4_g_payment_gateway")

target_table = "v4data_public_v4_g_payment_gateway"

stage_table = "test.stage_v4data_public_v4_g_payment_gateway"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    business_id,
    end_point,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_payment_gateway = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_payment_gateway, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_payment_gateway", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_payment_gateway")

job.commit()



######v4_g_payment_plan######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_payment_plan = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_payment_plan", transformation_ctx = "datasource_v4_g_payment_plan", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_payment_plan = ApplyMapping.apply(frame = datasource_v4_g_payment_plan, mappings =  [('id', 'long', 'id', 'long'), ('provider_id', 'long', 'provider_id', 'long'), ('name', 'string', 'name', 'string'), ('payment_gateway_id', 'long', 'payment_gateway_id', 'long'), ('payment_count', 'int', 'payment_count', 'int'), ('payment_type', 'string', 'payment_type', 'string'), ('expiration', 'timestamp', 'expiration', 'timestamp'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_payment_plan")

resolvechoice_v4_g_payment_plan = ResolveChoice.apply(frame = applymapping_v4_g_payment_plan, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_payment_plan")

dropnullfields_v4_g_payment_plan = DropNullFields.apply(frame = resolvechoice_v4_g_payment_plan, transformation_ctx = "dropnullfields_v4_g_payment_plan")

target_table = "v4data_public_v4_g_payment_plan"

stage_table = "test.stage_v4data_public_v4_g_payment_plan"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    provider_id,
    name,
    payment_gateway_id,
    payment_count,
    payment_type,
    expiration,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_payment_plan = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_payment_plan, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_payment_plan", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_payment_plan")

job.commit()



######v4_g_plan######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_plan = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_plan", transformation_ctx = "datasource_v4_g_plan", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_plan = ApplyMapping.apply(frame = datasource_v4_g_plan, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('status', 'short', 'status', 'short'), ('customer_id', 'long', 'customer_id', 'long'), ('billing_plan_id', 'long', 'billing_plan_id', 'long'), ('billing_date', 'timestamp', 'billing_date', 'timestamp'), ('next_billing_date', 'timestamp', 'next_billing_date', 'timestamp'), ('quantity', 'int', 'quantity', 'int'), ('application_fee', 'int', 'application_fee', 'int'), ('total_coupon', 'int', 'total_coupon', 'int'), ('total_credit', 'int', 'total_credit', 'int'), ('total_discount', 'int', 'total_discount', 'int'), ('total_payment', 'int', 'total_payment', 'int'), ('total_tax', 'int', 'total_tax', 'int'), ('tax_percentage', 'int', 'tax_percentage', 'int'), ('subtotal', 'int', 'subtotal', 'int'), ('total', 'int', 'total', 'int'), ('starting_balance', 'int', 'starting_balance', 'int'), ('ending_balance', 'int', 'ending_balance', 'int'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_plan")

resolvechoice_v4_g_plan = ResolveChoice.apply(frame = applymapping_v4_g_plan, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_plan")

dropnullfields_v4_g_plan = DropNullFields.apply(frame = resolvechoice_v4_g_plan, transformation_ctx = "dropnullfields_v4_g_plan")

target_table = "v4data_public_v4_g_plan"

stage_table = "test.stage_v4data_public_v4_g_plan"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    canceled_at,
    deleted_at,
    status,
    customer_id,
    billing_plan_id,
    billing_date,
    next_billing_date,
    quantity,
    application_fee,
    total_coupon,
    total_credit,
    total_discount,
    total_payment,
    total_tax,
    tax_percentage,
    subtotal,
    total,
    starting_balance,
    ending_balance,
    created_at,
    updated_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_plan = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_plan, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_plan", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_plan")

job.commit()





######v4_g_price######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_price = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_price", transformation_ctx = "datasource_v4_g_price", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_price = ApplyMapping.apply(frame = datasource_v4_g_price, mappings =  [('id', 'long', 'id', 'long'), ('product_id', 'long', 'product_id', 'long'), ('name', 'string', 'name', 'string'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('status', 'short', 'status', 'short'), ('msrp', 'int', 'msrp', 'int'), ('price', 'int', 'price', 'int'), ('currency', 'string', 'currency', 'string'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('cost', 'int', 'cost', 'int'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_price")

resolvechoice_v4_g_price = ResolveChoice.apply(frame = applymapping_v4_g_price, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_price")

dropnullfields_v4_g_price = DropNullFields.apply(frame = resolvechoice_v4_g_price, transformation_ctx = "dropnullfields_v4_g_price")

target_table = "v4data_public_v4_g_price"

stage_table = "test.stage_v4data_public_v4_g_price"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    product_id,
    name,
    canceled_at,
    deleted_at,
    status,
    msrp,
    price,
    currency,
    created_at,
    updated_at,
    cost,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_price = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_price, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_price", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_price")

job.commit()



######v4_g_product######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_product = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_product", transformation_ctx = "datasource_v4_g_product", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_product = ApplyMapping.apply(frame = datasource_v4_g_product, mappings =  [('id', 'long', 'id', 'long'), ('provider_id', 'long', 'provider_id', 'long'), ('name', 'string', 'name', 'string'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('status', 'short', 'status', 'short'), ('description', 'string', 'description', 'string'), ('unit_name', 'string', 'unit_name', 'string'), ('type', 'string', 'type', 'string'), ('start_date', 'timestamp', 'start_date', 'timestamp'), ('end_date', 'timestamp', 'end_date', 'timestamp'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('manufacturer', 'string', 'manufacturer', 'string'), ('sku', 'string', 'sku', 'string'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_product")

resolvechoice_v4_g_product = ResolveChoice.apply(frame = applymapping_v4_g_product, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_product")

dropnullfields_v4_g_product = DropNullFields.apply(frame = resolvechoice_v4_g_product, transformation_ctx = "dropnullfields_v4_g_product")

target_table = "v4data_public_v4_g_product"

stage_table = "test.stage_v4data_public_v4_g_product"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    provider_id,
    name,
    canceled_at,
    deleted_at,
    status,
    description,
    unit_name,
    type,
    start_date,
    end_date,
    created_at,
    updated_at,
    manufacturer,
    sku,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_product = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_product, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_product", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_product")

job.commit()



######v4_g_provider######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_provider = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_provider", transformation_ctx = "datasource_v4_g_provider", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_provider = ApplyMapping.apply(frame = datasource_v4_g_provider, mappings =  [('id', 'long', 'id', 'long'), ('account_id', 'long', 'account_id', 'long'), ('name', 'string', 'name', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_provider")

resolvechoice_v4_g_provider = ResolveChoice.apply(frame = applymapping_v4_g_provider, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_provider")

dropnullfields_v4_g_provider = DropNullFields.apply(frame = resolvechoice_v4_g_provider, transformation_ctx = "dropnullfields_v4_g_provider")

target_table = "v4data_public_v4_g_provider"

stage_table = "test.stage_v4data_public_v4_g_provider"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    account_id,
    name,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_provider = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_provider, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_provider", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_provider")

job.commit()



######v4_g_refund######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_refund = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_refund", transformation_ctx = "datasource_v4_g_refund", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_refund = ApplyMapping.apply(frame = datasource_v4_g_refund, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('subscription_id', 'long', 'subscription_id', 'long'), ('invoice_item_id', 'long', 'invoice_item_id', 'long'), ('gateway_transaction_id', 'long', 'gateway_transaction_id', 'long'), ('receipt_id', 'string', 'receipt_id', 'string'), ('amount', 'int', 'amount', 'int'), ('balance', 'int', 'balance', 'int'), ('type', 'string', 'type', 'string'), ('reason', 'string', 'reason', 'string'), ('currency', 'string', 'currency', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('external_ref_id', 'string', 'external_ref_id', 'string'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string'), ('created_by', 'string', 'created_by', 'string'), ('updated_by', 'string', 'updated_by', 'string'), ('is_void', 'boolean', 'is_void', 'boolean'), ('gratuity_id', 'long', 'gratuity_id', 'long'), ('card_brand', 'string', 'card_brand', 'string')], transformation_ctx = "applymapping_v4_g_refund")

resolvechoice_v4_g_refund = ResolveChoice.apply(frame = applymapping_v4_g_refund, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_refund")

dropnullfields_v4_g_refund = DropNullFields.apply(frame = resolvechoice_v4_g_refund, transformation_ctx = "dropnullfields_v4_g_refund")

target_table = "v4data_public_v4_g_refund"

stage_table = "test.stage_v4data_public_v4_g_refund"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    subscription_id,
    invoice_item_id,
    gateway_transaction_id,
    receipt_id,
    amount,
    balance,
    type,
    reason,
    currency,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    external_ref_id,
    encrypted_ref_id,
    created_by,
    updated_by,
    is_void,
    gratuity_id,
    card_brand
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_refund = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_refund, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_refund", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_refund")

job.commit()



######v4_g_settlement######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_settlement = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_settlement", transformation_ctx = "datasource_v4_g_settlement", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_settlement = ApplyMapping.apply(frame = datasource_v4_g_settlement, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('authorisation_id', 'long', 'authorisation_id', 'long'), ('gateway_transaction_id', 'long', 'gateway_transaction_id', 'long'), ('external_id', 'string', 'external_id', 'string'), ('transaction_id', 'string', 'transaction_id', 'string'), ('payment_gateway_id', 'long', 'payment_gateway_id', 'long'), ('amount', 'decimal(38,0)', 'amount', 'decimal(38,0)'), ('tendered', 'decimal(38,0)', 'tendered', 'decimal(38,0)'), ('type', 'string', 'type', 'string'), ('reason', 'string', 'reason', 'string'), ('currency', 'string', 'currency', 'string'), ('account', 'string', 'account', 'string'), ('batch_id', 'string', 'batch_id', 'string'), ('settlement_status', 'string', 'settlement_status', 'string'), ('settlement_date', 'timestamp', 'settlement_date', 'timestamp'), ('signature', 'string', 'signature', 'string'), ('token', 'string', 'token', 'string'), ('entry_mode', 'string', 'entry_mode', 'string'), ('authd_date', 'timestamp', 'authd_date', 'timestamp'), ('last_four', 'string', 'last_four', 'string'), ('bin_type', 'string', 'bin_type', 'string'), ('card_brand', 'string', 'card_brand', 'string'), ('funding_txn_id', 'string', 'funding_txn_id', 'string'), ('funding_id', 'string', 'funding_id', 'string'), ('interchange_unit_fee', 'decimal(38,0)', 'interchange_unit_fee', 'decimal(38,0)'), ('interchange_percentage_fee', 'decimal(38,0)', 'interchange_percentage_fee', 'decimal(38,0)'), ('plan_code', 'string', 'plan_code', 'string'), ('downgrade_reason_codes', 'string', 'downgrade_reason_codes', 'string'), ('invoice_number', 'string', 'invoice_number', 'string'), ('source_transaction_id', 'string', 'source_transaction_id', 'string'), ('terminal_number', 'string', 'terminal_number', 'string'), ('ach_return_code', 'string', 'ach_return_code', 'string'), ('parent_retref', 'string', 'parent_retref', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_settlement")

resolvechoice_v4_g_settlement = ResolveChoice.apply(frame = applymapping_v4_g_settlement, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_settlement")

dropnullfields_v4_g_settlement = DropNullFields.apply(frame = resolvechoice_v4_g_settlement, transformation_ctx = "dropnullfields_v4_g_settlement")

target_table = "v4data_public_v4_g_settlement"

stage_table = "test.stage_v4data_public_v4_g_settlement"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    authorisation_id,
    gateway_transaction_id,
    external_id,
    transaction_id,
    payment_gateway_id,
    amount,
    tendered,
    type,
    reason,
    currency,
    account,
    batch_id,
    settlement_status,
    settlement_date,
    signature,
    token,
    entry_mode,
    authd_date,
    last_four,
    bin_type,
    card_brand,
    funding_txn_id,
    funding_id,
    interchange_unit_fee,
    interchange_percentage_fee,
    plan_code,
    downgrade_reason_codes,
    invoice_number,
    source_transaction_id,
    terminal_number,
    ach_return_code,
    parent_retref,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_settlement = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_settlement, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_settlement", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_settlement")

job.commit()



######v4_g_shipping######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_shipping = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_shipping", transformation_ctx = "datasource_v4_g_shipping", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_shipping = ApplyMapping.apply(frame = datasource_v4_g_shipping, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('type', 'string', 'type', 'string'), ('tracking_url', 'string', 'tracking_url', 'string'), ('account_id', 'string', 'account_id', 'string'), ('options', 'int', 'options', 'int'), ('note', 'string', 'note', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_shipping")

resolvechoice_v4_g_shipping = ResolveChoice.apply(frame = applymapping_v4_g_shipping, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_shipping")

dropnullfields_v4_g_shipping = DropNullFields.apply(frame = resolvechoice_v4_g_shipping, transformation_ctx = "dropnullfields_v4_g_shipping")

target_table = "v4data_public_v4_g_shipping"

stage_table = "test.stage_v4data_public_v4_g_shipping"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    type,
    tracking_url,
    account_id,
    options,
    note,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_shipping = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_shipping, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_shipping", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_shipping")

job.commit()



######v4_g_subscription######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_subscription = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_subscription", transformation_ctx = "datasource_v4_g_subscription", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_subscription = ApplyMapping.apply(frame = datasource_v4_g_subscription, mappings =  [('id', 'long', 'id', 'long'), ('plan_id', 'long', 'plan_id', 'long'), ('payment_plan_id', 'long', 'payment_plan_id', 'long'), ('fulfillment_plan_id', 'long', 'fulfillment_plan_id', 'long'), ('product_id', 'long', 'product_id', 'long'), ('quantity', 'int', 'quantity', 'int'), ('unit_name', 'string', 'unit_name', 'string'), ('remaining_payment', 'int', 'remaining_payment', 'int'), ('balance', 'int', 'balance', 'int'), ('price', 'int', 'price', 'int'), ('discount_amts', 'int', 'discount_amts', 'int'), ('discount_percentages', 'int', 'discount_percentages', 'int'), ('coupons', 'int', 'coupons', 'int'), ('credits', 'int', 'credits', 'int'), ('payments', 'int', 'payments', 'int'), ('total_installment', 'int', 'total_installment', 'int'), ('tax', 'int', 'tax', 'int'), ('tax_percentage', 'int', 'tax_percentage', 'int'), ('subtotal', 'int', 'subtotal', 'int'), ('total', 'int', 'total', 'int'), ('start_date', 'timestamp', 'start_date', 'timestamp'), ('end_date', 'timestamp', 'end_date', 'timestamp'), ('end_count', 'int', 'end_count', 'int'), ('end_unit', 'string', 'end_unit', 'string'), ('proration', 'boolean', 'proration', 'boolean'), ('auto_renewal', 'boolean', 'auto_renewal', 'boolean'), ('renewal_count', 'int', 'renewal_count', 'int'), ('name', 'string', 'name', 'string'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_subscription")

resolvechoice_v4_g_subscription = ResolveChoice.apply(frame = applymapping_v4_g_subscription, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_subscription")

dropnullfields_v4_g_subscription = DropNullFields.apply(frame = resolvechoice_v4_g_subscription, transformation_ctx = "dropnullfields_v4_g_subscription")

target_table = "v4data_public_v4_g_subscription"

stage_table = "test.stage_v4data_public_v4_g_subscription"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    plan_id,
    payment_plan_id,
    fulfillment_plan_id,
    product_id,
    quantity,
    unit_name,
    remaining_payment,
    balance,
    price,
    discount_amts,
    discount_percentages,
    coupons,
    credits,
    payments,
    total_installment,
    tax,
    tax_percentage,
    subtotal,
    total,
    start_date,
    end_date,
    end_count,
    end_unit,
    proration,
    auto_renewal,
    renewal_count,
    name,
    canceled_at,
    deleted_at,
    status,
    created_at,
    updated_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_subscription = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_subscription, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_subscription", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_subscription")

job.commit()



######v4_g_subscription_notification_plan######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_subscription_notification_plan = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_subscription_notification_plan", transformation_ctx = "datasource_v4_g_subscription_notification_plan", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_subscription_notification_plan = ApplyMapping.apply(frame = datasource_v4_g_subscription_notification_plan, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('subscription_id', 'long', 'subscription_id', 'long'), ('notification_plan_id', 'long', 'notification_plan_id', 'long'), ('reference_id', 'string', 'reference_id', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_subscription_notification_plan")

resolvechoice_v4_g_subscription_notification_plan = ResolveChoice.apply(frame = applymapping_v4_g_subscription_notification_plan, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_subscription_notification_plan")

dropnullfields_v4_g_subscription_notification_plan = DropNullFields.apply(frame = resolvechoice_v4_g_subscription_notification_plan, transformation_ctx = "dropnullfields_v4_g_subscription_notification_plan")

target_table = "v4data_public_v4_g_subscription_notification_plan"

stage_table = "test.stage_v4data_public_v4_g_subscription_notification_plan"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    subscription_id,
    notification_plan_id,
    reference_id,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_subscription_notification_plan = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_subscription_notification_plan, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_subscription_notification_plan", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_subscription_notification_plan")

job.commit()



######v4_g_userfield######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_g_userfield = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_userfield", transformation_ctx = "datasource_v4_g_userfield", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_g_userfield = ApplyMapping.apply(frame = datasource_v4_g_userfield, mappings =  [('id', 'long', 'id', 'long'), ('name', 'string', 'name', 'string'), ('object_name', 'string', 'object_name', 'string'), ('object_id', 'string', 'object_id', 'string'), ('data', 'string', 'data', 'string'), ('status', 'short', 'status', 'short'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('canceled_at', 'timestamp', 'canceled_at', 'timestamp'), ('deleted_at', 'timestamp', 'deleted_at', 'timestamp'), ('encrypted_ref_id', 'string', 'encrypted_ref_id', 'string')], transformation_ctx = "applymapping_v4_g_userfield")

resolvechoice_v4_g_userfield = ResolveChoice.apply(frame = applymapping_v4_g_userfield, choice = "make_cols", transformation_ctx = "resolvechoice_v4_g_userfield")

dropnullfields_v4_g_userfield = DropNullFields.apply(frame = resolvechoice_v4_g_userfield, transformation_ctx = "dropnullfields_v4_g_userfield")

target_table = "v4data_public_v4_g_userfield"

stage_table = "test.stage_v4data_public_v4_g_userfield"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    name,
    object_name,
    object_id,
    data,
    status,
    created_at,
    updated_at,
    canceled_at,
    deleted_at,
    encrypted_ref_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_g_userfield = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_g_userfield, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_g_userfield", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_g_userfield")

job.commit()



######v4_k_address######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_address = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_address", transformation_ctx = "datasource_v4_k_address", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_address = ApplyMapping.apply(frame = datasource_v4_k_address, mappings =  [('id', 'long', 'id', 'long'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('street1', 'string', 'street1', 'string'), ('street2', 'string', 'street2', 'string'), ('city', 'string', 'city', 'string'), ('state', 'string', 'state', 'string'), ('zip', 'string', 'zip', 'string'), ('country', 'string', 'country', 'string'), ('longitude', 'string', 'longitude', 'string'), ('latitude', 'string', 'latitude', 'string'), ('type', 'int', 'type', 'int')], transformation_ctx = "applymapping_v4_k_address")

resolvechoice_v4_k_address = ResolveChoice.apply(frame = applymapping_v4_k_address, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_address")

dropnullfields_v4_k_address = DropNullFields.apply(frame = resolvechoice_v4_k_address, transformation_ctx = "dropnullfields_v4_k_address")

target_table = "v4data_public_v4_k_address"

stage_table = "test.stage_v4data_public_v4_k_address"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    street1,
    street2,
    city,
    state,
    zip,
    country,
    longitude,
    latitude,
    type
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_address = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_address, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_address", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_address")

job.commit()



######v4_k_brand######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_brand = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_brand", transformation_ctx = "datasource_v4_k_brand", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_brand = ApplyMapping.apply(frame = datasource_v4_k_brand, mappings =  [('id', 'long', 'id', 'long'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('name', 'string', 'name', 'string'), ('thumbnail', 'string', 'thumbnail', 'string'), ('status', 'int', 'status', 'int')], transformation_ctx = "applymapping_v4_k_brand")

resolvechoice_v4_k_brand = ResolveChoice.apply(frame = applymapping_v4_k_brand, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_brand")

dropnullfields_v4_k_brand = DropNullFields.apply(frame = resolvechoice_v4_k_brand, transformation_ctx = "dropnullfields_v4_k_brand")

target_table = "v4data_public_v4_k_brand"

stage_table = "test.stage_v4data_public_v4_k_brand"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    name,
    thumbnail,
    status
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_brand = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_brand, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_brand", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_brand")

job.commit()



######v4_k_brand_account_data######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_brand_account_data = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_brand_account_data", transformation_ctx = "datasource_v4_k_brand_account_data", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_brand_account_data = ApplyMapping.apply(frame = datasource_v4_k_brand_account_data, mappings =  [('id', 'long', 'id', 'long'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('organization_id', 'long', 'organization_id', 'long'), ('brand_id', 'long', 'brand_id', 'long'), ('account_number', 'string', 'account_number', 'string'), ('status', 'int', 'status', 'int')], transformation_ctx = "applymapping_v4_k_brand_account_data")

resolvechoice_v4_k_brand_account_data = ResolveChoice.apply(frame = applymapping_v4_k_brand_account_data, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_brand_account_data")

dropnullfields_v4_k_brand_account_data = DropNullFields.apply(frame = resolvechoice_v4_k_brand_account_data, transformation_ctx = "dropnullfields_v4_k_brand_account_data")

target_table = "v4data_public_v4_k_brand_account_data"

stage_table = "test.stage_v4data_public_v4_k_brand_account_data"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    organization_id,
    brand_id,
    account_number,
    status
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_brand_account_data = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_brand_account_data, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_brand_account_data", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_brand_account_data")

job.commit()



######v4_k_catalog_item######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_catalog_item = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_catalog_item", transformation_ctx = "datasource_v4_k_catalog_item", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_catalog_item = ApplyMapping.apply(frame = datasource_v4_k_catalog_item, mappings =  [('id', 'long', 'id', 'long'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('name', 'string', 'name', 'string'), ('thumbnail', 'string', 'thumbnail', 'string'), ('type', 'int', 'type', 'int'), ('unit_type', 'int', 'unit_type', 'int'), ('unit_range_top', 'int', 'unit_range_top', 'int'), ('unit_range_bottom', 'int', 'unit_range_bottom', 'int'), ('brand_id', 'long', 'brand_id', 'long'), ('sku', 'string', 'sku', 'string'), ('wholesale_price', 'long', 'wholesale_price', 'long'), ('period', 'int', 'period', 'int'), ('period_unit', 'int', 'period_unit', 'int'), ('description', 'string', 'description', 'string'), ('instructions', 'string', 'instructions', 'string'), ('ingredients', 'string', 'ingredients', 'string'), ('bd_status', 'int', 'bd_status', 'int')], transformation_ctx = "applymapping_v4_k_catalog_item")

resolvechoice_v4_k_catalog_item = ResolveChoice.apply(frame = applymapping_v4_k_catalog_item, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_catalog_item")

dropnullfields_v4_k_catalog_item = DropNullFields.apply(frame = resolvechoice_v4_k_catalog_item, transformation_ctx = "dropnullfields_v4_k_catalog_item")

target_table = "v4data_public_v4_k_catalog_item"

stage_table = "test.stage_v4data_public_v4_k_catalog_item"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    name,
    thumbnail,
    type,
    unit_type,
    unit_range_top,
    unit_range_bottom,
    brand_id,
    sku,
    wholesale_price,
    period,
    period_unit,
    description,
    instructions,
    ingredients,
    bd_status
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_catalog_item = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_catalog_item, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_catalog_item", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_catalog_item")

job.commit()



######v4_k_credit######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_credit = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_credit", transformation_ctx = "datasource_v4_k_credit", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_credit = ApplyMapping.apply(frame = datasource_v4_k_credit, mappings =  [('id', 'long', 'id', 'long'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('reward_id', 'long', 'reward_id', 'long'), ('plan_id', 'long', 'plan_id', 'long'), ('gx_credit_id', 'string', 'gx_credit_id', 'string'), ('balance', 'int', 'balance', 'int')], transformation_ctx = "applymapping_v4_k_credit")

resolvechoice_v4_k_credit = ResolveChoice.apply(frame = applymapping_v4_k_credit, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_credit")

dropnullfields_v4_k_credit = DropNullFields.apply(frame = resolvechoice_v4_k_credit, transformation_ctx = "dropnullfields_v4_k_credit")

target_table = "v4data_public_v4_k_credit"

stage_table = "test.stage_v4data_public_v4_k_credit"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    reward_id,
    plan_id,
    gx_credit_id,
    balance
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_credit = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_credit, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_credit", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_credit")

job.commit()



######v4_k_curator_data######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_curator_data = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_curator_data", transformation_ctx = "datasource_v4_k_curator_data", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_curator_data = ApplyMapping.apply(frame = datasource_v4_k_curator_data, mappings =  [('id', 'int', 'id', 'int'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('user_id', 'long', 'user_id', 'long'), ('title', 'string', 'title', 'string'), ('firstname', 'string', 'firstname', 'string'), ('lastname', 'string', 'lastname', 'string'), ('role', 'int', 'role', 'int'), ('email', 'string', 'email', 'string'), ('mobile', 'string', 'mobile', 'string'), ('organization_id', 'int', 'organization_id', 'int')], transformation_ctx = "applymapping_v4_k_curator_data")

resolvechoice_v4_k_curator_data = ResolveChoice.apply(frame = applymapping_v4_k_curator_data, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_curator_data")

dropnullfields_v4_k_curator_data = DropNullFields.apply(frame = resolvechoice_v4_k_curator_data, transformation_ctx = "dropnullfields_v4_k_curator_data")

target_table = "v4data_public_v4_k_curator_data"

stage_table = "test.stage_v4data_public_v4_k_curator_data"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    user_id,
    title,
    firstname,
    lastname,
    role,
    email,
    mobile,
    organization_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_curator_data = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_curator_data, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_curator_data", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_curator_data")

job.commit()



######v4_k_customer_data######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_customer_data = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_customer_data", transformation_ctx = "datasource_v4_k_customer_data", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_customer_data = ApplyMapping.apply(frame = datasource_v4_k_customer_data, mappings =  [('id', 'int', 'id', 'int'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('user_id', 'long', 'user_id', 'long'), ('gender', 'int', 'gender', 'int'), ('birth_year', 'int', 'birth_year', 'int'), ('gx_customer_id', 'string', 'gx_customer_id', 'string'), ('title', 'string', 'title', 'string'), ('firstname', 'string', 'firstname', 'string'), ('lastname', 'string', 'lastname', 'string'), ('role', 'int', 'role', 'int'), ('email', 'string', 'email', 'string'), ('mobile', 'string', 'mobile', 'string'), ('organization_id', 'int', 'organization_id', 'int')], transformation_ctx = "applymapping_v4_k_customer_data")

resolvechoice_v4_k_customer_data = ResolveChoice.apply(frame = applymapping_v4_k_customer_data, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_customer_data")

dropnullfields_v4_k_customer_data = DropNullFields.apply(frame = resolvechoice_v4_k_customer_data, transformation_ctx = "dropnullfields_v4_k_customer_data")

target_table = "v4data_public_v4_k_customer_data"

stage_table = "test.stage_v4data_public_v4_k_customer_data"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    user_id,
    gender,
    birth_year,
    gx_customer_id,
    title,
    firstname,
    lastname,
    role,
    email,
    mobile,
    organization_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_customer_data = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_customer_data, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_customer_data", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_customer_data")

job.commit()



######v4_k_customer_note######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_customer_note = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_customer_note", transformation_ctx = "datasource_v4_k_customer_note", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_customer_note = ApplyMapping.apply(frame = datasource_v4_k_customer_note, mappings =  [('id', 'long', 'id', 'long'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('date', 'timestamp', 'date', 'timestamp'), ('customer_id', 'long', 'customer_id', 'long'), ('author_id', 'long', 'author_id', 'long'), ('subject', 'string', 'subject', 'string'), ('note', 'string', 'note', 'string')], transformation_ctx = "applymapping_v4_k_customer_note")

resolvechoice_v4_k_customer_note = ResolveChoice.apply(frame = applymapping_v4_k_customer_note, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_customer_note")

dropnullfields_v4_k_customer_note = DropNullFields.apply(frame = resolvechoice_v4_k_customer_note, transformation_ctx = "dropnullfields_v4_k_customer_note")

target_table = "v4data_public_v4_k_customer_note"

stage_table = "test.stage_v4data_public_v4_k_customer_note"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    date,
    customer_id,
    author_id,
    subject,
    note
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_customer_note = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_customer_note, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_customer_note", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_customer_note")

job.commit()



######v4_k_expert_data######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_expert_data = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_expert_data", transformation_ctx = "datasource_v4_k_expert_data", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_expert_data = ApplyMapping.apply(frame = datasource_v4_k_expert_data, mappings =  [('id', 'int', 'id', 'int'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('user_id', 'long', 'user_id', 'long'), ('license', 'string', 'license', 'string'), ('principal', 'boolean', 'principal', 'boolean'), ('title', 'string', 'title', 'string'), ('firstname', 'string', 'firstname', 'string'), ('lastname', 'string', 'lastname', 'string'), ('role', 'int', 'role', 'int'), ('email', 'string', 'email', 'string'), ('mobile', 'string', 'mobile', 'string'), ('organization_id', 'int', 'organization_id', 'int')], transformation_ctx = "applymapping_v4_k_expert_data")

resolvechoice_v4_k_expert_data = ResolveChoice.apply(frame = applymapping_v4_k_expert_data, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_expert_data")

dropnullfields_v4_k_expert_data = DropNullFields.apply(frame = resolvechoice_v4_k_expert_data, transformation_ctx = "dropnullfields_v4_k_expert_data")

target_table = "v4data_public_v4_k_expert_data"

stage_table = "test.stage_v4data_public_v4_k_expert_data"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    user_id,
    license,
    principal,
    title,
    firstname,
    lastname,
    role,
    email,
    mobile,
    organization_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_expert_data = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_expert_data, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_expert_data", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_expert_data")

job.commit()



######v4_k_fulfillment######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_fulfillment = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_fulfillment", transformation_ctx = "datasource_v4_k_fulfillment", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_fulfillment = ApplyMapping.apply(frame = datasource_v4_k_fulfillment, mappings =  [('id', 'long', 'id', 'long'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('gx_fulfillment_id', 'string', 'gx_fulfillment_id', 'string'), ('subscription_id', 'long', 'subscription_id', 'long'), ('team_member_id', 'long', 'team_member_id', 'long'), ('gx_object_history_id', 'string', 'gx_object_history_id', 'string')], transformation_ctx = "applymapping_v4_k_fulfillment")

resolvechoice_v4_k_fulfillment = ResolveChoice.apply(frame = applymapping_v4_k_fulfillment, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_fulfillment")

dropnullfields_v4_k_fulfillment = DropNullFields.apply(frame = resolvechoice_v4_k_fulfillment, transformation_ctx = "dropnullfields_v4_k_fulfillment")

target_table = "v4data_public_v4_k_fulfillment"

stage_table = "test.stage_v4data_public_v4_k_fulfillment"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    gx_fulfillment_id,
    subscription_id,
    team_member_id,
    gx_object_history_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_fulfillment = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_fulfillment, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_fulfillment", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_fulfillment")

job.commit()



######v4_k_markup_tier######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_markup_tier = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_markup_tier", transformation_ctx = "datasource_v4_k_markup_tier", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_markup_tier = ApplyMapping.apply(frame = datasource_v4_k_markup_tier, mappings =  [('id', 'long', 'id', 'long'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('base', 'int', 'base', 'int'), ('permyriad', 'int', 'permyriad', 'int'), ('offering_id', 'long', 'offering_id', 'long')], transformation_ctx = "applymapping_v4_k_markup_tier")

resolvechoice_v4_k_markup_tier = ResolveChoice.apply(frame = applymapping_v4_k_markup_tier, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_markup_tier")

dropnullfields_v4_k_markup_tier = DropNullFields.apply(frame = resolvechoice_v4_k_markup_tier, transformation_ctx = "dropnullfields_v4_k_markup_tier")

target_table = "v4data_public_v4_k_markup_tier"

stage_table = "test.stage_v4data_public_v4_k_markup_tier"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    base,
    permyriad,
    offering_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_markup_tier = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_markup_tier, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_markup_tier", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_markup_tier")

job.commit()



######v4_k_member_agreement######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_member_agreement = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_member_agreement", transformation_ctx = "datasource_v4_k_member_agreement", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_member_agreement = ApplyMapping.apply(frame = datasource_v4_k_member_agreement, mappings =  [('id', 'long', 'id', 'long'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('message_id', 'string', 'message_id', 'string'), ('document_id', 'string', 'document_id', 'string'), ('document_type', 'int', 'document_type', 'int'), ('mobile', 'string', 'mobile', 'string'), ('organization_id', 'long', 'organization_id', 'long'), ('user_id', 'long', 'user_id', 'long')], transformation_ctx = "applymapping_v4_k_member_agreement")

resolvechoice_v4_k_member_agreement = ResolveChoice.apply(frame = applymapping_v4_k_member_agreement, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_member_agreement")

dropnullfields_v4_k_member_agreement = DropNullFields.apply(frame = resolvechoice_v4_k_member_agreement, transformation_ctx = "dropnullfields_v4_k_member_agreement")

target_table = "v4data_public_v4_k_member_agreement"

stage_table = "test.stage_v4data_public_v4_k_member_agreement"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    message_id,
    document_id,
    document_type,
    mobile,
    organization_id,
    user_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_member_agreement = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_member_agreement, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_member_agreement", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_member_agreement")

job.commit()



######v4_k_offering######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_offering = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_offering", transformation_ctx = "datasource_v4_k_offering", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_offering = ApplyMapping.apply(frame = datasource_v4_k_offering, mappings =  [('id', 'long', 'id', 'long'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('name', 'string', 'name', 'string'), ('pay_in_full_price', 'long', 'pay_in_full_price', 'long'), ('subscription_price', 'long', 'subscription_price', 'long'), ('service_tax', 'int', 'service_tax', 'int'), ('organization_id', 'long', 'organization_id', 'long'), ('catalog_item_id', 'long', 'catalog_item_id', 'long'), ('recurring', 'boolean', 'recurring', 'boolean'), ('reward_id', 'long', 'reward_id', 'long'), ('pay_over_time_price', 'long', 'pay_over_time_price', 'long'), ('is_favorite', 'boolean', 'is_favorite', 'boolean'), ('favorite_position', 'short', 'favorite_position', 'short')], transformation_ctx = "applymapping_v4_k_offering")

resolvechoice_v4_k_offering = ResolveChoice.apply(frame = applymapping_v4_k_offering, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_offering")

dropnullfields_v4_k_offering = DropNullFields.apply(frame = resolvechoice_v4_k_offering, transformation_ctx = "dropnullfields_v4_k_offering")

target_table = "v4data_public_v4_k_offering"

stage_table = "test.stage_v4data_public_v4_k_offering"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    name,
    pay_in_full_price,
    subscription_price,
    service_tax,
    organization_id,
    catalog_item_id,
    recurring,
    reward_id,
    pay_over_time_price,
    is_favorite,
    favorite_position
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_offering = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_offering, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_offering", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_offering")

job.commit()



######v4_k_organization_agreement######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_organization_agreement = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_organization_agreement", transformation_ctx = "datasource_v4_k_organization_agreement", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_organization_agreement = ApplyMapping.apply(frame = datasource_v4_k_organization_agreement, mappings =  [('id', 'long', 'id', 'long'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('document_id', 'string', 'document_id', 'string'), ('document_type', 'int', 'document_type', 'int'), ('signature', 'string', 'signature', 'string'), ('organization_id', 'long', 'organization_id', 'long'), ('user_id', 'long', 'user_id', 'long')], transformation_ctx = "applymapping_v4_k_organization_agreement")

resolvechoice_v4_k_organization_agreement = ResolveChoice.apply(frame = applymapping_v4_k_organization_agreement, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_organization_agreement")

dropnullfields_v4_k_organization_agreement = DropNullFields.apply(frame = resolvechoice_v4_k_organization_agreement, transformation_ctx = "dropnullfields_v4_k_organization_agreement")

target_table = "v4data_public_v4_k_organization_agreement"

stage_table = "test.stage_v4data_public_v4_k_organization_agreement"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    document_id,
    document_type,
    signature,
    organization_id,
    user_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_organization_agreement = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_organization_agreement, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_organization_agreement", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_organization_agreement")

job.commit()



######v4_k_organization_data######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_organization_data = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_organization_data", transformation_ctx = "datasource_v4_k_organization_data", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_organization_data = ApplyMapping.apply(frame = datasource_v4_k_organization_data, mappings =  [('id', 'int', 'id', 'int'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('gx_provider_id', 'string', 'gx_provider_id', 'string'), ('currency', 'string', 'currency', 'string'), ('rate', 'int', 'rate', 'int'), ('per_member_rate', 'int', 'per_member_rate', 'int'), ('address_id', 'long', 'address_id', 'long'), ('signer_id', 'long', 'signer_id', 'long'), ('merchant_id', 'long', 'merchant_id', 'long'), ('timezone', 'string', 'timezone', 'string'), ('gx_org_customer_id', 'string', 'gx_org_customer_id', 'string'), ('title', 'string', 'title', 'string'), ('firstname', 'string', 'firstname', 'string'), ('lastname', 'string', 'lastname', 'string'), ('role', 'int', 'role', 'int'), ('email', 'string', 'email', 'string'), ('mobile', 'string', 'mobile', 'string'), ('organization_id', 'int', 'organization_id', 'int')], transformation_ctx = "applymapping_v4_k_organization_data")

resolvechoice_v4_k_organization_data = ResolveChoice.apply(frame = applymapping_v4_k_organization_data, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_organization_data")

dropnullfields_v4_k_organization_data = DropNullFields.apply(frame = resolvechoice_v4_k_organization_data, transformation_ctx = "dropnullfields_v4_k_organization_data")

target_table = "v4data_public_v4_k_organization_data"

stage_table = "test.stage_v4data_public_v4_k_organization_data"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    gx_provider_id,
    currency,
    rate,
    per_member_rate,
    address_id,
    signer_id,
    merchant_id,
    timezone,
    gx_org_customer_id,
    title,
    firstname,
    lastname,
    role,
    email,
    mobile,
    organization_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_organization_data = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_organization_data, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_organization_data", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_organization_data")

job.commit()



######v4_k_plan######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_plan = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_plan", transformation_ctx = "datasource_v4_k_plan", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_plan = ApplyMapping.apply(frame = datasource_v4_k_plan, mappings =  [('id', 'long', 'id', 'long'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('gx_plan_id', 'string', 'gx_plan_id', 'string'), ('user_id', 'long', 'user_id', 'long')], transformation_ctx = "applymapping_v4_k_plan")

resolvechoice_v4_k_plan = ResolveChoice.apply(frame = applymapping_v4_k_plan, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_plan")

dropnullfields_v4_k_plan = DropNullFields.apply(frame = resolvechoice_v4_k_plan, transformation_ctx = "dropnullfields_v4_k_plan")

target_table = "v4data_public_v4_k_plan"

stage_table = "test.stage_v4data_public_v4_k_plan"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    gx_plan_id,
    user_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_plan = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_plan, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_plan", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_plan")

job.commit()



######v4_k_reward######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_reward = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_reward", transformation_ctx = "datasource_v4_k_reward", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_reward = ApplyMapping.apply(frame = datasource_v4_k_reward, mappings =  [('id', 'long', 'id', 'long'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('name', 'string', 'name', 'string'), ('tagline', 'string', 'tagline', 'string'), ('description', 'string', 'description', 'string'), ('type', 'int', 'type', 'int'), ('tile_icon', 'int', 'tile_icon', 'int'), ('tile_decoration', 'int', 'tile_decoration', 'int'), ('organization_id', 'long', 'organization_id', 'long'), ('amount', 'int', 'amount', 'int'), ('quantity', 'int', 'quantity', 'int')], transformation_ctx = "applymapping_v4_k_reward")

resolvechoice_v4_k_reward = ResolveChoice.apply(frame = applymapping_v4_k_reward, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_reward")

dropnullfields_v4_k_reward = DropNullFields.apply(frame = resolvechoice_v4_k_reward, transformation_ctx = "dropnullfields_v4_k_reward")

target_table = "v4data_public_v4_k_reward"

stage_table = "test.stage_v4data_public_v4_k_reward"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    name,
    tagline,
    description,
    type,
    tile_icon,
    tile_decoration,
    organization_id,
    amount,
    quantity
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_reward = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_reward, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_reward", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_reward")

job.commit()



######v4_k_signer_data######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_signer_data = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_signer_data", transformation_ctx = "datasource_v4_k_signer_data", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_signer_data = ApplyMapping.apply(frame = datasource_v4_k_signer_data, mappings =  [('id', 'int', 'id', 'int'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('user_id', 'long', 'user_id', 'long'), ('title', 'string', 'title', 'string'), ('firstname', 'string', 'firstname', 'string'), ('lastname', 'string', 'lastname', 'string'), ('role', 'int', 'role', 'int'), ('email', 'string', 'email', 'string'), ('mobile', 'string', 'mobile', 'string'), ('organization_id', 'int', 'organization_id', 'int')], transformation_ctx = "applymapping_v4_k_signer_data")

resolvechoice_v4_k_signer_data = ResolveChoice.apply(frame = applymapping_v4_k_signer_data, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_signer_data")

dropnullfields_v4_k_signer_data = DropNullFields.apply(frame = resolvechoice_v4_k_signer_data, transformation_ctx = "dropnullfields_v4_k_signer_data")

target_table = "v4data_public_v4_k_signer_data"

stage_table = "test.stage_v4data_public_v4_k_signer_data"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    user_id,
    title,
    firstname,
    lastname,
    role,
    email,
    mobile,
    organization_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_signer_data = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_signer_data, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_signer_data", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_signer_data")

job.commit()



######v4_k_staff_data######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_staff_data = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_staff_data", transformation_ctx = "datasource_v4_k_staff_data", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_staff_data = ApplyMapping.apply(frame = datasource_v4_k_staff_data, mappings =  [('id', 'int', 'id', 'int'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('user_id', 'long', 'user_id', 'long'), ('commission', 'int', 'commission', 'int'), ('title', 'string', 'title', 'string'), ('firstname', 'string', 'firstname', 'string'), ('lastname', 'string', 'lastname', 'string'), ('role', 'int', 'role', 'int'), ('email', 'string', 'email', 'string'), ('mobile', 'string', 'mobile', 'string'), ('organization_id', 'int', 'organization_id', 'int')], transformation_ctx = "applymapping_v4_k_staff_data")

resolvechoice_v4_k_staff_data = ResolveChoice.apply(frame = applymapping_v4_k_staff_data, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_staff_data")

dropnullfields_v4_k_staff_data = DropNullFields.apply(frame = resolvechoice_v4_k_staff_data, transformation_ctx = "dropnullfields_v4_k_staff_data")

target_table = "v4data_public_v4_k_staff_data"

stage_table = "test.stage_v4data_public_v4_k_staff_data"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    user_id,
    commission,
    title,
    firstname,
    lastname,
    role,
    email,
    mobile,
    organization_id
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_staff_data = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_staff_data, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_staff_data", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_staff_data")

job.commit()



######v4_k_subscription######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_subscription = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_subscription", transformation_ctx = "datasource_v4_k_subscription", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_subscription = ApplyMapping.apply(frame = datasource_v4_k_subscription, mappings =  [('id', 'long', 'id', 'long'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('cycles', 'int', 'cycles', 'int'), ('quantity', 'int', 'quantity', 'int'), ('is_subscription', 'boolean', 'is_subscription', 'boolean'), ('period_unit', 'int', 'period_unit', 'int'), ('period', 'int', 'period', 'int'), ('gx_subscription_id', 'string', 'gx_subscription_id', 'string'), ('plan_id', 'long', 'plan_id', 'long'), ('offering_id', 'long', 'offering_id', 'long'), ('type', 'int', 'type', 'int'), ('ad_hoc_offering_id', 'long', 'ad_hoc_offering_id', 'long'), ('amount_off', 'int', 'amount_off', 'int'), ('percentage_off', 'int', 'percentage_off', 'int'), ('discount_note', 'string', 'discount_note', 'string'), ('tax_percentage', 'int', 'tax_percentage', 'int')], transformation_ctx = "applymapping_v4_k_subscription")

resolvechoice_v4_k_subscription = ResolveChoice.apply(frame = applymapping_v4_k_subscription, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_subscription")

dropnullfields_v4_k_subscription = DropNullFields.apply(frame = resolvechoice_v4_k_subscription, transformation_ctx = "dropnullfields_v4_k_subscription")

target_table = "v4data_public_v4_k_subscription"

stage_table = "test.stage_v4data_public_v4_k_subscription"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    cycles,
    quantity,
    is_subscription,
    period_unit,
    period,
    gx_subscription_id,
    plan_id,
    offering_id,
    type,
    ad_hoc_offering_id,
    amount_off,
    percentage_off,
    discount_note
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_subscription = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_subscription, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_subscription", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_subscription")

job.commit()



######v4_k_users######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_v4_k_users = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_k_users", transformation_ctx = "datasource_v4_k_users", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_v4_k_users = ApplyMapping.apply(frame = datasource_v4_k_users, mappings =  [('id', 'int', 'id', 'int'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('status', 'int', 'status', 'int'), ('title', 'string', 'title', 'string'), ('role', 'int', 'role', 'int'), ('mobile', 'string', 'mobile', 'string'), ('organization_id', 'int', 'organization_id', 'int'), ('email', 'string', 'email', 'string')], transformation_ctx = "applymapping_v4_k_users")

resolvechoice_v4_k_users = ResolveChoice.apply(frame = applymapping_v4_k_users, choice = "make_cols", transformation_ctx = "resolvechoice_v4_k_users")

dropnullfields_v4_k_users = DropNullFields.apply(frame = resolvechoice_v4_k_users, transformation_ctx = "dropnullfields_v4_k_users")

target_table = "v4data_public_v4_k_users"

stage_table = "test.stage_v4data_public_v4_k_users"

pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    

post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select 
    id,
    created_at,
    updated_at,
    deprecated_at,
    status,
    title,
    role,
    mobile,
    organization_id,
    email
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    

datasink_v4_k_users = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_v4_k_users, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_v4_k_users", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_v4_k_users")

job.commit()

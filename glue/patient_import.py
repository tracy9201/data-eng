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

######import_list######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_import_list = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_patient_import_import_list", transformation_ctx = "datasource_import_list", additional_options = {"jobBookmarkKeys":["id","updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_import_list = ApplyMapping.apply(frame = datasource_import_list, mappings =  [('id', 'long', 'id', 'long'), ('uuid', 'string', 'uuid', 'string'), ('organization_id', 'long', 'organization_id', 'long'), ('list_name', 'string', 'list_name', 'string'), ('list_type', 'string', 'list_type', 'string'), ('status', 'int', 'status', 'int'), ('status_detail', 'string', 'status_detail', 'string'), ('import_file_url', 'string', 'import_file_url', 'string'), ('import_report_url', 'string', 'import_report_url', 'string'), ('error_row_count', 'int', 'error_row_count', 'int'), ('valid_row_count', 'int', 'valid_row_count', 'int'), ('total_row_count', 'int', 'total_row_count', 'int'), ('committed_row_count', 'int', 'committed_row_count', 'int'), ('failed_row_count', 'int', 'failed_row_count', 'int'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('created_by', 'string', 'created_by', 'string'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('updated_by', 'string', 'updated_by', 'string'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('deprecated_by', 'string', 'deprecated_by', 'string')], transformation_ctx = "applymapping_import_list")

resolvechoice_import_list = ResolveChoice.apply(frame = applymapping_import_list, choice = "make_cols", transformation_ctx = "resolvechoice_import_list")

dropnullfields_import_list = DropNullFields.apply(frame = resolvechoice_import_list, transformation_ctx = "dropnullfields_import_list")

target_table = "patient_import_list"
stage_table = "stage_patient_import_list"


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
    
    insert into {target_table} select * from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    
#   
datasink_import_list = glueContext.write_dynamic_frame.from_jdbc_conf(
    frame = dropnullfields_import_list, catalog_connection = "looker-staging", 
    connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": stage_table,"overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], transformation_ctx = "datasink_import_list")


job.commit()

######import_list_item######

job = Job(glueContext)

job.init(args['JOB_NAME'], args)

datasource_import_list_item = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_patient_import_import_list_item", transformation_ctx = "datasource_import_list_item", additional_options = {"jobBookmarkKeys":["id","updated_at"],"jobBookmarksKeysSortOrder":"asc"})

applymapping_import_list_item = ApplyMapping.apply(frame = datasource_import_list_item, mappings =  [('id', 'long', 'id', 'long'), ('list_id', 'long', 'list_id', 'long'), ('row_num', 'int', 'row_num', 'int'), ('raw_first_name', 'string', 'raw_first_name', 'string'), ('raw_last_name', 'string', 'raw_last_name', 'string'), ('raw_email', 'string', 'raw_email', 'string'), ('raw_mobile', 'string', 'raw_mobile', 'string'), ('raw_gender', 'string', 'raw_gender', 'string'), ('raw_external_id', 'string', 'raw_external_id', 'string'), ('status', 'int', 'status', 'int'), ('status_detail', 'string', 'status_detail', 'string'), ('customer_id', 'long', 'customer_id', 'long'), ('external_customer_link_id', 'long', 'external_customer_link_id', 'long'), ('created_at', 'timestamp', 'created_at', 'timestamp'), ('created_by', 'string', 'created_by', 'string'), ('updated_at', 'timestamp', 'updated_at', 'timestamp'), ('updated_by', 'string', 'updated_by', 'string'), ('deprecated_at', 'timestamp', 'deprecated_at', 'timestamp'), ('deprecated_by', 'string', 'deprecated_by', 'string')], transformation_ctx = "applymapping_import_list_item")

resolvechoice_import_list_item = ResolveChoice.apply(frame = applymapping_import_list_item, choice = "make_cols", transformation_ctx = "resolvechoice_import_list_item")

dropnullfields_import_list_item = DropNullFields.apply(frame = resolvechoice_import_list_item, transformation_ctx = "dropnullfields_import_list_item")

target_table = "patient_import_list_item"
stage_table = "stage_patient_import_list_item"


#pre_query = """
#    drop table if exists {stage_table};
#    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)


post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table} select * from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    
datasink_import_list_item = glueContext.write_dynamic_frame.from_jdbc_conf(
    frame = dropnullfields_import_list_item, catalog_connection = "looker-staging", 
    connection_options = { "postactions": post_query, "dbtable": stage_table,"overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], transformation_ctx = "datasink_import_list_item")


job.commit()




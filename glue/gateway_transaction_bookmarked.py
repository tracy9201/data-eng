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
job = Job(glueContext)
job.init(args['JOB_NAME'], args)
## @type: DataSource
## @args: [database = "gluetest", table_name = "v4data_public_v4_g_gateway_transaction", transformation_ctx = "datasource0"]
## @return: datasource0
## @inputs: []
datasource0 = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_v4_g_gateway_transaction", transformation_ctx = "datasource0", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})
## @type: ApplyMapping
## @args: [mapping = [("reason", "string", "reason", "string"), ("card_payment_gateway_id", "long", "card_payment_gateway_id", "long"), ("settlement_id", "long", "settlement_id", "long"), ("canceled_at", "timestamp", "canceled_at", "timestamp"), ("entry_mode", "string", "entry_mode", "string"), ("created_at", "timestamp", "created_at", "timestamp"), ("entry_capability", "string", "entry_capability", "string"), ("encrypted_ref_id", "string", "encrypted_ref_id", "string"), ("external_id", "string", "external_id", "string"), ("type", "string", "type", "string"), ("gratuity_amount", "long", "gratuity_amount", "long"), ("destination_object_id", "long", "destination_object_id", "long"), ("updated_at", "timestamp", "updated_at", "timestamp"), ("credit_id", "long", "credit_id", "long"), ("payment_id", "long", "payment_id", "long"), ("idempotency_key", "string", "idempotency_key", "string"), ("invoice_id", "long", "invoice_id", "long"), ("currency", "string", "currency", "string"), ("id", "long", "id", "long"), ("transaction_id", "string", "transaction_id", "string"), ("amount", "int", "amount", "int"), ("category_code", "string", "category_code", "string"), ("invoice_item_id", "long", "invoice_item_id", "long"), ("source_object_name", "string", "source_object_name", "string"), ("destination_object_name", "string", "destination_object_name", "string"), ("deleted_at", "timestamp", "deleted_at", "timestamp"), ("tendered", "int", "tendered", "int"), ("source_object_id", "long", "source_object_id", "long"), ("name", "string", "name", "string"), ("is_voided", "boolean", "is_voided", "boolean"), ("payment_gateway_id", "long", "payment_gateway_id", "long"), ("status", "short", "status", "short"), ("condition_code", "string", "condition_code", "string")], transformation_ctx = "applymapping1"]
## @return: applymapping1
## @inputs: [frame = datasource0]
applymapping1 = ApplyMapping.apply(frame = datasource0, mappings = [("reason", "string", "reason", "string"), ("card_payment_gateway_id", "long", "card_payment_gateway_id", "long"), ("settlement_id", "long", "settlement_id", "long"), ("canceled_at", "timestamp", "canceled_at", "timestamp"), ("entry_mode", "string", "entry_mode", "string"), ("created_at", "timestamp", "created_at", "timestamp"), ("entry_capability", "string", "entry_capability", "string"), ("encrypted_ref_id", "string", "encrypted_ref_id", "string"), ("external_id", "string", "external_id", "string"), ("type", "string", "type", "string"), ("gratuity_amount", "long", "gratuity_amount", "long"), ("destination_object_id", "long", "destination_object_id", "long"), ("updated_at", "timestamp", "updated_at", "timestamp"), ("credit_id", "long", "credit_id", "long"), ("payment_id", "long", "payment_id", "long"), ("idempotency_key", "string", "idempotency_key", "string"), ("invoice_id", "long", "invoice_id", "long"), ("currency", "string", "currency", "string"), ("id", "long", "id", "long"), ("transaction_id", "string", "transaction_id", "string"), ("amount", "int", "amount", "int"), ("category_code", "string", "category_code", "string"), ("invoice_item_id", "long", "invoice_item_id", "long"), ("source_object_name", "string", "source_object_name", "string"), ("destination_object_name", "string", "destination_object_name", "string"), ("deleted_at", "timestamp", "deleted_at", "timestamp"), ("tendered", "int", "tendered", "int"), ("source_object_id", "long", "source_object_id", "long"), ("name", "string", "name", "string"), ("is_voided", "boolean", "is_voided", "boolean"), ("payment_gateway_id", "long", "payment_gateway_id", "long"), ("status", "short", "status", "short"), ("condition_code", "string", "condition_code", "string")], transformation_ctx = "applymapping1")
## @type: ResolveChoice
## @args: [choice = "make_cols", transformation_ctx = "resolvechoice2"]
## @return: resolvechoice2
## @inputs: [frame = applymapping1]
resolvechoice2 = ResolveChoice.apply(frame = applymapping1, choice = "make_cols", transformation_ctx = "resolvechoice2")
## @type: DropNullFields
## @args: [transformation_ctx = "dropnullfields3"]
## @return: dropnullfields3
## @inputs: [frame = resolvechoice2]
dropnullfields3 = DropNullFields.apply(frame = resolvechoice2, transformation_ctx = "dropnullfields3")
## @type: DataSink
## @args: [catalog_connection = "looker-staging", connection_options = {"dbtable": "v4data_public_v4_g_gateway_transaction", "database": "looker"}, redshift_tmp_dir = TempDir, transformation_ctx = "datasink4"]
## @return: datasink4
## @inputs: [frame = dropnullfields3]
target_table = "v4data_public_v4_g_gateway_transaction"
stage_table = "test.stage2_v4data_public_v4_g_gateway_transaction"


pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)

post_query = """
    begin;
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table} 
    select  
    *
	from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
datasink4 = glueContext.write_dynamic_frame.from_jdbc_conf(
    frame = dropnullfields3, catalog_connection = "looker-staging", 
    connection_options = { "preactions": pre_query, "postactions": post_query, "dbtable": stage_table,"overwrite": "true", "database": "looker", "schema":"test"}, redshift_tmp_dir = args["TempDir"], transformation_ctx = "datasink4")

job.commit()

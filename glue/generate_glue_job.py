import psycopg2
import os

user = os.environ.get("v4db_user")
password = os.environ.get("v4db_password")
host = os.environ.get("v4db_host")
port = os.environ.get("v4db_port")
database = os.environ.get("v4db_database")


try:
    connection = psycopg2.connect(user = user,
                                  password = password,
                                  host = host,
                                  port = port,
                                  database = database)

    cursor = connection.cursor()
    tables = ['v4_g_account',
                 'v4_g_account_payment_gateway',
                 'v4_g_address',
                 'v4_g_authorisation',
                 'v4_g_billing_plan',
                 'v4_g_charge_back',
                 'v4_g_coupon',
                 'v4_g_credit',
                 'v4_g_customer',
                 'v4_g_customer_payment_gateway',
                 'v4_g_discount',
                 'v4_g_distributor',
                 'v4_g_fulfillment',
                 'v4_g_fulfillment_plan',
                 'v4_g_funding',
                 'v4_g_gateway_transaction',
                 'v4_g_invoice',
                 'v4_g_invoice_item',
                 'v4_g_payment',
                 'v4_g_payment_gateway',
                 'v4_g_payment_plan',
                 'v4_g_plan',
                 'v4_g_plantform_revenue',
                 'v4_g_price',
                 'v4_g_product',
                 'v4_g_provider',
                 'v4_g_refund',
                 'v4_g_settlement',
                 'v4_g_shipping',
                 'v4_g_subscription',
                 'v4_g_subscription_notification_plan',
                 'v4_g_userfield',
                 'v4_k_address',
                 'v4_k_brand',
                 'v4_k_brand_account_data',
                 'v4_k_catalog_item',
                 'v4_k_credit',
                 'v4_k_curator_data',
                 'v4_k_customer_data',
                 'v4_k_customer_note',
                 'v4_k_expert_data',
                 'v4_k_fulfillment',
                 'v4_k_markup_tier',
                 'v4_k_member_agreement',
                 'v4_k_offering',
                 'v4_k_organization_agreement',
                 'v4_k_organization_data',
                 'v4_k_plan',
                 'v4_k_reward',
                 'v4_k_signer_data',
                 'v4_k_staff_data',
                 'v4_k_subscription',
                 'v4_k_users'
              ]

    with open('glue_multisync_output.txt','w') as file:

        file.write("""
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
            """)

        for table in tables:
            print("\n\n\n\n")
            print("######"+table+"######")
            print("job = Job(glueContext)")
            print("job.init(args['JOB_NAME'], args)")
            #print("""datasource_{0} = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_{0}", transformation_ctx = "datasource_{0}", additional_options = {"jobBookmarkKeys":["updated_at"],"jobBookmarksKeysSortOrder":"asc"})""".format(table)+"\n\n"
            #     )
            file.write("\n\n\n\n")
            file.write("######"+table+"######" + "\n\n")
            file.write("job = Job(glueContext)"+ "\n\n")
            file.write("job.init(args['JOB_NAME'], args)"+"\n\n")
            file.write("""datasource_{0} = glueContext.create_dynamic_frame.from_catalog(database = "gluetest", table_name = "v4data_public_{0}", transformation_ctx = "datasource_{0}")""".format(table)+"\n\n"
                 )
    
    
    
            record = ''
            query = """select column_name,coulmn_type, column_name, coulmn_type
                                from 
                                (select column_name, 
                                case when data_type = 'bigint' then 'long'
                                     when data_type = 'integer' then 'int'
                                     when data_type = 'smallint' then 'short'
                                     when data_type in ('text','character varying','character') then 'string'
                                     when data_type like 'timestamp%' then 'timestamp'
                                     when data_type = 'boolean' then 'boolean'
                                     when data_type = 'numeric' then 'decimal(38,0)'
                                     end as coulmn_type
                                from INFORMATION_SCHEMA.COLUMNS where table_name = '{0}'
                                ) as a;
                                """.format(table)
            #print(query)
            cursor.execute(query)
            record = cursor.fetchall()
            #print(str(record) +"\n")
            print(("""applymapping_{0} = ApplyMapping.apply(frame = datasource_{0}, mappings =  """+ str(record) + """, transformation_ctx = "applymapping_{0}")""").format(table)+"\n\n")
            print("""resolvechoice_{0} = ResolveChoice.apply(frame = applymapping_{0}, choice = "make_cols", transformation_ctx = "resolvechoice_{0}")""".format(table)+"\n\n")
    
            print("""dropnullfields_{0} = DropNullFields.apply(frame = resolvechoice_{0}, transformation_ctx = "dropnullfields_{0}")""".format(table)+"\n\n")
    
            print("""datasink_%s = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_%s, catalog_connection = "looker-staging", 
                 connection_options = {"dbtable": "v4data_public_%s", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_%s")"""%(table,table,table,table)+"\n\n")
            print("job.commit()")


            query1 = """select column_name
                                from INFORMATION_SCHEMA.COLUMNS where table_name = '{0}'
                        ;""".format(table)
            #print(query)
            cursor.execute(query1)
            record1 = cursor.fetchall()


            file.write(("""applymapping_{0} = ApplyMapping.apply(frame = datasource_{0}, mappings =  """+ str(record) + """, transformation_ctx = "applymapping_{0}")""").format(table)+"\n\n")
            file.write("""resolvechoice_{0} = ResolveChoice.apply(frame = applymapping_{0}, choice = "make_cols", transformation_ctx = "resolvechoice_{0}")""".format(table)+"\n\n")
    
            file.write("""dropnullfields_{0} = DropNullFields.apply(frame = resolvechoice_{0}, transformation_ctx = "dropnullfields_{0}")""".format(table)+"\n\n")
    

            file.write('target_table = "v4data_public_{0}"'.format(table)+"\n\n")
            file.write('stage_table = "stage_v4data_public_{0}"'.format(table)+"\n\n")


            
            
            file.write('''pre_query = """
    drop table if exists {stage_table};
    create table {stage_table} as select * from {target_table} LIMIT 0;""".format(stage_table=stage_table, target_table=target_table)
    '''+"\n\n")

            
            
            file.write('''post_query = """
    begin;
    
    delete from {stage_table} using {target_table} 
    where {target_table}.id = {stage_table}.id 
    and {target_table}.updated_at = {stage_table}.updated_at;  
    
    delete from {target_table} using {stage_table} 
    where {stage_table}.id = {target_table}.id; 
    
    insert into {target_table}
    Select '''
                )
            print("################")
            print(len(record1))

            print("################")
            i=0
            r=''
            len_record = len(record1)
            for i,r in enumerate(record1):
                part1=r
                if i == len_record - 1:
                    if part1 == "status_short":
                        pass
                    else:
                        file.write("\n"+"    "+'{}'.format(part1).replace("(","").replace(")","").replace("'","").replace(",",""))
                else:
                    file.write("\n"+"    "+'{}'.format(part1).replace("(","").replace(")","").replace("'",""))


            file.write(
    '''
    from {stage_table}; 
    commit;
    end;""".format(stage_table=stage_table, target_table=target_table)
    '''+"\n\n")
    


            file.write("""datasink_%s = glueContext.write_dynamic_frame.from_jdbc_conf(frame = dropnullfields_%s, catalog_connection = "looker-staging", 
                 connection_options = {"preactions": pre_query, "postactions": post_query, "dbtable": "stage_v4data_public_%s", "overwrite": "true", "database": "looker"}, redshift_tmp_dir = args["TempDir"], 
                 transformation_ctx = "datasink_%s")"""%(table,table,table,table)+"\n\n")
            file.write("job.commit()")

except (Exception, psycopg2.Error) as error :
    print ("Error while connecting to PostgreSQL", error)


import os
import sys
import psycopg2
from slack import WebClient
import pandas as pd
from tabulate import tabulate


def DBConn(user,password,host,port,db):

    connection = psycopg2.connect(user=user,
                              password=password,
                              host=host,
                              port=port,
                              database=db)
    
    return connection.cursor()
    
    

def slack_message(msg, channel,SLACK_API_TOKEN):
    if SLACK_API_TOKEN:
        sc = WebClient(SLACK_API_TOKEN)
        response = sc.chat_postMessage(
                    channel="#test-looker-alert",
                        text=msg)
    else:
        print("Slack token not found")
        

        
def main():

    #ALERT_CHANNEL = '#test-alerts-looker'
    #ALERT_CHANNEL = '#dataeng-alerts'
    ALERT_CHANNEL = '#prod-alerts'
    SLACK_API_TOKEN = os.environ.get("SLACK_API_TOKEN")
    
    user = os.environ.get("redshift_user")
    print(user)
    password = os.environ.get("redshift_password")
    host = os.environ.get("redshift_host")
    port = os.environ.get("redshift_port")
    database = os.environ.get("redshift_database")
    
    redshiftCursor = DBConn(user,password,host,port,database)


    factTableDict = {'public.payment_summary':'sales_created_at','public.deposit_summary':'funding_date_time',
                     'public.product_sales':'subscription_created','dwh.fact_invoice_item':'pay_date'}
    
    for key,val in factTableDict.items():
        print(key, val)
        query = """
        select datepart(hour,current_timestamp-max(""" + val +""")) from """ + key
    
        print(query)
        redshiftCursor.execute(query)
        diffHours = redshiftCursor.fetchall()[0][0]
        if diffHours > 2.0:
            table = key.split('.')[1]
            message = table + " view is stale by " + str(diffHours) +" hours."
            slack_message(message, ALERT_CHANNEL,SLACK_API_TOKEN)
    
    
    rdsUser = os.environ.get("rds_user")
    print(rdsUser)
    rdsPassword = os.environ.get("rds_password")
    rdsHost = os.environ.get("rds_host")
    rdsPort = os.environ.get("rds_port")
    rdsDatabase = os.environ.get("rds_database")
    
    rdsCursor = DBConn(rdsUser,rdsPassword,rdsHost,rdsPort,rdsDatabase)


    dimTableList = ['dwh.dim_customer', 'dwh.dim_provider', 'public.kronos_subscription', 'public.staff_details']
    
    for dimTable in dimTableList:
        if dimTable == 'dwh.dim_customer':
            v4TabName = 'public.customer_data'
        elif dimTable == 'dwh.dim_provider':
            v4TabName = 'public.organization_data'
        elif dimTable == 'public.kronos_subscription':
            v4TabName = 'public.v4_k_subscription'
        elif dimTable == 'public.staff_details':
            v4TabName = 'public.staff_data'
        else:
            v4TabName = 'public.device_data'
        
        v4Query = "select count(*) from " + v4TabName +";"
        rdsCursor.execute(v4Query)
        v4Count = rdsCursor.fetchall()[0][0]
        print("v4Count for "+v4TabName+": "+str(v4Count))
        
        dwhQuery = "select count(*) from " + dimTable +";"
        redshiftCursor.execute(dwhQuery)
        dwhCount = redshiftCursor.fetchall()[0][0]
        print("dwhCount: "+str(dwhCount))
        
        diffCount = abs(v4Count - dwhCount)
        if diffCount > 5000:
            print("wrong data in table "+dimTable)
            message = dimTable + " view data is inconsistent with the source. Difference:  " + str(diffCount)
            slack_message(message, ALERT_CHANNEL,SLACK_API_TOKEN)


main()
    
    
    
    
    
    
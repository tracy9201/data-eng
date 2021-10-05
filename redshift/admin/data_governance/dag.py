import logging
import sys
import json
import os 
import logging.config
import time
#import pytz
import argparse
#import psycopg2
import redshift_connector
#import functools
import string 
import random
import secrets


from time import localtime
from datetime import datetime, timezone
from os import path
from operator import itemgetter, attrgetter
from typing import Sequence, Optional, List
#from collections import defaultdict
#from dataclasses import dataclass

from pprint import pprint
from dotenv import load_dotenv
from dotenv import dotenv_values
from pathlib import Path

LOGGER_NAME = 'logging.ini'
_myloggername = 'dag'

app_name_long = 'encrypt sensitive data on aws redshift'
app_name_short = 'dag'

app_dot_env_path = None


dir_abs = os.path.dirname(path.abspath(__file__))
_appname = os.path.basename(__file__)
sys_path = sys.path

logger_file_path = path.join(dir_abs, LOGGER_NAME)
logging.config.fileConfig(logger_file_path)
 

logger = logging.getLogger(_myloggername)


class Logtime(object):
    def __init__(self,loggername:str):
        self._logger = logging.getLogger(loggername)

   
    def _get_now(self):
        utc_dt = datetime.now(timezone.utc)
        return utc_dt

    def _start(self):
        utc_dt =  self._get_now()
        self._logger.info(f'Start Time:{utc_dt.astimezone().strftime("%Y%m%d %H:%M:%S %p %Z%z")}')
        self._logger.info(f'Start Time:{ utc_dt.strftime("%A %Y %B %d")}')
        self._logger.info(f'Start Time UTC :{ utc_dt.strftime("%Y%m%d %H:%M:%S %p %Z%z")}')

    
    def _end(self):
        utc_dt =  self._get_now()
        self._logger.info(f'End Time:{utc_dt.astimezone().strftime("%Y%m%d %H:%M:%S %p %Z%z")}')
        self._logger.info(f'End Time UTC:{ utc_dt.strftime("%Y%m%d %H:%M:%S %p %Z%z")}')
        self._logger.info(f'End Time:{ utc_dt.strftime("%A %Y %B %d")}')
        
        


class My_dotenv(object):
    def __init__(self,env:Optional[str]='qa',app_path_to_dot_env:Optional[str]=None):
        self.env = env    
        
        if not app_path_to_dot_env:
           logger.info(f'searching... for .env file on current path')
           load_dotenv()
        else:
           dot_path = Path(app_path_to_dot_env)
           logger.info(f'searching... for .env file on {dot_path}')
           load_dotenv(dotenv_path=dot_path)
          
        config = {**dotenv_values(".env")}
        env = self.env 
        my_config = {key.replace(env+'.',''):val for key, val in config.items() if key.startswith(f'{env}.')}
        self.my_dict = my_config
        #logger.debug(f' my_config:{my_config}')

        @property
        def my_dict(self):
            return self.my_dict
            

class My_redshift(object):
    def __init__(self,*args, **kwargs):
      
          self.config = kwargs['config']
          self.dbname = self.config['dbname']
          self.host = self.config['host']
          self.port = self.config['port']
          self.user = self.config['user']
          self.password = self.config['password']
          
    def create_conn(self, conn_dict:[dict]):
        self.conn = None
        try:
            self.conn=redshift_connector.connect(database = conn_dict['dbname'], 
                                  host = conn_dict['host'], 
                                  user = conn_dict['user'], 
                                  password = conn_dict['password']
                                  )
         
        except Exception as e:
            logger.error(f"error try to connect to redshift:{e} to {conn_dict['dbname']} on {conn_dict['host']}")
        else:
            logger.info(f"connect successful")            
        return self.conn  
    

    
    def get_version(self, conn)->str:
        cur = conn.cursor()
        cur.execute('SELECT version()')
        db_version  = cur.fetchone()
        cur.close()
        return db_version

    def get_database(self, conn)->str:
        cur = conn.cursor()
        cur.execute('SELECT current_database()')
        db_name  = cur.fetchone()
        cur.close()
        return db_name    



class Sensitive_olap_data(object):
    def __init__(self,conn,encrypt_sensitive_data_ctl_table:Optional[str]='public.encrypt_sensitive_data_ctl'):
        self.control_audit_table = encrypt_sensitive_data_ctl_table
        
        self.conn = conn
        self.set_listed()
        
    def set_listed(self):

        cur = self.conn.cursor()
        cur.execute(f'SELECT  id, "_schema", "_table", "_column", "_columnlength" from {self.control_audit_table} where is_encrypted = false and is_ready_for_encryption= true')
        rows =  cur.fetchall()
        cur.close()      
        #for row in rows:
        row_list =[rows]    
        self._list = row_list   

    def get_control_audit_table_cnt(self)->int:
        cnt = 0 
        cur = self.conn.cursor()
        cur.execute(f'SELECT count(*) from {self.control_audit_table} where is_encrypted = false and is_ready_for_encryption= true')
        cnt =  cur.fetchone()     
        logger.info(f'{self.control_audit_table}:rows:{cnt}')            
        cur.close()
        return cnt
    
    def get_key_cnt(self,keys)->int:
        key_cnt = len(keys)
        logger.info(f'key count:{key_cnt}')       
        return key_cnt
    
    
    def generate_random_password(self,minlen:Optional[int]=12,maxlen:Optional[int]=30)->str:
        logger.info(f'generating random k')
        i = random.randint(minlen,maxlen)
        characters = string.ascii_letters + string.digits + "!@#$%&-."
        k = ''.join(secrets.choice(characters) for l in range(i))
        return k
        
    
    def update_control_table_for_start_enc(self,utc_dt,id)->int:

        sql = f'update {self.control_audit_table} set encryption_start = %s  where id = %s'
        cnt = 0
        try:
            cur = self.conn.cursor()            
            cur.execute(sql, (utc_dt, id))
            cnt = cur.rowcount
            self.conn.commit()
        except Exception as e:
            logger.error(f"error try to update {self.control_audit_table} encryption_start:{e}")
        else:
            logger.info(f"update_control_table_for_start_enc {self.control_audit_table} {cnt} row(s) updated") 
        return cnt    
    
    
    def update_control_table_code_message(self,message:str,id)->int:

        sql = f'update {self.control_audit_table} set code_message = %s  where id = %s'
        cnt = 0
        try:
            cur = self.conn.cursor()            
            cur.execute(sql, (message, id))
            cnt = cur.rowcount
            self.conn.commit()
        except Exception as e:
            logger.error(f"error try to update {self.control_audit_table} code_message:{e}")
        else:
            logger.info(f"update_control_table_code_message {self.control_audit_table} {cnt} row(s) updated") 
        return cnt        
     

    def update_control_table_for_end_enc(self,utc_dt,ucnt, id)->int:

        sql = f'update {self.control_audit_table} set encryption_end = %s,  is_encrypted = true, encrypted_row_count = %s where id = %s'
        cnt = 0
        try:
            cur = self.conn.cursor()            
            cur.execute(sql, (utc_dt, ucnt, id))
            cnt = cur.rowcount
            self.conn.commit()
        except Exception as e:
            logger.error(f"error try to update {self.control_audit_table} encryption_end:{e}")
        else:
            logger.info(f"update_control_table_for_end_enc {self.control_audit_table} {cnt} row(s) updated") 
        return cnt   

    
    def encrypt_column(self,schema,table,column,columnlength,enckey,lpad_fill_char, level:Optional[int]=32)->int:
        level = level if level in (16,24,32) else 32

            
        cnt = 0
        try:
            cur = self.conn.cursor()
            if columnlength:
                sql = f"UPDATE {schema}.{table} SET {column} = udf_enc.aes_encrypt({column}, LPAD('{enckey}', {level}, '{lpad_fill_char}'))::VARCHAR({columnlength})"
            else:
                sql = f"UPDATE {schema}.{table} SET {column} = udf_enc.aes_encrypt({column}, LPAD('{enckey}', {level}, '{lpad_fill_char}'))"
                
            cur.execute(sql)
            cnt = cur.rowcount
            self.conn.commit()
        except Exception as e:
            logger.error(f"error try to update {schema}{table}{column}:{e}")
        else:
            logger.info(f"{schema}.{table}.{column} {cnt} row(s) updated") 
        finally:
            logger.info(f"finally for try encrypt_column.")
        return cnt 


    @property
    def nested_list( self ):
        return self._list
    
    @property
    def get_len( self )->int:
        return len(self._list)      

    
class Matillion(object):
    def __init__(self,*args, **kwargs):
      self.project_name = f'${project_name}'
      self.environment_name = f'${environment_name}'
      self.environment_default_schema = f'${environment_default_schema}'
      self.environment_database = f'${environment_database}'
      self.version_name = f'${version_name}'
      self.version_id = f'${version_id}'    
      self.job_name = f'${job_name}'    
      self.job_id = f'${job_id}' 
      self.component_name = f'${component_name}'    
      self.component_id = f'${component_id}' 
     

    def printMatillionMetadata(self):
      logger.info(f'matillion project_name:{self.project_name}')
      logger.info(f'matillion environment_name:{self.environment_name}')
      logger.info(f'matillion environment_default_schema:{self.environment_default_schema}')
      logger.info(f'matillion environment_database:{self.environment_database}')
      logger.info(f'matillion version_name:{self.version_name}')
      logger.info(f'matillion version_id:{self.version_id}')   
      logger.info(f'matillion job name:{self.job_name}')   
      logger.info(f'matillion job id:{self.job_id}')   
      logger.info(f'matillion component name:{self.component_name}')   
      logger.info(f'matillion component id:{self.component_id}')       
    

            
def main():

    parser = argparse.ArgumentParser(description='encrypt sensitive data elements based on pyaes library and function in redshift')
 
    parser.add_argument('--dryrun', '--dry-run','--dry',help='if present will only perform read level operations' ,action='store_true')
    parser.add_argument('--e', nargs=1, type=str, choices=['qa','stage'], help='the redshift environment, the default is qa',default=['qa'])
    parser.add_argument('--p', nargs=1, type=str, help='the dw cluster p' )
    parser.add_argument('--k',  type=str,default=None, help="the encryption secret k, optional" )
    parser.add_argument('--c',  type=str,default=None, help="k lpad filler character, optional" )
    parser.add_argument('--l', nargs=1, type=int, choices=[16,24,32], help='encryption key length, the default is 32',default=[32])
   
    args = parser.parse_args()
    # comment in for development only
    #logger.debug(f' comment in for development,comment out for checkin:aruments passed:{args}')

    tic = time.perf_counter()
    lt = Logtime(f'{_myloggername}')
    lt._start()

    _code_message = f'currdir:{dir_abs} app name:{_appname}'
    logger.info(f'{_code_message}')

    
    
    _path_to_dot_env =  app_dot_env_path
    if _path_to_dot_env:
        logger.info(f'using path to .env:{_path_to_dot_env}')
        my_e = My_dotenv(args.e[0],_path_to_dot_env)       
    else:
        my_e = My_dotenv(args.e[0])    
    
    
    if my_e.my_dict:  
      if args.p:
          pw = args.p[0]
          my_e.my_dict['password'] = pw
      elif my_e.my_dict['password']:
          pw =  my_e.my_dict['password']
      else:
          logger.critical(f'error no password found')
          sys.exit(1)  
    else:
        logger.critical(f'error no password found')
        sys.exit(1) 

    my_red =  My_redshift(config=my_e.my_dict)
    my_conn = my_red.create_conn(my_red.config)
    
    if my_conn is not None:
        meta_db_version = my_red.get_version(my_conn)
        meta_db_name = my_red.get_database(my_conn)
        logger.info(f'database name/database version:{meta_db_name}/{meta_db_version}')
  
    
        if my_e.my_dict['enc_ctl_table']:
            sensitive_olap_data = Sensitive_olap_data(my_conn,my_e.my_dict['enc_ctl_table'])
        else:
            sensitive_olap_data = Sensitive_olap_data(my_conn)
        
        control_audit_row_cnt = sensitive_olap_data.get_control_audit_table_cnt()
        logger.info(f"sensitive_olap_data.nested_list:{sensitive_olap_data.nested_list}")
        logger.info(f"control_audit_row_cnt:{control_audit_row_cnt[0]}")
        k = args.k
        if not  k:
            k = sensitive_olap_data.generate_random_password()
        ek = [x for x in k.split(',')]
        key_count = sensitive_olap_data.get_key_cnt(ek)
        """ comment out before PR
        """
        #logger.debug(f'password:{ek}')
        if not args.c:
            lpad_fill_char = random.choice(string.ascii_letters)
        else:
            lpad_fill_char = args.c
        """ comment out before PR
        """
        #logger.debug(f'pad_fill_char:{lpad_fill_char}')
        enc_level = args.l[0]

        
    if args.dryrun:       
        logger.info('--dryrun read only actions performed')
    else:
         if my_conn is not None:
            if control_audit_row_cnt[0] > 0: 
                logger.info(f'executing encryptions...')
                # loop thru enc listing from control table
                logger.debug(f'len of row:{len(sensitive_olap_data.nested_list)}')
                for i in range(0,control_audit_row_cnt[0]):

                    row = sensitive_olap_data.nested_list[0][i]
                    logger.info(f'processing encryptions for 0,{i} :{row}')
                    id = row[0]
                    _schema = row[1]
                    _table =  row[2]
                    _column = row[3]
                    _columnlength = row[4]
                    update_cnt = sensitive_olap_data.update_control_table_for_start_enc(lt._get_now(),id )
                    # run enc.....
                    cnt = sensitive_olap_data.encrypt_column(_schema,_table,_column,_columnlength, ek[0],lpad_fill_char, enc_level)
                    update_cnt = sensitive_olap_data.update_control_table_for_end_enc(lt._get_now(), cnt, id )
                    update_cnt = sensitive_olap_data.update_control_table_code_message(_code_message, id )

            else:
                logger.warning(f'Nothing to do:{sensitive_olap_data.control_audit_table}:rows:{control_audit_row_cnt[0]}')
    
    if my_conn is not None:
        my_conn.close

    lt._end()

    toc = time.perf_counter()
    elapsed = toc - tic
    elapsed_min =  elapsed/60
    elapsed_hrs = elapsed_min/60
    logger.info(f'elapsed time: {elapsed  :0.3f}secs {elapsed_min  :0.2f}min(s) {elapsed_hrs :0.2f}hr(s)') 
   
if __name__ == "__main__":
    
    main()

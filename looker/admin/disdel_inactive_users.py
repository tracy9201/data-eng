# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import looker_sdk
import logging
import sys
import json
import os 
import logging.config
import time
import pytz
import argparse


from time import localtime
from datetime import datetime, timezone
from os import path
from looker_sdk import models
from operator import itemgetter, attrgetter
from typing import Sequence, Optional, List
from collections import defaultdict

from pprint import pprint
from dotenv import load_dotenv
from dotenv import dotenv_values

LOGGER_NAME = 'logging.ini'
_myloggername = 'disdel_inactive_users'

app_name_long = 'disable delete inactive users in looker via looker sdk'
app_name_short = 'disdel'

dir_abs = os.path.dirname(path.abspath(__file__))
_appname = os.path.basename(__file__)
sys_path = sys.path

#print(f'INFO: dir_abs:{dir_abs}')
#print(f'INFO: app:{_appname}')
#print(f'INFO: sys_path :{sys_path }')

logger_file_path = path.join(dir_abs, LOGGER_NAME)
logging.config.fileConfig(logger_file_path)
#print(f'INFO: Loading {LOGGER_NAME} at location:{logger_file_path}')

logger = logging.getLogger(_myloggername)
 


class Logtime(object):
    def __init__(self,loggername:str):
        self._logger = logging.getLogger(loggername)

   
    def _start(self):
        utc_dt = datetime.now(timezone.utc)
        self._logger.info(f'Start Time:{utc_dt.astimezone().strftime("%Y%m%d %H:%M:%S %p %Z%z")}')
        self._logger.info(f'Start Time:{ utc_dt.strftime("%A %Y %B %d")}')
        self._logger.info(f'Start Time UTC :{ utc_dt.strftime("%Y%m%d %H:%M:%S %p %Z%z")}')

    
    def _end(self):
        utc_dt = datetime.now(timezone.utc)
        self._logger.info(f'End Time:{utc_dt.astimezone().strftime("%Y%m%d %H:%M:%S %p %Z%z")}')
        self._logger.info(f'End Time UTC:{ utc_dt.strftime("%Y%m%d %H:%M:%S %p %Z%z")}')
        self._logger.info(f'End Time:{ utc_dt.strftime("%A %Y %B %d")}')

class my_looker_sdk(object):
    def __init__(self,env:Optional[str]='qa'):
        self.env = env    
        # For this to work you must either have set environment variables or created a looker.ini as described below in "Configuring the SDK"
        if os.path.exists("looker.ini"):
            logger.info(f'using ini file')
        else:
            logger.info(f'using .env file')
            load_dotenv()
            config = {**dotenv_values(".env")}
            env = self.env 
            my_config = {key.replace(env+'.',''):val for key, val in config.items() if key.startswith(f'{env}.')}
            os.environ['LOOKERSDK_CLIENT_ID'] = my_config['client_id']
            os.environ['LOOKERSDK_CLIENT_SECRET'] = my_config['client_secret']    
            os.environ['LOOKERSDK_BASE_URL'] = my_config['base_url']
            os.environ['LOOKERSDK_VERIFY_SSL'] = my_config['verify_ssl']
            os.environ['LOOKERSDK_TIMEOUT'] = my_config['timeout']
            os.environ['LOOKERSDK_API_VERSION'] = my_config['api_version']


        self.sdk = looker_sdk.init40()
        me_user = self.sdk.me()
        logger.debug(f'looker sdk.me():{me_user.email}')


    def get_all_users(self,*args,**kwargs)-> Sequence[models.User]:
        users = self.sdk.all_users(*args, **kwargs)
        logger.debug(f'Number of Users:{len(users)}')
        assert isinstance(users, list)
        return users
    
    def get_look(self,lookname:Optional[str]='Inactive_Users')->Sequence[models.Look]:
        look = ''
        look = self.sdk.search_looks(title=lookname)
        logger.debug(f'look:{look}')
        if not look:
            logger.critical(f'look:{lookname} not found')
        return look
     
    def run_look(self,look:Sequence[models.Look])->list:
        look_results = self.sdk.run_look(look[0].id,'json')
        look_results_list = json.loads(look_results)
        cohort_nummber = len(look_results_list)
        logger.info(f'number of users selected:{cohort_nummber }')
        if cohort_nummber >0:
            logger.debug(f'action will be taken against:{look_results_list}')

        return look_results_list 
        
    def user_action(self,cohort_list:List,action:Optional[str]='disable'):
        action_cnt = 0
        for i,u in enumerate(cohort_list):
            
            logger.warning(f'{action} user:{u}')

            if action=='delete':
               try:
                    get_user = self.sdk.user(u['user.id'])
                    self.sdk.delete_user(get_user['id'] )
               except Exception as e:
                    logger.error(f'error:{e}')   
               else:
                    action_cnt += 1
            else:
                try:
                    get_user = self.sdk.user(u['user.id'])
                    get_user['is_disabled']=True
                    self.sdk.update_user(get_user['id'], get_user )
                except Exception as e:
                    logger.error(f'error:{e}')   
                else:
                    action_cnt += 1
        logger.info(f'total users {action}:{action_cnt}')

    def create_cohort_from_file(self,filename:str)->list:
 
        ids_from_file_list = []
         
        try:
            f = open(filename)
            ids_from_file_list = json.load(f)
 
                
        except Exception as e:
            logger.error(f'error:{e}')   
            
        else:
            logger.info(f'{len(ids_from_file_list)}:line(s) in file:{filename}' )
            logger.debug(f' ids_from_file_list:{ ids_from_file_list }')
 
        return  ids_from_file_list    



def main():

    parser = argparse.ArgumentParser(description='disable or delete inactive looker users via looker sdk by running a look OR using a .txt file of user ids')
 
    group = parser.add_mutually_exclusive_group(required=True)
 
    parser.add_argument('--e', nargs=1, type=str, choices=['qa','stage','prod'], help='the looker environment, the default is qa',default=['qa'])
    
    group.add_argument('--l','--look', nargs=1,  help='the look that produces the cohort, mutally exclusive from the -f option')
    group.add_argument('--f','--file', nargs=1, help='the file that produces the cohort, mutally exclusive from the -l option')
    
    
    parser.add_argument('--a','--act','--action', nargs=1, type=str, choices=['disable','delete'], help='the action to perform on the user, the default is disable',default=['disable'])
 
    parser.add_argument('--dryrun', '--dry-run','--dry',help='if present will only perform read level operations' ,action='store_true')
 
    args = parser.parse_args()
    logger.info(f' aruments passed:{args}')


    tic = time.perf_counter()
    lt = Logtime(f'{_myloggername}')
    lt._start()

    logger.info(f'currdir:{dir_abs} app name:{_appname}')
    
    looker_sdk = my_looker_sdk(args.e[0])
    
    if args.l:
        look = looker_sdk.get_look(args.l[0])
        if look:
            user_cohort = looker_sdk.run_look(look)
    else:
        user_cohort = looker_sdk.create_cohort_from_file(args.f[0])
        
    logger.debug(f'user_cohort:{user_cohort }')

    if not args.dryrun  and len(user_cohort)>0:
        logger.warning(f'action={args.a[0]} {len(user_cohort)} users')
        looker_sdk.user_action(user_cohort,args.a[0])
    elif args.dryrun:
        logger.info('--dryrun read only actions performed')
    elif len(user_cohort)==0:    
        logger.info(f'Users Selected is {len(user_cohort)}')

    

    lt._end()

    toc = time.perf_counter()
    elapsed = toc - tic
    elapsed_min =  elapsed/60
    elapsed_hrs = elapsed_min/60
    logger.info(f'elapsed time: {elapsed  :0.3f}secs {elapsed_min  :0.2f}min(s) {elapsed_hrs :0.2f}hr(s)') 
   
if __name__ == "__main__":
    
    main()

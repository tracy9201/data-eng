import os
import sys
import lookerapi as looker
import time
from lookerapi.rest import ApiException
from pprint import pprint
import json
import ast
import simplejson
import numpy as np
import pandas as pd



def initiate_authenticate_looker(base_url, client_id, client_secret):
    
    unauthenticated_client = looker.ApiClient(base_url)
    unauthenticated_authApi = looker.ApiAuthApi(unauthenticated_client)
    
    token = unauthenticated_authApi.login(client_id=client_id, client_secret=client_secret)
    client = looker.ApiClient(base_url, 'Authorization', 'token ' + token.access_token)
    
    userApi = looker.UserApi(client)
    me = userApi.me()
    
    return userApi


def main():
    base_url = os.environ.get("base_url")
    client_id = os.environ.get("client_id")
    client_secret = os.environ.get("client_secret")
    
    fields = 'fields_example' 
    user_attribute_ids = [19] 
    all_values = True 
    include_unset = True 
    
    user_id_file = "user_id.txt"
    

    
    api_instance = initiate_authenticate_looker(base_url, client_id, client_secret)
        

    try:
        f = open(user_id_file, "r")
        df1 = pd.DataFrame(columns = ['user_id','value'])
        print(df1)
        
        for x in f:
            
            user_id = x.rstrip()
            api_response = api_instance.user_attribute_user_values(user_id, user_attribute_ids=user_attribute_ids,  all_values=all_values, include_unset=include_unset)
            
            
            df = pd.DataFrame(data = [[api_response[0].user_id, api_response[0].value]], columns = ['user_id','value'])
            
            df1 = df1.append(df)
            
        
        df1.to_csv('user_attribute_combination.csv')
        
    except ApiException as e:
        print("Exception when calling UserApi->user_attribute_user_values: %s\n" % e) 
        

main()
    
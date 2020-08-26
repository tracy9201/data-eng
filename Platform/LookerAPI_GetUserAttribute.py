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

################# INITIATE AND AUTHENTICATE LOOKER API #####################

def initiate_authenticate_looker(base_url, client_id, client_secret):
    # instantiate Auth API
    unauthenticated_client = looker.ApiClient(base_url)
    unauthenticated_authApi = looker.ApiAuthApi(unauthenticated_client)
    # authenticate client
    token = unauthenticated_authApi.login(client_id=client_id, client_secret=client_secret)
    client = looker.ApiClient(base_url, 'Authorization', 'token ' + token.access_token)
    # instantiate User API client
    userApi = looker.UserApi(client)
    me = userApi.me()
    
    return userApi
############################################################################

########################### MAIN FUNCTION ##################################

def main():
    base_url = os.environ.get("base_url")
    #Looker admins can create API3 credentials on Looker's **Admin/Users** page
    client_id = os.environ.get("client_id")
    client_secret = os.environ.get("client_secret")
    
    fields = 'fields_example' # str | Requested fields. (optional)
    user_attribute_ids = [19] # list[int] | Specific user attributes to request. Omit or leave blank to request all user attributes. (optional)
    all_values = True # bool | If true, returns all values in the search path instead of just the first value found. Useful for debugging group precedence. (optional)
    include_unset = True # bool | If true, returns an empty record for each requested attribute that has no user, group, or default value. (optional)
    
    user_id_file = "user_id.txt"
    
###################### INITITATE LOOKER API INSTANCE ##########################
    
    api_instance = initiate_authenticate_looker(base_url, client_id, client_secret)
        
############## FETCH USER ATTRIBUTE VALUES FOR EACH USER PASSED IN THE FILE #####################
    try:
        # Get User Attribute Values
        f = open(user_id_file, "r")
        df1 = pd.DataFrame(columns = ['user_id','value'])
        print(df1)
        
        for x in f:
            #print(x.rstrip())
            user_id = x.rstrip()
            api_response = api_instance.user_attribute_user_values(user_id, user_attribute_ids=user_attribute_ids,  all_values=all_values, include_unset=include_unset)
            #pprint(api_response[0])
            
            df = pd.DataFrame(data = [[api_response[0].user_id, api_response[0].value]], columns = ['user_id','value'])
            #print(df)
            df1 = df1.append(df)
            #print(df1)
        print(df1)
        #df1.to_csv('user_attribute_combination.csv')
        
    except ApiException as e:
        print("Exception when calling UserApi->user_attribute_user_values: %s\n" % e) 
        
######################## END MAIN ##################################################        

############### CALL MAIN FUNCTION #########################

main()
    
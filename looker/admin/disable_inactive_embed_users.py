import lookerapi as looker
import time
from lookerapi.rest import ApiException
from pprint import pprint
import os

base_url = os.environ.get("looker_prod_base_url")
client_id =  os.environ.get("looker_api_client_id")
client_secret = os.environ.get("looker_api_client_secret")


# instantiate Auth API
unauthenticated_client = looker.ApiClient(base_url)
unauthenticated_authApi = looker.ApiAuthApi(unauthenticated_client)

# authenticate client
token = unauthenticated_authApi.login(client_id=client_id, client_secret=client_secret)
client = looker.ApiClient(base_url, 'Authorization', 'token ' + token.access_token)

# instantiate User API client
userApi = looker.UserApi(client)
me = userApi.me();
#print(me)

try: 
    # Delete Users in the list of the below file
    f = open("prod_users_to_disable.txt", "r")
    for x in f:
        print(x.rstrip())
        user_id = x.rstrip()
        api_response = userApi.delete_user(user_id)
        pprint(api_response)
except ApiException as e:
    print("Exception when calling UserApi->delete_user: %s\n" % e)


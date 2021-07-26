import lookerapi as looker
from lookerapi.rest import ApiException
from pprint import pprint

base_url = os.environ.get("prod_looker_base_url")
client_id = os.environ.get("prod_looker_client_id")
client_secret = os.environ.get("prod_looker_client_secret")

unauthenticated_client = looker.ApiClient(base_url)
unauthenticated_authApi = looker.ApiAuthApi(unauthenticated_client)

token = unauthenticated_authApi.login(client_id=client_id, client_secret=client_secret)
client = looker.ApiClient(base_url, 'Authorization', 'token ' + token.access_token)

userApi = looker.UserApi(client)
me = userApi.me();
print(me)


try: 
    # Delete lis of Users in the file 
    f = open("stage_users_to_disable.txt", "r")
    for x in f:
        print(x.rstrip())
        user_id = x.rstrip()
        api_response = userApi.delete_user(user_id)
        pprint(api_response)
except ApiException as e:
    print("Exception when calling UserApi->delete_user: %s\n" % e)


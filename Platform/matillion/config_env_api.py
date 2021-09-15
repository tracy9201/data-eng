import json
import logging
import os
import time

import requests

params = {'projectName': 'Opul'}
user_id = os.environ.get("matillion_user_id")
pwd = os.environ.get("matillion_pwd")

config_json_obj = json.load(open('config.json'))

def get_reponse(url, request="post"):
    if request == "get":
        response = requests.get(url, auth=(user_id, pwd), params=params, verify=False)
    else:
        response = requests.post(url, auth=(user_id, pwd), params=params, verify=False)
    return response.text

def fill_url_data(config_object, env_url):
    urls_values_arr = []
    for envkey, envVarDict in config_object.iteritems():
        for var, value in envVarDict.iteritems():
            urls_values_arr.append((envkey, var, env_url.format(envkey, var), value))
    
    return urls_values_arr

def main():
    logging.basicConfig(filename='Matillion_fullsync.log', format='%(asctime)s %(levelname)-8s %(message)s',
                        level=logging.INFO, datefmt='%Y-%m-%d %H:%M:%S')
    logging.info('Full sync process started')

    url_pattern = "http://matilliondev.eng.hintmd.com/rest/v1/group/name/OPUL/project/name/Opul/environment/name/{}/variable/name/{}/set/value/"
    urls_values = fill_url_data(config_json_obj, url_pattern)

    for envkey, var, env_url, value in urls_values:
        logging.info("Setting for enviornment {} the env variable {} to {}. Using url {}".format(envkey, var, value, env_url))
        env_data = get_reponse(env_url + value)
        logging.info(env_data)


if __name__ == '__main__':
    main()
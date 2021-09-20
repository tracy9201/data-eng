import json
import logging
import os
import time

import requests

user_id = os.environ.get("matillion_user_id")
pwd = os.environ.get("matillion_pwd")

config_json_obj = json.load(open('config.json'))

def get_reponse(url, params, request="post"):
    if request == "get":
        response = requests.get(url, auth=(user_id, pwd), params=params, verify=False)
    else:
        response = requests.post(url, auth=(user_id, pwd), params=params, verify=False)
    return response.text

def fill_url_data(config_object, env_url):
    urls_values_arr = []

    try:
        for envkey, envVarDict in config_object.iteritems():

            # get global params for env key
            group = get_global_param_by_key(config_object, envkey, 'group')
            projectName = get_global_param_by_key(config_object, envkey, 'projectName')
            hostname = get_global_param_by_key(config_object, envkey, 'hostname')        

            for globalParam, paramValue in envVarDict.iteritems():
                for var, value, in paramsDict.iteritems():
                    urls_values_arr.append((envkey, var, env_url.format(hostname, group, projectName, envkey, var), value))
    except Exception as e:
        logging.error("ERROR:{}".format(e))
        raise 

    return urls_values_arr

def get_global_param_by_key(config_object, envkey, parameter):
    for key, envVarDict in config_object.iteritems():
        if key == envkey:
            for globalParam, paramValue in envVarDict.iteritems():
                if globalParam == parameter:
                    return paramValue

def main():
    logging.basicConfig(filename='Matillion_fullsync.log', format='%(asctime)s %(levelname)-8s %(message)s',
                        level=logging.INFO, datefmt='%Y-%m-%d %H:%M:%S')
    logging.info('Full sync process started')

    url_pattern = "http://{}/rest/v1/group/name/{}/project/name/{}/environment/name/{}/variable/name/{}/set/value/"
    urls_values = fill_url_data(config_json_obj, url_pattern)

    try:
    
        for envkey, var, env_url, value in urls_values:

            logging.info("Setting for enviornment {} the env variable {} to {}. Using url {}".format(envkey, var, value, env_url))
            params = {'projectName': projectName}
            env_data = get_reponse(env_url + value, params)
            logging.info(env_data)

    except Exception as e:
        logging.error("ERROR:{}".format(e))
        raise 


if __name__ == '__main__':
    main()
import json
import logging
import os
import time
import boto3
import base64
from botocore.exceptions import ClientError
import requests

user_id = os.environ.get("matillion_user_id")
pwd = os.environ.get("matillion_pwd")

mapping_json = json.load(open('map_env_ssm.json'))
config_json_obj = json.load(open('config.json'))

def get_reponse(url, params, request="post"):
    if request == "get":
        response = requests.get(url, auth=(user_id, pwd), params=params, verify=False)
    else:
        response = requests.post(url, auth=(user_id, pwd), params=params, verify=False)
    return response.text

def get_value_by_key_from_ssm(key):

    secret = None
    region_name = "us-west-2"

    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=key
        )
    except ClientError as e:
        logging.warning('SSM key {} is not found in parameter store'.format(key))
        raise e
    else:
        if 'SecretString' in get_secret_value_response:
            secret = get_secret_value_response['SecretString']
        elif 'String' in get_secret_value_response:
            secret = get_secret_value_response['SecretString']
        else:
            secret = base64.b64decode(get_secret_value_response['SecretBinary'])
    return secret

def get_value_from_ssm(var):
    
    key = get_ssm_key_from_mapping(var)   
    return get_value_by_key_from_ssm(key) 

def get_ssm_key_from_mapping(var):
    
    ssmKey = None
    try:
        ssmKey = mapping_json[var]
    except KeyErrror as e:
        logging.warning('Environment variable {} is not found in mapping file'.format(var))

    return ssmKey
        


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
                    value_ssm = get_value_from_ssm(var)
                    value = value if value_ssm is None else value_ssm 
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
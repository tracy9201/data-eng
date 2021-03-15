import json
import logging
import os
import time

import requests

params = {'projectName': 'Opul'}
user_id = os.environ.get("matillion_user_id")
pwd = os.environ.get("matillion_pwd")


def get_reponse(url, request="post"):
    if request == "get":
        response = requests.get(url, auth=(user_id, pwd), params=params, verify=False)
    else:
        response = requests.post(url, auth=(user_id, pwd), params=params, verify=False)
    return response.text


def wait_for_running_tasks_to_complete(tasks_url):
    running = True
    tasks_response = get_reponse(tasks_url, "get")
    tasks_data = json.loads(tasks_response)
    if not tasks_data:
        running = False

    while running:
        time.sleep(10)
        logging.info("sleep 10")
        running = wait_for_running_tasks_to_complete(tasks_url)
        if not running:
            break


def main():
    logging.basicConfig(filename='Matillion_fullsync.log', format='%(asctime)s %(levelname)-8s %(message)s',
                        level=logging.INFO, datefmt='%Y-%m-%d %H:%M:%S')
    logging.info('Full sync process started')

    logging.info("Setting the envSQS flag to 0 to stop from auto running")
    env_url = "http://matilliondev.eng.hintmd.com/rest/v1/group/name/OPUL/project/name/Opul/environment/name/dev-opul/variable/name/envSQSFlag/set/value/"
    env_data = get_reponse(env_url + "0")
    logging.info(env_data)
    tasks_url = 'http://matilliondev.eng.hintmd.com/rest/v0/tasks?projectName=Opul'
    wait_for_running_tasks_to_complete(tasks_url)

    job_url = "http://matilliondev.eng.hintmd.com/rest/v1/group/name/OPUL/project/name/Opul/version/name/default/job/name/"
    env_name = "/run?environmentName=dev-opul"

    logging.info("Start Orchestration for Full Load")
    url = job_url + "fullLoadOpul" + env_name
    data = get_reponse(url)
    logging.info(data)
    wait_for_running_tasks_to_complete(tasks_url)

    logging.info("Start Orchestration for Creating DWH Tables")
    url = job_url + "Create DWH tables" + env_name
    data = get_reponse(url)
    logging.info(data)
    dict_create_dwh = json.loads(data)
    wait_for_running_tasks_to_complete(tasks_url)

    logging.info("setting the envSQS flag back to 1")
    env_data = get_reponse(env_url + "1")
    logging.info(env_data)

    logging.info("Start Orchestration for Opul Reporting")
    if dict_create_dwh['success']:
        url = job_url + "Opul Reporting" + env_name
        data = get_reponse(url)
        logging.info(data)
    logging.info('Full sync process Finished')


if __name__ == '__main__':
    main()


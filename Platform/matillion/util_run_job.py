import argparse
import requests

headers = {'Content-Type': 'application/json',}

parser = argparse.ArgumentParser(description='Personal information')
parser.add_argument('--instance_address', dest='instance_address', type=str, help='Instance Name')
parser.add_argument('--group_name', dest='group_name', type=str, help='Group Name')
parser.add_argument('--project_name', dest='project_name', type=str, help='Project Name')
parser.add_argument('--version_name', dest='version_name', type=str, help='Version Name')
parser.add_argument('--orchestration_job_name', dest='orchestration_job_name', type=str, help='Orchestration Job Name')
parser.add_argument('--environment_name', dest='environment_name', type=str, help='Env Name')
parser.add_argument('--data', dest='data', type=str, help='Specific Data that should be added to job')

parser.add_argument('--api_user', dest='api_user', type=str, help='API User Name')
parser.add_argument('--api_user_password', dest='api_user_password', type=str, help='API User password')

args = parser.parse_args()

instance_address = args.instance_address
group_name = args.group_name
project_name = args.project_name
version_name = args.version_name
orchestration_job_name = args.orchestration_job_name
environment_name = args.environment_name
api_user = args.api_user
api_user_password = args.api_user_password
data = args.data

response = requests.post('http://{}/rest/v1/group/name/{}/project/name/{}/version/name/{}/job/name/{}/run?environmentName={}'
    .format(instance_address, group_name, project_name, version_name, orchestration_job_name, environment_name), headers=headers, data=data, auth=(api_user, api_user_password))

print(response)

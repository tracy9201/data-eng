import requests
import json

url = "https://revancetherapeuticsinc.webhook.office.com/webhookb2/" \
           "dcdbbec4-b354-438b-a404-2529ba2a62ab@48a554d3-8403-4f70-b360-9b01ba297b36/" \
           "IncomingWebhook/0b9f4e9e111f4c88978425b9d5c64839/" \
           "73b9015e-a687-4078-8c10-f27999ef627d"
payload = {
    "text": "Alerts is working"
}
headers = {
    'Content-Type': 'application/json'
}
response = requests.post(url, headers=headers, data=json.dumps(payload))
print(response.text.encode('utf8'))

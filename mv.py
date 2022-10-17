import requests
import json
import regex


eks_url = "http://localhost:8200/v1/sys/health"
sddc_url = "http://localhost:8200/v1/sys/health"

eks_version_request = requests.get(eks_url)
sddc_version_request = requests.get(sddc_url)

eks_rsponse = eks_version_request.json()
sddc_response = sddc_version_request.json()
print(json.dumps(eks_response['version']))
print(json.dumps(sddc_response['version']))

assert json.dumps(eks_response['version']) == json.dumps(sddc_response['version']), "Vault versions are are not the same"

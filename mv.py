import requests
import json
import regex


eks_url = "http://localhost:8200/v1/sys/health"
sddc_url = "http://localhost:8400/v1/sys/health"
message = "check"

eks_res = requests.get(eks_url)
sddc_res = requests.get(sddc_url)

eks_body = eks_res.json()
sddc_body = sddc_res.json()
m = regex.search('version(.+?)', message)
print(json.dumps(eks_body['version']))
print(json.dumps(sddc_body['version']))

assert json.dumps(eks_body['version']) == json.dumps(sddc_body['version'])

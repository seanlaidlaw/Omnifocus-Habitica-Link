#!/usr/local/bin/python

import requests
import string
import re
import sys


api_user = (sys.argv[1])
api_key = (sys.argv[2])

response = requests.get('https://habitica.com/api/v3/tasks/user/', headers={"x-api-user" : api_user, "x-api-key" : api_key}, params={"type" : "completedTodos"})


rawData = str(response.json())
rawData = rawData.replace('u\'notes\': u\'', '\n')
rawData = rawData.replace('\', u\'updatedAt', '\n')


taskID = re.findall('(?m)omnifocus:\/\/\/task\/(.*)$', rawData)

Output = str(taskID)
Output = Output.replace('[\'', '')
Output = Output.replace('\']', '')
Output = Output.replace('\', \'', '\n')

print(Output)
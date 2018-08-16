#!/usr/bin/env python2.7
#coding=utf-8

import json
import urllib2
import requests

url = "http://54.223.74.222/api_jsonrpc.php"
header = {"Content-Type":"application/json"}

data = json.dumps(
{
   "jsonrpc": "2.0",
   "method": "user.login",
   "params": {
   "user": "Admin",
   "password": "Zabbix"
},
"id": 0
})


request = urllib2.Request(url, data)
for key in header:
    request.add_header(key, header[key])

try:
    result = urllib2.urlopen(request)
except URLError as e:
    print "Auth Faild!",e.code
else:
    response = json.loads(result.read())
    result.close()

print "auth successful",response['result']

auth = response['result']


def getHosts(auth):


    data = {
        "jsonrpc": "2.0",
        "method": "host.get",
        "params": {
            "output": [
                "hostid",
                "host"
            ],
            "selectInterfaces": [
                "interfaceid",
                "ip"
            ]
        },
        "id": 2,
        "auth": auth,

    }

    request = requests.post(url=url,headers=header,data=json.dumps(data))
    dict =  json.loads(request.content)
    # print dict['result']
    return dict['result']

def getProc(data):
    dict = {}
    list = data
    for i in list:
        host = i['host']
        inter = i['interfaces']
        for j in inter:
            ip = j['ip']
            dict[host] = ip
    return dict

def getData(dict):
    data = dict
    ip_list = []
    for key in data.keys():
        ip = data[key]
        ip_list.append(ip)
    ip_list = list(set(ip_list))
    ip_list.sort()
    return ip_list

def getGroup(ip_list):
    ip_group = {}
    ips = ip_list
    for i in ips:
        print i

if __name__ == "__main__":

    data = getHosts(auth)
    hosts = getProc(data)
    ip_list = getData(hosts)
    getGroup(ip_list)
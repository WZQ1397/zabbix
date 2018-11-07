#!/usr/bin/python
import json
import os
import sys


def discover():
    d = {}
    d['data'] = []
    with os.popen("docker ps -a --format {{.Names}}") as pipe:
         for line in pipe:
            info = {}
            info['{#CONTAINERNAME}'] = line.replace("\n", "")
            d['data'].append(info)
    print json.dumps(d)


def status(name, action):
    if action == "ping":
        cmd = 'docker inspect --format="{{.State.Running}}" %s' % name
        result = os.popen(cmd).read().replace("\n", "")
        if result == "true":
            print 1
        else:
            print 0
    else:
        cmd = 'docker stats %s --no-stream --format "{{.%s}}"' % (name, action)
        result = os.popen(cmd).read().replace("\n", "")
    if "%" in result:
        print float(result.replace("%", ""))
    else:
        print result

if name == "main":
    try:
        name, action = sys.argv[1], sys.argv[2]
        status(name, action)
    except IndexError as e:
        discover()

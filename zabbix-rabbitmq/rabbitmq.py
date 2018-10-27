#!/usr/bin/python
#coding:utf8
 
import requests
import sys
import json

class RabbitMQ:
 
 
    def __init__(self, user='guest', passwd='guest', server_ip='192.168.1.1', server_port=15670, vhost="device"):
 
        self.user = user
        self.password = passwd
        self.server_ip = server_ip
        self.server_port = server_port
        self.vhost = vhost
 
 
    def GetQueues(self):
        # 连接并获取RabbitMQ数据，如果传getallname参数代表获取所有的队列名称，主要用于自动发现，如果不等于，那就是获取指定队列的数据
        if sys.argv[1] != "getallname":
            connections = requests.get("http://{0}:{1}/api/queues/{2}/{3}".format(self.server_ip, self.server_port, self.vhost, sys.argv[1]), auth=(self.user, self.password))
        else:
            connections = requests.get("http://{0}:{1}/api/queues".format(self.server_ip, self.server_port), auth=(self.user, self.password))
        connections = connections.json()
        return connections
 

    def QueuesDataProcessing(self):
        # 判断队列是否正常工作 
        data = self.GetQueues()
        if "message_stats" in data:
            Ack = data["message_stats"]["ack_details"]["rate"]
            Total = data["messages"]
            
            if Total > 2000 and Ack == 0:
                return Total
            else:
                return 0
        else:
            # 当有些队列长时间没有数据传输，会没有任何数据显示，这里也返回0，代表没有问题
            return 0


    def GetAllQueuesName(self):
        # 获取所有队名称，格式化为Zabbix指定的格式，以便自动发现
        list1= []
        result = self.GetQueues()
        for n in range(len(result)):
            list1.append({"{#QUEUES_NAME}": result[n]["name"]})
        return list1
 
 
if __name__ == '__main__':
    mq = RabbitMQ()
    if sys.argv[1] != "getallname":
        result = mq.QueuesDataProcessing()
        print(result)
    else:
        result = mq.GetAllQueuesName()
        names = {"data": result}
        print(json.dumps(names))
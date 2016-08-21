from influxdb import InfluxDBClient
import requests
import xml.etree.ElementTree as ET
import time


def get_config():
	f_config = open('config/myconfig.cfg','r')
	line = f_config.readline()
	items=[]
	while  line!='':
		kind,name,numbers = line.split()
		for i in range(0,int(numbers)):
			items.append(name+str(i))
		line=f_config.readline()
	return items

def init():
	host='localhost'
	port=8086
	user='root'
	password='root'
	dbname='openhab'
	dbuser=''
	dbuser_password=''
	client = InfluxDBClient(host,port,user,password,dbname)
	items=get_config()
	return client,items


def get_data_from_restapi(itemsname):
	url = 'http://localhost:8080/rest/items/'+itemsname
	response = requests.get(url)
	items = ET.fromstring(response.text)
	# item>
	# <type>SwitchItem</type>
	# <name>Light</name>
	# <state>Uninitialized</state>
	# <link>http://localhost:8080/rest/items/Light</link>
	# </item>
	name = items[1].text
	state = items[2].text

	return name,state

# name,state = get_data_from_restapi("Light")
# print name

def send_data_to_influx(itemsname):
	print "get data of "+itemsname+" and send to influxdb"
	name,state = get_data_from_restapi(itemsname)

	global client

	json_body = [
	    {
	        "measurement": name,
	        "tags":{
	        	"serverid": 1
	        },
	        "fields": {
	            "status": state
	        }
	    }
	]

	client.write_points(json_body)
	print "done"
	

#main code 

client,items = init()
# client.create_database('openhab')
while True:
	for itemsname in items:
		send_data_to_influx(itemsname)

	time.sleep(5)
	
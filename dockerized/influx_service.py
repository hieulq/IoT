from influxdb import InfluxDBClient
import requests
import xml.etree.ElementTree as ET
import time
def init():
	host='localhost'
	port=8086
	user='root'
	password='root'
	dbname='openhab'
	dbuser=''
	dbuser_password=''
	client = InfluxDBClient(host,port,user,password,dbname)
	items=['Light','Fan','Door','Window','Temperature','Humidity']
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
	
#Build images
###Build image OpenHab
`docker build -t ngocluanbka/openhab:1.8 .`

###Build image for InfluxDB Cron
go to /InfluxDB_Cron
docker build -t ngocluanbka/influxcron:1.0 .


#Run Up System

###Start Mosquitto
sudo service mosquitto start

###Start OpenHab Container
`docker run 
-p 8080:8080 
-p 8443:8443 
-v $LINK/addons:/openhab/addons 
-v $LINK/configurations:/openhab/configurations 
ngocluanbka/openhab:1.8
`

###Start emulator
./start_sensor.sh

###Start InfluxDB Cron (get data from openhab and send to InfluxDB)


###Start InfluxDB Container
docker run -d -p 8083:8083 -p 8086:8086 -e ADMIN_USER="root" -e INFLUXDB_INIT_PWD="root" -e PRE_CREATE_DB="openhab" --name influxsrv tutum/influxdb:latest

###Start Grafana
docker run -d -p 3000:3000 \
-e HTTP_USER=admin \
-e HTTP_PASS=admin \
-e INFLUXDB_HOST=localhost \
-e INFLUXDB_PORT=8086 \
-e INFLUXDB_NAME=openhab \
-e INFLUXDB_USER=root \
-e INFLUXDB_PASS=root \
--link=influxsrv:influxsrv  \
grafana/grafana:2.0.2


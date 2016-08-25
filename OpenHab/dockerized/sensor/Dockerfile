FROM toke/mosquitto

MAINTAINER ngocluanbka

RUN apt-get -y update --fix-missing
RUN apt-get -y install mosquitto-clients python-mosquitto 

WORKDIR /home
COPY ["./config","/home/config"]
COPY ["./start_sensor.sh","/home"]

VOLUME ["/home/config"]

EXPOSE 1883 9001

CMD service mosquitto start && ./start_sensor.sh 5
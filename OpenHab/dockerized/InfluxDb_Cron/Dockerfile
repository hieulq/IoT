FROM python:2.7-alpine
MAINTAINER ngocluanbka

ENV OPENHAB_HOST=openhab
ENV INFLUX_HOST=influx
ENV POD_NAME=1
ENV TIMER=5

RUN pip install influxdb
WORKDIR /home
COPY ["./influx_cron.py","/home/influx_cron.py"]
COPY ["./config","/home/config"]

VOLUME ["/home/config"]

CMD python influx_cron.py
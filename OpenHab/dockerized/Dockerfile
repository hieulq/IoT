FROM java:openjdk-8-alpine
MAINTAINER ngocluanbka
RUN apk update && apk upgrade && \
    apk add --no-cache bash git
RUN git clone https://github.com/ngocluanbka/openhab.git
VOLUME ["./openhab/addons","./openhab/configurations"]
EXPOSE 8080 8443
CMD ["./openhab/start.sh"]

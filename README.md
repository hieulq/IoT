###Build image
`docker build -t ngocluanbka/openhab:1.8 .`

###to start container
`docker run &&\  
-p 8080:8080 &&\  
-p 8443:8443 &&\  
-v $LINK/addons:/openhab/addons &&\  
-v $LINK/configurations:/openhab/configurations &&\  
ngocluanbka/openhab:1.8 
`

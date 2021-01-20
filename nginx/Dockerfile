FROM nginx:latest

WORKDIR /opt

COPY create-self-signed-cert.sh ./

RUN /opt/create-self-signed-cert.sh

COPY default.conf /etc/nginx/conf.d/ 

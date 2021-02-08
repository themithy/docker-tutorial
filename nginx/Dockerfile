FROM nginx:latest

RUN apt-get update \
 && apt-get install -y --no-install-recommends iputils-ping dnsutils net-tools

COPY default.conf /etc/nginx/conf.d/ 

COPY certs /certs

EXPOSE 80
EXPOSE 443

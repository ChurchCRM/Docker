FROM nginx:alpine

COPY ./conf.d/* /etc/nginx/conf.d/

RUN  apk add --update --no-cache openssl

# SSL Generation
WORKDIR /etc/nginx/conf.d

ARG ssl
ARG country
ARG state
ARG locality
ARG organization
ARG organizationalunit
ARG email
ARG commonname

RUN if [ "$ssl" = "build" ]; then \
        openssl genrsa -des3 -passout pass:xxxx -out rootCA.key 2048; \
        openssl req -x509 -passin pass:xxxx -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/emailAddress=$email/CN=$commonname"; \
        openssl req -new -sha256 -nodes -out server.csr -newkey rsa:2048 -keyout server.key -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/emailAddress=$email/CN=$commonname"; \
        openssl x509 -req -passin pass:xxxx -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -days 3600 -sha256 -extfile v3.ext; \
    fi && \
    if [ "$ssl" = "none" ]; then \
      sed -i "s/listen 443 default_server ssl;/listen 80 default_server;/g" /etc/nginx/conf.d/churchcrm.conf; \
      sed -i "s/ssl_certificate \/etc\/nginx\/conf.d\/server.crt;//g" /etc/nginx/conf.d/churchcrm.conf; \
      sed -i "s/ssl_certificate_key \/etc\/nginx\/conf.d\/server.key;//g" /etc/nginx/conf.d/churchcrm.conf; \
    fi

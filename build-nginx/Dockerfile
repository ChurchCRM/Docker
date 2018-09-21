FROM nginx:alpine

VOLUME ["/etc/nginx/ssl","/root/.acme.sh"]

# SSL Generation
WORKDIR /etc/nginx/conf.d
RUN apk --update add curl openssl socat jq
COPY ./conf.d/* /etc/nginx/conf.d/
COPY ./ssl_setting/* /etc/nginx/
COPY ./ssl_setup /usr/local/bin
RUN chmod +x /usr/local/bin/ssl_setup

# Run the configsetup file on container start
ENTRYPOINT ["/usr/local/bin/ssl_setup"]
CMD ["nginx", "-g", "daemon off;"]

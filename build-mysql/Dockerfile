FROM alpine:latest
MAINTAINER ChurchCRM

RUN apk add --update \
        figlet \
        jq \
        mariadb \
        mariadb-client \
        ncurses && \
        addgroup mysql mysql && \
        mkdir /scripts

COPY ./startup /scripts/startup
RUN chmod +x /scripts/startup

EXPOSE 3306

ENTRYPOINT ["/scripts/startup"]


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

COPY ./presetup /usr/local/bin
COPY ./start_cmd /usr/local/bin
RUN chmod +x /usr/local/bin/presetup
RUN chmod +x /usr/local/bin/start_cmd

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/presetup"]
CMD ["/usr/local/bin/start_cmd"]

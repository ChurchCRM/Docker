FROM neilpang/nginx-proxy:alpine
MAINTAINER ChurchCRM

RUN apk add --update jq \
    && mkdir -p /scripts/pre-init.d

ENV TERM="xterm-color"
COPY ./entrypoint.sh /app
RUN chmod +x /app/*.sh
EXPOSE 443

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["forego", "start", "-r"]

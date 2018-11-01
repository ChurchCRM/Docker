FROM neilpang/nginx-proxy:alpine

RUN apk add --update jq

COPY ./docker-entrypoint.sh /app
RUN chmod +x /app/docker-entrypoint.sh
EXPOSE 443

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]

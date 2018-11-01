# Docker-nginx-letsencrypt-CRM(ChurchCRM)
## Prepare
1. if use letsencrypt dns mode, need modify secrets\dns_api.json, detail setting reference https://github.com/Neilpang/acme.sh/tree/master/dnsapi.
1. Modify secrets\ssl.json "host", "letsencrypt"."mode", "letsencrypt"."domain_parameter". detail setting reference https://github.com/Neilpang/acme.sh.
1. Modify secrets\crm_sql_secrets.json "MYSQL_ROOT_PWD" and "MYSQL_USER_PWD"
1. Update docker-compose.yml

## Install
1. docker-compose build
1. docker-compose up -d, then wait dns check ready and ChurchCRM install.
1. https://www.example.com, default user is admin, password is changeme.

## Debug
1. Modify docker-compose.yml, enabled debug setting.
1. Remove setting\nginx\vhost.d\default first line '#'
1. docker-compose down;docker-compose up -d
1. nginx and php debug information at ./log

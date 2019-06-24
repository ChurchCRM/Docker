#!/bin/bash

set -e

# parameters
export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/crm_secrets | jq -r '.mysql.MYSQL_ROOT_PASSWORD')
export MYSQL_USER=$(cat /run/secrets/crm_secrets | jq -r '.mysql.MYSQL_USER')
export MYSQL_PASSWORD=$(cat /run/secrets/crm_secrets | jq -r '.mysql.MYSQL_PASSWORD')
export MYSQL_DATABASE=$(cat /run/secrets/crm_secrets | jq -r '.mysql.MYSQL_DATABASE')

if [ $MYSQL_ROOT_PASSWORD = "changeme" ]; then
    red="$(tput setaf 1)"    # Red
    echo "${red}*********************************************"
    echo "${red}WARNING!!!"
    echo "${red}YOU DID NOT CHANGE THE MYSQL_ROOT_PASSWORD IN THE crm_secrets.json FILE!!!"
    echo "${red}This is EXTREMELY insecure. Please go back and change the password to something more secure and re-build your images by running docker-compose build"
    echo "${red}*********************************************"
    echo "$(tput sgr0)"
    exit 1
fi

if [ $MYSQL_PASSWORD = "changeme" ]; then
    red="$(tput setaf 1)"    # Red
    echo "${red}*********************************************"
    echo "${red}WARNING!!!"
    echo "${red}YOU DID NOT CHANGE THE MYSQL_PASSWORD IN THE crm_secrets.json FILE!!!"
    echo "${red}This is EXTREMELY insecure. Please go back and change the password to something more secure and re-build your images by running docker-compose build"
    echo "${red}*********************************************"
    echo "$(tput sgr0)"
    exit 1
fi

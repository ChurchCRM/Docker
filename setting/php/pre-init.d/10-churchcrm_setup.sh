#!/bin/bash

set -e

export TERM="xterm-color"

if ! [ -f ./CRM/churchcrm/index.php ]; then
    if [ "${RELEASE_VERSION}" == "latest" ]; then
        crmlatest=$(curl -s https://api.github.com/repos/churchCRM/CRM/releases/latest | grep "browser_download_url.*zip" | cut -d '"' -f 4);
    else
        crmlatest="https://github.com/ChurchCRM/CRM/releases/download/${RELEASE_VERSION}/ChurchCRM-${RELEASE_VERSION}.zip";
    fi
    wget -q $crmlatest
    unzip -q -o *.zip -d CRM/
    rm -rf *.zip
    if ! [ -d /mnt/logs ]; then
    mkdir /mnt/logs
    fi
    cp CRM/churchcrm/logs/.htaccess /mnt/logs
    rm -rf CRM/churchcrm/logs
    ln -s /mnt/logs CRM/churchcrm/logs 
    chown -R www-data:www-data CRM
fi

if ! [ -f ./CRM/churchcrm/Include/Config.php ]; then
    cp /var/www/CRM/churchcrm/Include/Config.php.example /var/www/CRM/churchcrm/Include/Config.php
    chown www-data:www-data /var/www/CRM/churchcrm/Include/Config.php
    chmod 777 /var/www/CRM/churchcrm/Include/Config.php

    # Import Docker Secrets
    MYSQL_USER=$(cat /run/secrets/crm_secrets | jq -r '.mysql.MYSQL_USER')
    MYSQL_PASSWORD=$(cat /run/secrets/crm_secrets | jq -r '.mysql.MYSQL_PASSWORD')
    MYSQL_DATABASE=$(cat /run/secrets/crm_secrets | jq -r '.mysql.MYSQL_DATABASE')

    if [ $MYSQL_PASSWORD = "changeme" ]; then
        red="$(tput setaf 1)"   # Red
        echo "${red}*********************************************"
        echo "${red}WARNING!!!"
        echo "${red}YOU DID NOT CHANGE THE MYSQL_PASSWORD IN THE crm_secrets.json FILE!!!"
        echo "${red}This is EXTREMELY insecure. Please go back and change the password to something more secure and re-build your images by running docker-compose build"
        echo "${red}*********************************************"
        echo "$(tput sgr0)"
        rm /var/www/CRM/churchcrm/Include/Config.php
        exit 1
    fi

    # Create ChurchCRM Config File
    sed -i "s/||DB_SERVER_NAME||/$MYSQL_DB_HOST/g" /var/www/CRM/churchcrm/Include/Config.php
    sed -i "s/||DB_SERVER_PORT||/3306/g" /var/www/CRM/churchcrm/Include/Config.php
    sed -i "s/||DB_NAME||/$MYSQL_DATABASE/g" /var/www/CRM/churchcrm/Include/Config.php
    sed -i "s/||DB_USER||/$MYSQL_USER/g" /var/www/CRM/churchcrm/Include/Config.php
    sed -i "s/||DB_PASSWORD||/$MYSQL_PASSWORD/g" /var/www/CRM/churchcrm/Include/Config.php
    sed -i "s/||URL||//g" /var/www/CRM/churchcrm/Include/Config.php
    sed -i "s/||ROOT_PATH||//g" /var/www/CRM/churchcrm/Include/Config.php
fi

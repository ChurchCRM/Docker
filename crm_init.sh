set -x

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    local val="$def"
    val="$(< "${!fileVar}")"
    export "$var"="$val"
}

download_crm() {
    local crmlatest;
    if [ "${CRM_RELEASE_VERSION}" == "latest" ]; then
        crmlatest=$(curl -s https://api.github.com/repos/churchCRM/CRM/releases/latest | grep "browser_download_url.*zip" | cut -d '"' -f 4);
    else
        crmlatest="https://github.com/ChurchCRM/CRM/releases/download/${CRM_RELEASE_VERSION}/ChurchCRM-${CRM_RELEASE_VERSION}.zip";
    fi
    cd /var/www/default \
    && rm -rf *.zip \
    && curl -O -L $crmlatest \
    && apt-get update \
    && apt-get install unzip \
    && unzip -q -o *.zip \
    && rm -f /var/www/default/churchcrm/Include/Config.php
}

if ! [ -d /var/www/default/churchcrm/ ]; then
    download_crm;
fi

if ! [ -f /var/www/default/churchcrm/index.php ]; then
    download_crm;
fi

if ! [ -f /var/www/default/churchcrm/Include/Config.php ]; then
    cp /var/www/default/churchcrm/Include/Config.php.example /var/www/default/churchcrm/Include/Config.php
    chmod 777 /var/www/default/churchcrm/Include/Config.php

    set +x
    file_env 'MYSQL_USER' 'churchcrm'
    file_env 'MYSQL_PASSWORD' 'churchcrm'

    # Create ChurchCRM Config File
    sed -i "s/||DB_SERVER_NAME||/mysql/g" /var/www/default/churchcrm/Include/Config.php
    sed -i "s/||DB_SERVER_PORT||/3306/g" /var/www/default/churchcrm/Include/Config.php
    sed -i "s/||DB_NAME||/$MYSQL_DATABASE/g" /var/www/default/churchcrm/Include/Config.php
    sed -i "s/||DB_USER||/$MYSQL_USER/g" /var/www/default/churchcrm/Include/Config.php
    sed -i "s/||DB_PASSWORD||/$MYSQL_PASSWORD/g" /var/www/default/churchcrm/Include/Config.php
    sed -i "s/||URL||//g" /var/www/default/churchcrm/Include/Config.php
    sed -i "s/||ROOT_PATH||//g" /var/www/default/churchcrm/Include/Config.php
    set -x
fi

/docker-entrypoint.sh
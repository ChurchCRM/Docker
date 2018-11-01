FROM php:fpm-alpine

RUN apk add --update \
        icu icu-dev \
        gettext gettext-dev \
        jq figlet ncurses \
        zip libzip libzip-dev \
        freetype freetype-dev \
        libjpeg-turbo libjpeg-turbo-dev \
        libpng libpng-dev \
        libmcrypt libmcrypt-dev \
        gcc make libc-dev autoconf && \
    docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure zip \
        --with-libzip && \
    docker-php-ext-install \
        intl gettext \
        mysqli pdo_mysql \
        exif \
        gd \
        zip \
        >/dev/null && \
        pecl install mcrypt-1.0.1 && \
        echo "extension=mcrypt.so" > /usr/local/etc/php/conf.d/mcrypt.ini && \
    apk del \
        icu-dev gettext-dev \
        freetype-dev libjpeg-turbo-dev libpng-dev \
        libzip-dev \
        libmcrypt-dev \
        gcc make libc-dev autoconf

COPY ./presetup /usr/local/bin
COPY ./php.ini /usr/local/etc/php/
RUN chmod +x /usr/local/bin/presetup

# Set work directory to the web host path
WORKDIR /var/www

# Run the configsetup file on container start
ENTRYPOINT ["/usr/local/bin/presetup"]
CMD ["php-fpm"]

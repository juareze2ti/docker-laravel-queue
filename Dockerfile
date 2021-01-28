FROM php:7.2-cli

RUN apt-get update

# Instalar php-pgsql
RUN apt-get install -y --allow-unauthenticated libpq-dev
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo pdo_pgsql

# Instalar php-soap
RUN apt-get install -y --allow-unauthenticated libxml2-dev
RUN docker-php-ext-install soap

# Instalar php-gd
RUN apt-get install -y --allow-unauthenticated libfreetype6-dev libjpeg62-turbo-dev libpng-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd

# Instalar php-zip
RUN docker-php-ext-install zip

# Instalar exif para arquivos
RUN docker-php-ext-install exif

# Instalar composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');"  \
    && mv composer.phar /usr/bin/composer

# Ext calendario
RUN docker-php-ext-install calendar \
    && docker-php-ext-configure calendar

# Ajusta configurações do php
RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

# Configura locale pt_BR.UTF-8
RUN apt-get install --allow-unauthenticated -y locales
RUN sed -i -e 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR:pt
ENV LC_ALL pt_BR.UTF-8

# Instalar unzip
RUN apt-get install --allow-unauthenticated -y unzip

WORKDIR /var/www

CMD ["sh", "-c", "php artisan queue:work redis --queue=$QUEUE --sleep=$SLEEP --tries=$TRIES --timeout=$TIMEOUT --delay=$DELAY --memory=$MEMORY"]

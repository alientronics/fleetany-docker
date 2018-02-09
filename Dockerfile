FROM php:7.0-apache

ENV DEBIAN_FRONTEND noninteractive

# Configure Apache and installs other services
RUN a2enmod rewrite \
    && apt-get update \
    && echo 'ServerName localhost' >> /etc/apache2/apache2.conf \
    && apt-get install -y curl git \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install extra php libraries
RUN docker-php-ext-install pdo pdo_mysql

# Add custom Apache config file
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

# Add project files
RUN git clone https://github.com/alientronics/fleetany-web /var/www/html/application

WORKDIR /var/www/html/application
RUN composer install --no-interaction --prefer-source
EXPOSE 80
CMD ["/run.sh"]

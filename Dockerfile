FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y apache2 \
    php8.1 \
    php8.1-curl \
    php8.1-gd \
    php8.1-mbstring \
    php8.1-mysql \
    libapache2-mod-php8.1
RUN apt-get install -y mariadb-server
RUN apt-get install -y git vim curl

RUN apt-get install -y php8.1-xml \
    php8.1-dom \
    php8.1-exif \
    php8.1-gettext

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite

RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

RUN echo "upload_max_filesize = 40M" >> /etc/php/8.1/apache2/php.ini && \
    echo "post_max_size = 40M" >> /etc/php/8.1/apache2/php.ini && \
    echo "memory_limit = 256M" >> /etc/php/8.1/apache2/php.ini && \
    echo "date.timezone = America/Montevideo" >> /etc/php/8.1/apache2/php.ini

COPY known.tar.gz /tmp/known.tar.gz
RUN tar -xzf /tmp/known.tar.gz -C /var/www/html/ --strip-components=1 && \
    rm /tmp/known.tar.gz

WORKDIR /var/www/html/

RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/

RUN rm /var/www/html/index.html

COPY config.ini /var/www/html/configuration/config.ini

VOLUME /var/www/html/Themes
VOLUME /var/www/html/Uploads
VOLUME /var/www/html/IdnoPlugins

COPY setup_mysql.sh /tmp/setup_mysql.sh
RUN chmod +x /tmp/setup_mysql.sh
    
EXPOSE 80 3306

COPY entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh
ENTRYPOINT ["/tmp/entrypoint.sh"]

ENV DEBIAN_FRONTEND=dialog
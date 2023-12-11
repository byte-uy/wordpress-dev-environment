FROM ubuntu:22.04

VOLUME [ "/var/www/html" ]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y
RUN apt-get install -y php8.1 php8.1-mysql php8.1-xml php8.1-gd php8.1-curl php8.1-mbstring
RUN apt-get install -y apache2 mariadb-server

RUN apt-get install -y wget
RUN wget https://wordpress.org/wordpress-6.4.2.tar.gz
RUN tar -xzf wordpress-6.4.2.tar.gz
RUN mv wordpress/* /var/www/html/
RUN chown -R www-data:www-data /var/www/html/
RUN rm wordpress-6.4.2.tar.gz
RUN rm -rf wordpress
RUN rm /var/www/html/index.html

RUN apt-get install -y vim

RUN a2enmod rewrite
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

RUN sed -i "s/upload_max_filesize = .*/upload_max_filesize = 50M/" /etc/php/8.1/apache2/php.ini
RUN sed -i "s/post_max_size = .*/post_max_size = 50M/" /etc/php/8.1/apache2/php.ini
RUN sed -i "s/memory_limit = .*/memory_limit = 256M/" /etc/php/8.1/apache2/php.ini

COPY ./wordpress.sql /tmp/wordpress.sql

RUN service mariadb start && \
    mariadb -e "CREATE DATABASE wordpress;" && \
    mariadb -e "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'password';" && \
    mariadb -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';" && \
    mariadb -e "FLUSH PRIVILEGES;"

RUN service mariadb start && mariadb -uwordpress -ppassword wordpress < /tmp/wordpress.sql

EXPOSE 80

CMD service mariadb start && apache2ctl -D FOREGROUND

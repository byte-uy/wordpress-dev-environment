# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set non-interactive installation to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list
RUN apt-get update -y

# Install PHP 8.1 and necessary PHP extensions for WordPress
RUN apt-get install -y php8.1 php8.1-mysql php8.1-xml php8.1-gd php8.1-curl php8.1-mbstring

# Install Apache and MariaDB
RUN apt-get install -y apache2 mariadb-server

# Install WordPress
RUN apt-get install -y wget
RUN wget https://wordpress.org/wordpress-6.4.2.tar.gz
RUN tar -xzf wordpress-6.4.2.tar.gz
RUN mv wordpress /var/www/html/wordpress
RUN chown -R www-data:www-data /var/www/html/wordpress
RUN rm wordpress-6.4.2.tar.gz

RUN apt-get install -y vim

# Configure Apache
RUN a2enmod rewrite
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Configure PHP for WordPress
RUN sed -i "s/upload_max_filesize = .*/upload_max_filesize = 50M/" /etc/php/8.1/apache2/php.ini
RUN sed -i "s/post_max_size = .*/post_max_size = 50M/" /etc/php/8.1/apache2/php.ini
RUN sed -i "s/memory_limit = .*/memory_limit = 256M/" /etc/php/8.1/apache2/php.ini

# Configure MariaDB
RUN service mariadb start && \
    mariadb -e "CREATE DATABASE wordpress;" && \
    mariadb -e "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'password';" && \
    mariadb -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';" && \
    mariadb -e "FLUSH PRIVILEGES;"

# Expose Apache
EXPOSE 80

# Start Apache and MariaDB services
CMD service mariadb start && apache2ctl -D FOREGROUND

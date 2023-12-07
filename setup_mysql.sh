#!/bin/bash
mysql -e "CREATE DATABASE KnownDB;"
mysql -e "CREATE USER 'knownuser'@'localhost' IDENTIFIED BY 'password';"
mysql -e "GRANT ALL PRIVILEGES ON KnownDB.* TO 'knownuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
mysql KnownDB < /var/www/html/warmup/schemas/mysql/mysql.sql
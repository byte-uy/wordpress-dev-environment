#!/bin/bash
service mariadb start
/tmp/setup_mysql.sh
rm /tmp/setup_mysql.sh

service apache2 start
tail -f /dev/null
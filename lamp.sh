
#!/bin/bash


#Description: Webserver config
#Author: Serge , Jun 2020



## Update system

echo "Updating the system and this will take a while please wait..."

yum update -y

## Package install

rm -rf /var/www/html/*
rm -rf /tmp/wordpress*

yum install httpd php mariadb-server php-mysql php-gd wget -y

systemctl start httpd
systemctl enable httpd

echo " Apache installed successfully please try it on the browser"

## Open port 80
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload

## Create Php file to check php installation

echo "<?php phpinfo(); ?>"  >> /var/www/html/info.php

## Wordpress install

cd /tmp

wget https://wordpress.org/wordpress-5.1.1.tar.gz

tar -xf wordpress-5.1.1.tar.gz

cp -r wordpress/* /var/www/html/

mkdir /var/www/html/wp-content/uploads

cd /var/www/html

cp wp-config-sample.php  wp-config.php


## Database config
systemctl start mariadb
systemctl enable mariadb

echo "We will need some few information from you to configure the database. please hit enter when you are ready.."

read 

echo " Please enter your database name:  "
read db
echo " Please enter your database user:  "
read dbuser
echo " Please enter the password:  "
read dbp

sed -i "s/^define( 'DB_NAME',.*/define( 'DB_NAME', '${db}' );/" /var/www/html/wp-config.php
sed -i "s/^define( 'DB_USER',.*/define( 'DB_USER', '${dbuser}' );/" /var/www/html/wp-config.php
sed -i "s/^define( 'DB_PASSWORD',.*/define( 'DB_PASSWORD', '${dbp}' );/" /var/www/html/wp-config.php

echo "configuration successful"

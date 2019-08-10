#!/bin/bash
# Install Apache
sudo apt update
sudo apt install apache2
# Installing Mysql
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5072E1F5
sudo cat <<- EOF > /etc/apt/sources.list.d/mysql.list
deb http://repo.mysql.com/apt/ubuntu/ trusty mysql-5.7
EOF
sudo apt-get update
sudo apt-get install -y mysql-server-5.7
sudo mysql < /home/ubuntu/mysql.sql
---------
#Installing PHP
sudo apt-add-repository ppa:ondrej/php -y
sudo apt-get update && sudo apt-get install php7.0 php7.0-mysql libapache2-mod-php7.0 php7.0-cli php7.0-cgi php7.0-gd -y
# Installing Wordpress
cd ~ && wget http://wordpress.org/latest.tar.gz && tar xzvf latest.tar.gz
sudo apt-get update && sudo apt-get install php-dev php-ssh2
cd ~/wordpress
cp wp-config-sample.php wp-config.php
vi wp-config.php -c ':49,56s/^/#/' -c ':wq!'
curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> ./wordpress/wp-config.php
vi wp-config.php -c '%s/database_name_here/wordpress/g' -c '%s/username_here/root/g' -c '%s/password_here/root/g' -c ':wq!'
sudo rsync -avP ~/wordpress/ /var/www/html/
cd /var/www/html && sudo rm index.html
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo service apache2 restart

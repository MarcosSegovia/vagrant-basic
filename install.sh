#!/bin/bash
 
# hit spanish repos
sed -i 's|//us\.\(archive\.ubuntu\)|//es.\1|g' /etc/apt/sources.list
sudo apt-get update
sudo apt-get install -y vim curl python-software-properties
sudo apt-get update

# php 5.5 & mysql & apache
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo add-apt-repository -y ppa:ondrej/php5-5.6
sudo apt-get update
sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql git-core php-pear
mysql -h localhost -uroot -proot -e "CREATE DATABASE world;"
mysql --user=root --password=root world < /var/sqldump/databases.sql

# php config
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

# apache config
#sudo rm -rf /var/www/html
#sudo ln -fs /vagrant/public /var/www/html
# sudo ln -fs /vagrant /var/www
sudo a2enmod rewrite
sudo sed -i 's/APACHE_RUN_USER=.*/APACHE_RUN_USER=vagrant/g' /etc/apache2/envvars
sudo sed -i 's/APACHE_RUN_GROUP=.*/APACHE_RUN_GROUP=www-data/g' /etc/apache2/envvars
sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
sudo service apache2 restart

# composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# memcached
sudo apt-get install -y memcached php5-memcached 
sudo pecl install memcache
echo "extension=memcache.so" | sudo tee /etc/php5/conf.d/memcache.ini

#imagick
sudo apt-get update
sudo apt-get install -y php5-imagick
sudo echo "extension=imagick.so" >> /etc/php5/apache2/php.ini

# sculpin
curl -O https://download.sculpin.io/sculpin.phar
chmod +x sculpin.phar
sudo mv sculpin.phar /usr/local/bin/sculpin

#phpunit
wget https://phar.phpunit.de/phpunit.phar
chmod +x phpunit.phar
sudo mv phpunit.phar /usr/local/bin/phpunit

# mongo
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get update
sudo apt-get install -y mongodb-10gen php5-dev php5-cli
sudo pecl install mongo
cat << EOF | sudo tee -a /etc/php5/mods-available/mongo.ini
EOF
sudo echo "extension=mongo.so" >> /etc/php5/apache2/php.ini
echo "extension=mongo.so" | sudo tee /etc/php5/cli/php.ini
sudo service apache2 restart

# xdebug
mkdir /var/log/xdebug
chown www-data:www-data /var/log/xdebug
pecl install xdebug
sudo apt-get install -y php5-xdebug
cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.remote_enable = on
xdebug.remote_handler = dbgp
xdebug.remote_connect_back = on
EOF
sudo service apache2 restart

#redis

sudo wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make



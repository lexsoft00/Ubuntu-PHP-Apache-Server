echo "Please enter the network interface name(ex:eth1):"
read network_interface_name
echo "Please enter the ip (ex:192.168.59.104):"
read network_ip
echo "Please the user name that will have access to /home/public_html (ex:notroot):"
read user
echo "Please insert the PHP versiune (ex:7.0)"
read PHP_VERSION

echo "You entered :"
echo "Network interface name: $network_interface_name"
echo "Ip Address:             $network_ip"
echo "User:                   $user"
echo "If this is correct press ENTER otherside press CONTROL+C"
read RESP

#setup network interface
echo 'setup network interface';
echo ' ' >> /etc/network/interfaces
echo "auto $network_interface_name" >> /etc/network/interfaces
echo "iface $network_interface_name inet static" >> /etc/network/interfaces
echo "        address $network_ip" >> /etc/network/interfaces
echo '        netmask 255.255.255.0' >> /etc/network/interfaces


#Install application
apt-get update && apt-get -y upgrade 
apt-get -y install python-software-properties 
apt-get install -y software-properties-common 
apt-get install -y sendmail
locale-gen en_US.UTF-8 
export LANG=en_US.UTF-8 
apt-get update && apt-get -y upgrade 
apt-get install -y sendmail
apt-get install -y supervisor
apt-get install -y vim
apt-get install -y less
apt-get install -y ntp
apt-get install -y net-tools
apt-get install -y inetutils-ping
apt-get install -y curl
apt-get install -y git
apt-get install -y mysql-client
apt-get install -y mysql-client-core
apt-get install -y mysql-server 
apt-get install -y apache2 
apt-get install -y pwgen 
apt-get install -y python-setuptools 
apt-get install -y vim-tiny
apt-get install -y memcached 
apt-get install -y libapache2-mod-php
apt-get install -y php-mysql 
apt-get install -y php-json 
apt-get install -y php-apc 
apt-get install -y php-gd 
apt-get install -y php-mcrypt 
apt-get install -y php-intl 
apt-get install -y php-dev 
apt-get install -y php-mbstring 
apt-get install -y php-curl 
apt-get install -y php-xml 
apt-get install -y php-soap
apt-get install -y php-zip
apt-get install -y php-memcache 
apt-get install -y php-pear 
apt-get install -y mc 
apt-get install -y php-xdebug
apt-get install -y php
apt-get install -y php-pear
apt-get install -y php-dev
apt-get install -y php-cli
apt-get update && apt-get -y upgrade && apt-get clean
cd
#PHP_VERSION=$(php --version | tail -n 1 | sed -e 's/^[[:space:]]*//' | cut -d " " -f 4 | cut -c 2,3,4)

#Install composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#Install page speed
#wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb
#sudo dpkg -i mod-pagespeed-*.deb
#apt-get -f -y install
#rm mod-pagespeed-*.deb
#service apache2 restart


#Patch php.ini
sed -i "s/allow_url_fopen = On/allow_url_fopen = Off/g" /etc/php/$PHP_VERSION/apache2/php.ini

#Apache Configuration
ln -s /etc/apache2/mods-available/rewrite.load  /etc/apache2/mods-enabled/rewrite.load
ln -s /etc/apache2/mods-available/expires.load  /etc/apache2/mods-enabled/expires.load

#Server file fonfiguration
mkdir /home/public_html
mkdir /home/public_html/default
chown $user:$user -hR /home/public_html
usermod -a -G www-data $user
chmod -R 2775 /home/public_html
sed -i "s#DocumentRoot /var/www/html#DocumentRoot /home/public_html/default#g" /etc/apache2/sites-available/000-default.conf
sed -i "s#<Directory /var/www/>#<Directory /home/public_html/>#g" /etc/apache2/apache2.conf
service apache2 restart

cd
wget https://files.phpmyadmin.net/phpMyAdmin/4.5.3.1/phpMyAdmin-4.5.3.1-english.tar.gz
tar -zxvf phpMyAdmin-4.5.3.1-english.tar.gz
cp -r phpMyAdmin-4.5.3.1-english /usr/share/phpmyadmin
rm -fr phpMyAdmin-4.5.3.1-english
rm phpMyAdmin-4.5.3.1-english.tar.gz
chown $user:$user -hR /usr/share/phpmyadmin
rm -fr phpMyAdmin-4.5.3.1
mkdir /etc/phpmyadmin/
touch /etc/phpmyadmin/apache.conf

echo '# phpMyAdmin default Apache configuration' >>  /etc/phpmyadmin/apache.conf
echo 'Alias /phpmyadmin /usr/share/phpmyadmin' >>  /etc/phpmyadmin/apache.conf
echo '<Directory /usr/share/phpmyadmin>' >>  /etc/phpmyadmin/apache.conf
echo '        Options FollowSymLinks' >>  /etc/phpmyadmin/apache.conf
echo '        DirectoryIndex index.php' >>  /etc/phpmyadmin/apache.conf
echo '        <IfModule mod_php5.c>' >>  /etc/phpmyadmin/apache.conf
echo '                AddType application/x-httpd-php .php' >>  /etc/phpmyadmin/apache.conf
echo '                php_flag magic_quotes_gpc Off' >>  /etc/phpmyadmin/apache.conf
echo '                php_flag track_vars On' >>  /etc/phpmyadmin/apache.conf
echo '                php_flag register_globals Off' >>  /etc/phpmyadmin/apache.conf
echo '                php_admin_flag allow_url_fopen Off' >>  /etc/phpmyadmin/apache.conf
echo '                php_value include_path .' >>  /etc/phpmyadmin/apache.conf
echo '                php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp' >>  /etc/phpmyadmin/apache.conf
echo '                php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/javascript/' >>  /etc/phpmyadmin/apache.conf
echo '        </IfModule>' >>  /etc/phpmyadmin/apache.conf
echo '</Directory>' >>  /etc/phpmyadmin/apache.conf
echo "# Disallow web access to directories that don't need it" >>  /etc/phpmyadmin/apache.conf
echo '<Directory /usr/share/phpmyadmin/libraries>' >>  /etc/phpmyadmin/apache.conf
echo '    Order Deny,Allow' >>  /etc/phpmyadmin/apache.conf
echo '    Deny from All' >>  /etc/phpmyadmin/apache.conf
echo '</Directory>' >>  /etc/phpmyadmin/apache.conf
echo '<Directory /usr/share/phpmyadmin/setup/lib>' >>  /etc/phpmyadmin/apache.conf
echo '    Order Deny,Allow' >>  /etc/phpmyadmin/apache.conf
echo '    Deny from All' >>  /etc/phpmyadmin/apache.conf
echo '</Directory>' >>  /etc/phpmyadmin/apache.conf
ln -s /etc/phpmyadmin/apache.conf  /etc/apache2/conf-enabled/phpmyadmin.conf

#add xdebug configurations
PHP_VERSION="7.0"
echo '' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini
echo '' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini
echo 'xdebug.remote_enable=1' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini
echo 'xdebug.remote_handler=dbgp' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini
echo 'xdebug.remote_port=9000' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini
echo ';xdebug.remote_host=10.58.9.253' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini
echo 'xdebug.remote_connect_back = 1' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini
echo 'xdebug.scream=0' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini
echo ';xdebug.cli_color=1' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini
echo ';xdebug.show_local_vars=1' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini
echo ';xdebug.idekey="PHP_DEBUG"' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini
echo 'xdebug.remote_log = /tmp/xdebug.log' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini
echo 'xdebug.remote_mode=req' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini
echo 'xdebug.max_nesting_level=256' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini
echo ';xdebug.profiler_enable = 0;' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini
echo ';xdebug.profiler_output_dir = "/tmp"' >> /etc/php/$PHP_VERSION/apache2/conf.d/20-xdebug.ini


service apache2 restart

# Download latest stable release using the code below or browse to github.com/drush-ops/drush/releases.
wget http://files.drush.org/drush.phar
# Or use our upcoming release: wget http://files.drush.org/drush-unstable.phar  

# Test your install.
php drush.phar core-status

# Rename to `drush` instead of `php drush.phar`. Destination can be anywhere on $PATH. 
chmod +x drush.phar
sudo mv drush.phar /usr/local/bin/drush

sudo update-rc.d mysql defaults 

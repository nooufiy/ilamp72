#!/bin/bash

#chmod +x ilamp.sh
#chmod 755 ilamp.sh

#sed -i -e 's/\r$//' ilamp.sh
#./ilamp.sh

echo "-"
echo "-"
echo "========================="
echo "LAMP Begin Installation"
echo "========================="
echo "-"
echo "-"

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY*
yum -y install epel-release
yum -y install nano
yum -y install htop
yum -y install unzip
yum -y install zip

# echo "-"
# echo "-------------------------"
# echo "Install MariaDB"
# echo "-------------------------"
# echo "-"

# yum -y install mariadb-server mariadb
# systemctl start mariadb.service
# systemctl enable mariadb.service
# mysql_secure_installation

echo "-"
echo "-------------------------"
echo "Install Apache"
echo "-------------------------"
echo "-"

yum -y install httpd
systemctl start httpd.service
systemctl enable httpd.service

echo "-"
echo "-------------------------"
echo "Install Utility"
echo "-------------------------"
echo "-"

firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload
rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install yum-utils
yum update -y
yum-config-manager --enable remi-php72
yum -y install php php-opcache
systemctl restart httpd.service
yum -y install php-mysqlnd php-pdo
yum -y install php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-soap curl curl-devel
#yum -y install php72 php72-php-fpm php72-php-mysqlnd php72-php-opcache php72-php-xml php72-php-xmlrpc php72-php-gd php72-php-mbstring php72-php-json curl curl-devel php-pdo
systemctl restart httpd.service
yum -y install wget
yum -y install httpd mod_ssl openssh
yum -y install screen
yum install  bzip2 -y
systemctl restart  httpd.service
wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz 
tar xfz ioncube_loaders_lin_x86-64.tar.gz 
cp -R ioncube/ioncube_loader_lin_7.2.so /usr/lib64/php/modules 
#nano /etc/php.ini 
service httpd restart 
yum install php-pspell -y 
php -m | grep "pspell" 
service httpd restart 
yum install aspell-en -y 
wget ftp://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-2017.08.24-0.tar.bz2
tar xvjf aspell6-en-2017.08.24-0.tar.bz2 
cd aspell6-en-2017.08.24-0 
./configure 
make 
make install 
cd .. 
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
php wp-cli.phar --info
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
service httpd restart

cp -R httpd.conf /etc/httpd/conf/httpd.conf
cp -R php72.ini /etc/php.ini
> /var/www/html/index.html
systemctl restart  httpd.service

echo "-"
echo "-------------------------"
echo "Install Iptables"
echo "-------------------------"
echo "-"

yum -y install iptables-services
#iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set --name SSH -j ACCEPT
#iptables -A INPUT -p tcp --dport 22 -m recent --update --seconds 600 --hitcount 3 --rttl --name SSH -j LOG --log-prefix "SSH_BruteForce_Brooh"
#iptables -A INPUT -p tcp --dport 22 -m recent --update --seconds 600 --hitcount 3 --rttl --name SSH -j DROP
#iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT

iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --set --name SSH-iki
iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent  --update --seconds 60 --hitcount 5 --name SSH -j DROP
iptables -I INPUT -p tcp --dport 80 -m state --state NEW -m recent --set --name DDOS-HHTP-iki
iptables -I INPUT -p tcp --dport 80 -m state --state NEW -m recent --update --seconds 5 --hitcount 20 --name DDOS-HHTP -j DROP
iptables -I INPUT -p tcp --dport 443 -m state --state NEW -m recent --set --name DDOS-HHTPS-iki
iptables -I INPUT -p tcp --dport 443 -m state --state NEW -m recent --update --seconds 5 --hitcount 20 --name DDOS-HHTPS -j DROP

service iptables save
yum install iptables-persistent -y
iptables-save
systemctl enable iptables
service iptables restart

echo "-"
echo "-------------------------"
echo "Install Fail2ban"
echo "-------------------------"
echo "-"

yum install fail2ban fail2ban-systemd -y
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
cp -R jail.local /etc/fail2ban/jail.local
systemctl enable fail2ban
service fail2ban restart

#systemctl enable firewalld
#systemctl restart firewalld
systemctl stop firewalld
systemctl disable firewalld

sudo chcon -t httpd_sys_rw_content_t /var/www/html -R
sudo setsebool -P httpd_can_network_connect 1

echo "-"
echo "-------------------------"
echo "Install SSH2"
echo "-------------------------"
echo "-"

yum -y install gcc php71w-devel libssh2 libssh2-devel;cd /opt/;wget https://github.com/Sean-Der/pecl-networking-ssh2/archive/php7.zip;unzip php7.zip;cd pecl-networking-ssh2-php7/;yum -y install php-devel pcre-devel gcc make;sudo phpize;./configure;make;make install;echo "extension=ssh2.so" >  /etc/php.d/ssh2.ini;php -m | grep ssh2;service httpd restart

# tamb
sudo yum install -y git

echo "-"
echo "-------------------------"
echo "STATUS"
echo "-------------------------"
echo "-"
systemctl status httpd
# systemctl status mariadb
systemctl status iptables
systemctl status firewalld
systemctl status fail2ban
echo "-"
echo "-"
httpd -v
php -v

echo "-"
echo "-"
echo "========================="
echo "LAMP Installation Finish"
echo "========================="
echo "-"
echo "-"
#!/bin/bash
echo "*****************************"
echo "**server install of zabbix!**"
echo "**||  write by wzq1397   ||**"
echo "*****************************"
echo "*  DO YOU WANT TO EXECUTE?  *"
echo -e "\033[44;37m please comfirm you have enter the dir of zabbix[0m"
read -p "[CHOOSE y/N]" ch
if [ ch == y || ch == Y ]
then 
	echo "zabbix will install auto."
else
	echo "goto this web download and decompress http://www.zabbix.com/"
	exit

yum install make gcc libcurl-devel net-snmp-devel php php-gd php-xml php-mysql php-mbstring php-bcmath lrzsz -y

sql=chkconfig --list | cut -f 1 | grep -Ei "mysql*|oracle|sqlite" | wc -l
if [ sql == 0 ]
then 
	yum install -y mysql-server mysql-devel

web=chkconfig --list | cut -f 1 | grep -Ei "httpd|nginx|Lighttpd" | wc -l
if [ web == 0 ]
then 
	yum install -y httpd
	
groupadd zabbix
useradd zabbix -g zabbix

./configure --prefix=/usr/local/zabbix --enable-server --enable-agent \
--with-mysql --with-net-snmp --with-libcurl
make install

service mysqld start;
mysql -e "create database zabbix character set utf8;" -p 
mysql -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';flush privileges;" -p 

mysql -uroot zabbix < database/mysql/schema.sql -p
mysql -uroot zabbix < database/mysql/images.sql -p
mysql -uroot zabbix < database/mysql/data.sql -p

sed -i 's/^DBUser=.*$/DBUser=zabbix/g' /usr/local/zabbix/etc/zabbix_server.conf
sed -i 's/^.*DBPassword=.*$/DBPassword=zabbix/g' /usr/local/zabbix/etc/zabbix_server.conf
cp -r frontends/php /var/www/html/zabbix
cp misc/init.d/fedora/core/zabbix_* /etc/init.d/
sed -i 's#BASEDIR=/usr/local#BASEDIR=/usr/local/zabbix#g' /etc/init.d/zabbix_server
sed -i 's#BASEDIR=/usr/local#BASEDIR=/usr/local/zabbix#g' /etc/init.d/zabbix_agentd

cat >>/etc/services <<EOF
zabbix-agent 10050/tcp Zabbix Agent
zabbix-agent 10050/udp Zabbix Agent
zabbix-trapper 10051/tcp Zabbix Trapper
zabbix-trapper 10051/udp Zabbix Trapper
EOF

if [ -f /etc/lnmp]
then 
	$zabbixphpini = /usr/local/php/etc/php.ini
else
	$zabbixphpini = /etc/php.ini
sed -i 's/^\(.*\)date.timezone =.*$/date.timezone = Asia\/Shanghai/g' $zabbixphpini
sed -i 's/^\(.*\)post_max_size =.*$/post_max_size = 16M/g'  $zabbixphpini
sed -i 's/^\(.*\)max_execution_time =.*$/max_execution_time = 300/g'  $zabbixphpini
sed -i 's/^\(.*\)max_input_time =.*$/max_input_time = 300/g'  $zabbixphpini


cat >>/etc/httpd/conf/httpd.conf <<EOF
ServerName 127.0.0.1
<VirtualHost *:80>
DocumentRoot "/var/www/html"
ServerName zabbix_server 
</VirtualHost>
EOF


cat >/var/www/html/zabbix/conf/zabbix.conf.php <<EOF
<?php
// Zabbix GUI configuration file
global $DB;

$DB['TYPE'] = 'MYSQL';
$DB['SERVER'] = 'localhost';
$DB['PORT'] = '0';
$DB['DATABASE'] = 'zabbix';
$DB['USER'] = 'zabbix';
$DB['PASSWORD'] = 'zabbix';

// SCHEMA is relevant only for IBM_DB2 database
$DB['SCHEMA'] = '';

$ZBX_SERVER = 'localhost';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = '';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
?>
EOF

service iptables stop
chkconfig --level 345 iptables off
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux 
echo "/etc/init.d/zabbix_server start" >> /etc/rc.local
echo "/etc/init.d/zabbix_agentd start" >> /etc/rc.local
chkconfig --level 345 mysqld on
chkconfig --level 345 httpd on


/etc/init.d/zabbix_server start
/etc/init.d/zabbix_agentd start
1.���ݿ���Ȩ����˺�dba_monitor
GRANT SELECT, PROCESS, SUPER ON *.* TO 'dba_monitor'@'%' IDENTIFIED BY 'xxxx';
GRANT ALL PRIVILEGES ON `mysql`.`slow_log` TO 'dba_monitor'@'%';

2.����get_mysql_stats_wrapper.sh��ss_get_mysql_stats.php�����ļ�����˺���Ϣ

3.����Zabbix Agent

UnsafeUserParameters=1
Include=/var/lib/zabbix/percona/templates/userparameter_percona_mysql.conf

4.����zabbix agent

��ϸ�ο�:
https://www.percona.com/doc/percona-monitoring-plugins/1.1/zabbix/index.html
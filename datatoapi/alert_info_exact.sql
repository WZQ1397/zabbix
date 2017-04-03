DROP DATABASE IF EXISTS `alarmreport`;
CREATE DATABASE alarmreport;
USE alarmreport;
DROP TABLE IF EXISTS `report`;
CREATE TABLE `report` (
  `reportid` int(11) NOT NULL AUTO_INCREMENT,
  `reportip` varchar(64) NOT NULL,
  `reporttype` varchar(64) NOT NULL,
  `alarmid` int(11) NOT NULL,
  `alarmname` varchar(64) NOT NULL,
  `alarmlevel` varchar(64) NOT NULL,
  `alarmstat` varchar(64) NOT NULL,
  `alarmtime` varchar(64) NOT NULL,
  `alarmcause` varchar(64) NOT NULL,
  `sendstatus` varchar(64) NOT NULL,
  PRIMARY KEY(reportid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
DROP TABLE IF EXISTS `dictionary`;
CREATE TABLE `dictionary` (
  `alarmid` int(11) NOT NULL,
  `alarmname` varchar(64) NOT NULL,
  `alarmcause` varchar(64) NOT NULL,
  PRIMARY KEY(alarmid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TRIGGER IF EXISTS afterinsert_on_event;
CREATE TRIGGER afterinsert_on_event 
AFTER INSERT ON zabbix.`events`
FOR EACH ROW
BEGIN
        INSERT INTO alarmreport.report (
            alarmreport.report.reportip,
            alarmreport.report.reporttype,
            alarmreport.report.alarmid,
            alarmreport.report.alarmname,
            alarmreport.report.alarmlevel,
            alarmreport.report.alarmstat,
            alarmreport.report.alarmtime
        )
        SELECT
            zabbix.`hosts`.`host`,
            CONCAT('CONNECT_SERVER_IP'),
            zabbix.`triggers`.triggerid,
            zabbix.`triggers`.description,
            zabbix.`triggers`.priority,
            zabbix.`events`.`value`,
            FROM_UNIXTIME(zabbix.`events`.clock)
        FROM
            zabbix.`hosts`,
            zabbix.`triggers`,
            zabbix.`events`,
            zabbix.items,
            zabbix.functions,
            zabbix.groups,
            zabbix.hosts_groups
        WHERE
            zabbix.`hosts`.hostid = zabbix.hosts_groups.hostid
            AND zabbix.hosts_groups.groupid = zabbix.groups.groupid
            AND zabbix.`triggers`.triggerid = zabbix.`events`.objectid
            AND zabbix.`hosts`.hostid = zabbix.items.hostid
            AND zabbix.items.itemid = zabbix.functions.itemid
            AND zabbix.functions.triggerid = zabbix.`triggers`.triggerid
            AND zabbix.`events`.eventid=new.eventid;
END;

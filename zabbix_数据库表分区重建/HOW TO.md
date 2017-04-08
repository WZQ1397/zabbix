1.修改两张表的结构

```mysql
use zabbix;
Alter table history_text drop primary key, add index (id), drop index history_text_2, add index history_text_2 (itemid, id);
Alter table history_log drop primary key, add index (id), drop index history_log_2, add index history_log_2 (itemid, id);
```

2.创建四个存储过程

`mysql -uzabbix -pzabbix zabbix < partition_call.sql`

`mysql -uzabbix -pzabbix zabbix < partition_all.sql`

3.执行表分区

```mysql
mysql -uzabbix -pzabbix zabbix -e "CALL partition_maintenance_all('zabbix');"
+----------------+--------------------+
| table          | partitions_deleted |
+----------------+--------------------+
| zabbix.history | N/A                |
+----------------+--------------------+
+--------------------+--------------------+
| table              | partitions_deleted |
+--------------------+--------------------+
| zabbix.history_log | N/A                |
+--------------------+--------------------+
+--------------------+--------------------+
| table              | partitions_deleted |
+--------------------+--------------------+
| zabbix.history_str | N/A                |
+--------------------+--------------------+
+---------------------+--------------------+
| table               | partitions_deleted |
+---------------------+--------------------+
| zabbix.history_text | N/A                |
+---------------------+--------------------+
+---------------------+--------------------+
| table               | partitions_deleted |
+---------------------+--------------------+
| zabbix.history_uint | N/A                |
+---------------------+--------------------+
+---------------+--------------------+
| table         | partitions_deleted |
+---------------+--------------------+
| zabbix.trends | N/A                |
+---------------+--------------------+
+--------------------+--------------------+
| table              | partitions_deleted |
+--------------------+--------------------+
| zabbix.trends_uint | N/A                |
+--------------------+--------------------+
```

4.计划任务把上面这条命令放入计划任务

PS:清空表中数据的命令为： truncate table history_uint;

QT:

partition_all.sql举例：

zabbix_db_name：库名

table_name：表名

days_to_keep_data：保存多少天的数据

hourly_interval：每隔多久生成一个分区

num_future_intervals_to_create：本次一共生成多少个分区

这个例子就是history_uint表最多保存31天的数据，每隔24小时生成一个分区，这次一共生成14个分区

mysql -uzabbix -pzabbix zabbix<partition_call.sql
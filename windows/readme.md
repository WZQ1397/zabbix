###OS
UserParameter=windowspdiskperf.discovery,powershell -NoProfile -ExecutionPolicy Bypass -File C:\Program Files\Zabbix Agent\ps-script\get_pdisks.ps1
UserParameter=windowsldiskperf.discovery,powershell -NoProfile -ExecutionPolicy Bypass -File C:\Program Files\Zabbix Agent\ps-script\get_ldisks.ps1
UserParameter=windowsnetworkperf.discovery,powershell -NoProfile -ExecutionPolicy Bypass -File C:\Program Files\Zabbix Agent\ps-script\get_adapters.ps1
UserParameter=windowsprocessorperf.discovery,powershell -NoProfile -ExecutionPolicy Bypass -File C:\Program Files\Zabbix Agent\ps-script\get_processors.ps1
 
###SQL Server
UserParameter=sqldatabasename.discovery,powershell -NoProfile -ExecutionPolicy Bypass -File C:\Program Files\Zabbix Agent\ps-script\SQLBaseName_To_Zabbix.ps1
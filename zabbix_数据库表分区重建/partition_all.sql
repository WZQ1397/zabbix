DELIMITER $$
CREATE PROCEDURE `partition_maintenance_all`(SCHEMA_NAME VARCHAR(32))
BEGIN
       CALL partition_maintenance(SCHEMA_NAME, 'history', 31, 24, 14);
       CALL partition_maintenance(SCHEMA_NAME, 'history_log', 31, 24, 14);
       CALL partition_maintenance(SCHEMA_NAME, 'history_str', 31, 24, 14);
       CALL partition_maintenance(SCHEMA_NAME, 'history_text', 31, 24, 14);
       CALL partition_maintenance(SCHEMA_NAME, 'history_uint', 31, 24, 14);
       CALL partition_maintenance(SCHEMA_NAME, 'trends', 180, 24, 14);
       CALL partition_maintenance(SCHEMA_NAME, 'trends_uint', 180, 24, 14);
END$$
DELIMITER ;
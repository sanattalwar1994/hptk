select distinct(SUBSTRING_INDEX(host,‘:’,1)) as ‘ip’ from information_schema.processlist WHERE ID=connection_id();

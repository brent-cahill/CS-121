-- PLEASE DO NOT INCLUDE date-udfs HERE!!!

-- [Problem 4a]
INSERT INTO resource_dim (resource, method, protocol, response)
  SELECT DISTINCT resource, method, protocol, response
  FROM raw_web_log;


-- [Problem 4b]
INSERT INTO visitor_dim (ip_addr, visit_val)
  SELECT DISTINCT ip_addr, visit_val FROM raw_web_log;

-- [Problem 4c]
DELIMITER !
-- Since we already created the is weekend and is holiday files,
-- we needn't reinvent the wheel.

CREATE PROCEDURE populate_dates(IN d_start DATE, IN d_end DATE)
BEGIN
  DECLARE d DATE;
  DECLARE h INTEGER;
  
  DELETE FROM datetime_dim
  WHERE date_val BETWEEN d_start AND d_end;
  SET d = d_start;
  WHILE d <= d_end DO
    SET h = 0;
    WHILE h <= 23 DO
      INSERT INTO datetime_dim (date_val, hour_val, weekend, holiday)
        VALUES (d, h, is_weekend(d), is_holiday(d));
      SET h = h + 1;
    END WHILE;
    SET d = d + INTERVAL 1 DAY;
  END WHILE;
END ! 

DELIMITER ;


-- [Problem 5a]
INSERT INTO resource_fact (date_id, resource_id, num_requests, total_bytes)
  SELECT date_id, resource_id, 
    COUNT(*) AS num_requests, 
	SUM(bytes_sent) AS total_bytes
  FROM raw_web_log
  JOIN datetime_dim ON (DATE(raw_web_log.logtime) <=> datetime_dim.date_val
	AND HOUR(raw_web_log.logtime) <=> datetime_dim.hour_val)
  JOIN resource_dim ON (raw_web_log.resource <=> resource_dim.resource
	AND raw_web_log.method <=> resource_dim.method
	AND raw_web_log.protocol <=> resource_dim.protocol
	AND raw_web_log.response <=> resource_dim.response)
  GROUP BY date_id, resource_id;


-- [Problem 5b]
INSERT INTO visitor_fact (date_id, visitor_id, num_requests, total_bytes)
  SELECT date_id, visitor_id, 
	COUNT(*) AS num_requests, 
	SUM(bytes_sent) AS total_bytes
  FROM raw_web_log
    JOIN datetime_dim ON (DATE(raw_web_log.logtime) <=> datetime_dim.date_val
	  AND HOUR(raw_web_log.logtime) <=> datetime_dim.hour_val)
    JOIN visitor_dim ON (raw_web_log.ip_addr <=> visitor_dim.ip_addr
	  AND raw_web_log.visit_val <=> visitor_dim.visit_val)
    GROUP BY date_id, visitor_id;


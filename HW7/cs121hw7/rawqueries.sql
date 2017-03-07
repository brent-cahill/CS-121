-- [Problem 2a]

SELECT COUNT(*) FROM raw_web_log;

-- [Problem 2b]

SELECT ip_addr, COUNT(ip_addr) AS request_count 
  FROM raw_web_log GROUP BY ip_addr
  ORDER BY request_count DESC LIMIT 20;

-- [Problem 2c]

SELECT resource, COUNT(resource) AS requests, 
  SUM(bytes_sent) AS served FROM raw_web_log
  GROUP BY resource ORDER BY served DESC LIMIT 20;

-- [Problem 2d]
SELECT visit_val, ip_addr, COUNT(resource) AS total_requests,
  MIN(logtime) AS start_time, MAX(logtime) AS end_time
  FROM raw_web_log GROUP BY visit_val, ip_addr
  ORDER BY total_requests DESC LIMIT 20;


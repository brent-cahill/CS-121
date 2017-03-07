-- [Problem 6a]
SELECT DISTINCT protocol, SUM(num_requests) AS total_requests
  FROM resource_fact NATURAL JOIN resource_dim GROUP BY protocol
  ORDER BY total_requests DESC LIMIT 10;


-- [Problem 6b]
SELECT resource, response, SUM(num_requests) AS error_num
  FROM resource_fact NATURAL JOIN resource_dim 
  WHERE response >= 400 GROUP BY resource, response 
  ORDER BY error_num DESC LIMIT 20;


-- [Problem 6c]
SELECT ip_addr, COUNT(DISTINCT visit_val) AS visits, 
  SUM(num_requests) AS total_requests, SUM(total_bytes) AS tot_bytes
  FROM visitor_fact NATURAL JOIN visitor_dim 
  GROUP BY ip_addr ORDER BY tot_bytes DESC LIMIT 20;


-- [Problem 6d]
-- One gap is caused by Hurricane Erin between August 1st and August 3rd of 1995
-- Thus, all of august 2, 1995 is lost, including date_val. According to the site:
-- "Note that from 01/Aug/1995:14:52:01 until 03/Aug/1995:04:36:13 there are no
-- accesses recorded, as the Web server was shut down, due to Hurricane Erin."

SELECT date_val, SUM(num_requests) AS total_requests, 
  SUM(total_bytes) AS tot_bytes FROM datetime_dim
  NATURAL LEFT JOIN resource_fact WHERE datetime_dim.date_val
  BETWEEN ('1995-07-23') AND ('1995-08-12') GROUP BY date_val;
 


-- [Problem 6e]

SELECT date_val, resource, total_requests, max_bytes FROM
((SELECT date_val, resource, 
  SUM(num_requests) AS total_requests, SUM(total_bytes) AS max_bytes 
  FROM datetime_dim NATURAL JOIN resource_fact 
    NATURAL JOIN resource_dim GROUP BY date_val, resource) AS resources
  NATURAL JOIN 
  (SELECT date_val, MAX(sum_bytes) AS max_bytes
    FROM (SELECT date_val, resource,  SUM(num_requests) AS total_requests,
    SUM(total_bytes) AS sum_bytes FROM datetime_dim NATURAL JOIN resource_fact 
    NATURAL JOIN resource_dim GROUP BY date_val, resource) AS resources
    GROUP BY date_val) AS maximum_bytes);


-- [Problem 6f]
-- There are multiple variables to take into account here. In 1995, people were
-- more likely to use the internet at work, because companies could afford
-- better computers than the average consumer, and could also afford to have a
-- broadband/always-on internet connection. On the other hand, people who
-- didn't have to access the internet during work are more likely to use their
-- home internet during the weekend. This causes the most discrepancies.

SELECT num_weekday_visits.hour_val AS hour_val, 
  AVG(num_weekdays) AS avg_weekday_visits, AVG(num_weekends)
  AS avg_weekend_visits
  FROM 
  (SELECT date_val, hour_val, COUNT(DISTINCT visit_val) AS num_weekdays 
    FROM datetime_dim NATURAL JOIN visitor_fact NATURAL JOIN visitor_dim
    WHERE weekend = FALSE GROUP BY date_val, hour_val) AS num_weekday_visits
  JOIN
  (SELECT date_val, hour_val, COUNT(DISTINCT visit_val) AS num_weekends
    FROM datetime_dim NATURAL JOIN visitor_fact NATURAL JOIN visitor_dim
    WHERE weekend = TRUE GROUP BY date_val, hour_val) AS num_weekend_visits 
    ON (num_weekday_visits.hour_val = num_weekend_visits.hour_val)
    GROUP BY hour_val;


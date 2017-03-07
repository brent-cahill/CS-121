-- [Problem 6a]
SELECT purchase_time, flight_date, purchaser.last_name, purchaser.first_name
  FROM (purchase NATURAL JOIN purchaser NATURAL JOIN tickets) 
  WHERE purchaser.id = '54321' ORDER BY
    purchase_time desc, date asc, last_name asc, first_name asc;




-- [Problem 6b]
SELECT t1.model, revenue FROM ((SELECT model FROM 
  (SELECT * FROM flights NATURAL JOIN airplanes) t1 LEFT JOIN 
(SELECT model, SUM(cost) as revenue FROM
  (SELECT * FROM flights NATURAL JOIN airplanes) LEFT JOIN ticket 
ON flights.flight_number = tickets.flight_number
AND flights.flight_date = ticket.flight_date
WHERE DATE_SUB(CURDATE(), INTERVAL 14 DAY) <= flights.flight_date
GROUP BY airplanes.model) t2
ON t1.model = t2.model));


-- [Problem 6c]
SELECT traveler_id, first_name, last_name FROM 
  (traveler NATURAL JOIN ticket NATURAL JOIN flights) 
  WHERE flight_domesticality = 1 AND 
    (passport_num = NULL OR  country = NULL OR ec_name = NULL
      OR ec_number = NULL);





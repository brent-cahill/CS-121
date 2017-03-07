-- [Problem 1a]
SELECT SUM(perfectscore) AS absolute_perfect FROM assignment;


-- [Problem 1b]
SELECT sec_name, COUNT(username) AS num_students FROM student
  NATURAL JOIN section GROUP BY sec_name;


-- [Problem 1c]
CREATE VIEW totalscores AS SELECT username, SUM(score) AS total_score
  FROM submission WHERE graded = 1 GROUP BY username;

-- [Problem 1d]
CREATE VIEW passing AS SELECT * FROM totalscores WHERE total_score >= 40;


-- [Problem 1e]
CREATE VIEW failing AS SELECT * FROM totalscores WHERE total_score < 40;


-- [Problem 1f]
SELECT username FROM assignment NATURAL JOIN submission
  NATURAL LEFT JOIN fileset WHERE shortname LIKE 'lab%'
  AND username IN (SELECT username FROM passing) AND fset_id IS NULL;

-- [Problem 1g]
SELECT DISTINCT username FROM assignment NATURAL JOIN
  submission NATURAL LEFT JOIN fileset WHERE (shortname = 'final'
  OR shortname = 'midterm') AND fset_id IS NULL AND username IN(
  SELECT username FROM passing);
  


-- [Problem 2a]
SELECT DISTINCT username from assignment NATURAL JOIN submission
  NATURAL JOIN fileset WHERE longname = 'midterm' AND sub_date > due;


-- [Problem 2b]
SELECT EXTRACT(HOUR FROM sub_date) AS hour_submitted, COUNT(sub_id)
  AS num_submissions FROM submission
  NATURAL JOIN assignment NATURAL JOIN fileset
  WHERE shortname like 'lab%' GROUP BY hour_submitted;


-- [Problem 2c]
SELECT COUNT(*) AS num_finals from assignment NATURAL JOIN submission
  NATURAL JOIN fileset WHERE shortname = 'final' AND sub_date >=
  (due - INTERVAL 30 MINUTE) AND sub_date <= due;


-- [Problem 3a]
ALTER TABLE student ADD COLUMN email VARCHAR(200);

UPDATE student SET email = CONCAT(username, '@school.edu');

ALTER TABLE student CHANGE COLUMN email email VARCHAR(200) NOT NULL;

-- [Problem 3b]
ALTER TABLE assignment ADD COLUMN submit_files BOOLEAN DEFAULT TRUE;

UPDATE assignment SET submit_files = FALSE WHERE shortname LIKE 'dq%';

-- [Problem 3c]
CREATE TABLE gradescheme(
  scheme_id INT,
  scheme_desc VARCHAR(100) NOT NULL,
  PRIMARY KEY (scheme_id));

INSERT INTO gradescheme VALUES
  (0,'Lab assignment withmin-grading.'),
  (1,'Daily	quiz.'),
  (2,'Midterm or final exam.');
  
ALTER TABLE assignment CHANGE COLUMN gradescheme scheme_id INT NOT NULL;

ALTER TABLE assignment ADD FOREIGN KEY (scheme_id)
  REFERENCES gradescheme (scheme_id);

-- [Problem 4a]
-- Set the "end of statement" character to ! so that
-- semicolons in the function body won't confuse MySQL.
DELIMITER !
-- Given a date value, returns TRUE if it is a weekend,
-- or FALSE if it is a weekday.
CREATE FUNCTION is_weekend(d DATE) RETURNS BOOLEAN
BEGIN
  IF dayofweek(d) IN (2,3,4,5,6) THEN RETURN FALSE;
  ELSE RETURN TRUE;
  END IF;
END !
-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 4b]
CREATE FUNCTION is_holiday(d DATE) RETURNS VARCHAR(20)
BEGIN
  DECLARE result VARCHAR(20);
  SET result = NULL;
  IF dayofyear(d) = 1 THEN result = 'New Year\'s day';
  ELSEIF monthname(d) = 'May' AND dayofweek(d) = 2
    AND dayofmonth(d) >= 25 THEN result = 'Memorial Day';
  ELSEIF monthname(d) = 'July' AND dayofmonth(d) = 4
    THEN result = 'Independence Day';
  ELSEIF monthname(d) = 'September' AND dayofweek(d) = 2
    AND dayofmonth(d) <= 6 THEN result = 'Labor Day';
  ELSEIF monthname(d) = 'November' and dayofweek(d) = 5
    AND (dayofmonth(d) BETWEEN 22 AND 28)
    THEN result = 'Thanksgiving';
  RETURN NULL;
  END IF;
END !
DELIMITER ;


-- [Problem 5a]
SELECT is_holiday(DATE(sub_date)) AS holiday, COUNT(*) AS holiday_subs
  from fileset GROUP BY holiday;


-- [Problem 5b]
SELECT CASE is_weekend(DATE(sub_date)) WHEN 0 then 'weekday'
  ELSE 'weekend' END AS day_of_week, COUNT(*) AS weekend_subs
  FROM fileset GROUP BY day_of_week;


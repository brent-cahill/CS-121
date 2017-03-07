-- [Problem 1]
DELIMITER !

CREATE FUNCTION min_submit_interval(sub_id INTEGER) RETURNS INTEGER
BEGIN
-- Variable Declaration
DECLARE submission1 INTEGER;
DECLARE submission2 INTEGER;
DECLARE sub_difference INTEGER;
DECLARE min_difference INTEGER DEFAULT NULL;

-- Cursor, and flag for when fetching is done
DECLARE done INT DEFAULT 0;
DECLARE cur CURSOR FOR
  SELECT UNIX_TIMESTAMP(sub_date) AS sub_seconds FROM fileset
  WHERE fileset.sub_id = sub_id ORDER BY fileset.sub_date DESC;

-- When fetch is complete, handler sets flag
-- 02000 is MySQL error for "zero rows fetched"
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
  SET done = 1;

  OPEN cur;
  FETCH cur into submission2;
  WHILE NOT done DO
    FETCH cur INTO submission1;
    IF NOT done THEN
      SET sub_difference = submission2 - submission1;
      
      IF min_difference IS NULL THEN
        SET min_difference = sub_difference;
	  ELSEIF sub_difference < min_difference THEN
        SET min_difference = sub_difference;
	  END IF;
      
	  SET submission2 = submission1;
    END IF;
  END WHILE;
  CLOSE cur;
RETURN min_difference;

END !

DELIMITER ;

-- [Problem 2]
DELIMITER !

CREATE FUNCTION max_submit_interval(sub_id INTEGER) RETURNS INTEGER
BEGIN
-- Variable Declaration
DECLARE submission1 INTEGER;
DECLARE submission2 INTEGER;
DECLARE sub_difference INTEGER;
DECLARE max_difference INTEGER DEFAULT NULL;

-- Cursor, and flag for when fetching is done
DECLARE done INT DEFAULT 0;
DECLARE cur CURSOR FOR
  SELECT UNIX_TIMESTAMP(sub_date) AS sub_seconds FROM fileset
  WHERE fileset.sub_id = sub_id ORDER BY fileset.sub_date DESC;

-- When fetch is complete, handler sets flag
-- 02000 is MySQL error for "zero rows fetched"
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
  SET done = 1;

  OPEN cur;
  FETCH cur into submission2;
  WHILE NOT done DO
    FETCH cur INTO submission1;
    IF NOT done THEN
      SET sub_difference = submission2 - submission1;
      
      IF max_difference IS NULL THEN
        SET max_difference = sub_difference;
	  ELSEIF sub_difference > max_difference THEN
        SET max_difference = sub_difference;
	  END IF;
      
	  SET submission2 = submission1;
    END IF;
  END WHILE;
  CLOSE cur;
RETURN max_difference;

END !

DELIMITER ;
-- [Problem 3]
DELIMITER !

CREATE FUNCTION avg_submit_interval(sub_id INTEGER) RETURNS DOUBLE
BEGIN
-- Variable Declaration
DECLARE max_sub INTEGER;
DECLARE min_sub INTEGER;
DECLARE num_subs INTEGER;
DECLARE avg_difference DOUBLE DEFAULT NULL;

SELECT UNIX_TIMESTAMP(MAX(sub_date)),
       UNIX_TIMESTAMP(MIN(sub_date)),
       COUNT(sub_date) INTO
       max_sub, min_sub, num_subs
       FROM fileset WHERE fileset.sub_id = sub_id;
       
  IF num_subs <> 0 THEN
    SET avg_difference = (max_sub - min_sub) / (num_subs - 1);
  END IF;

RETURN avg_difference;

END !

DELIMITER ;

-- [Problem 4]
CREATE INDEX idx_fileset ON fileset (sub_id, sub_date);


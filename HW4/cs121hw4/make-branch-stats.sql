-- [Problem 1]
CREATE INDEX idx_account ON account (branch_name, balance);


-- [Problem 2]
CREATE TABLE mv_branch_account_stats (
  branch_name       VARCHAR(15) NOT NULL,
  num_accounts      INTEGER NOT NULL,
  total_deposits    NUMERIC(12,2) NOT NULL,
  min_balance       NUMERIC(12,2) NOT NULL,
  max_balance       NUMERIC(12,2) NOT NULL,
  PRIMARY KEY(branch_name));
  


-- [Problem 3]
INSERT INTO mv_branch_account_stats
  SELECT branch_name,
         COUNT(*) AS num_accounts,
         SUM(balance) AS total_deposits,
         MIN(balance) AS min_balance,
         MAX(balance) AS max_balance FROM account
  GROUP BY branch_name;


-- [Problem 4]
CREATE VIEW branch_account_stats AS
  SELECT branch_name,
         num_accounts,
         total_deposits,
         (total_deposits / num_accounts) AS avg_balance,
         min_balance,
         max_balance FROM mv_branch_account_stats
  GROUP BY branch_name;


-- [Problem 5]
DELIMITER !
-- Must create procedure inserter/deleter for single row insertion/deletion
CREATE PROCEDURE inserter(
  IN branch_name VARCHAR(15),
  IN balance NUMERIC(12,2))
  
BEGIN
  INSERT INTO mv_branch_account_stats VALUES (
    branch_name,
    1,
    balance,
    balance,
    balance)
    
    -- handle duplicates:
    ON DUPLICATE KEY UPDATE
      num_accounts   = num_accounts + 1,
      total_deposits = total_deposits + balance,
      min_balance    = LEAST(balance, min_balance),
      max_balance    = GREATEST(balance, max_balance);
END !


CREATE TRIGGER trg_account_insert AFTER INSERT ON account FOR EACH ROW
  BEGIN
  
  CALL inserter(NEW.branch_name, NEW.balance);
  
  END !


DELIMITER ;
-- [Problem 6]
DELIMITER !

CREATE PROCEDURE deleter(
  IN prev_branch_name VARCHAR(15),
  IN prev_balance NUMERIC(12,2))
  
BEGIN
  DECLARE new_min NUMERIC(12,2);
  DECLARE new_max NUMERIC(12,2);
  DECLARE total_branches INTEGER;
  
  SELECT MIN(prev_balance), MAX(prev_balance), COUNT(*) INTO
  new_min, new_max, total_branches FROM account WHERE
  branch_name = prev_branch_name;
  
  -- Handle the first branch
  IF total_branches = 0 THEN
    DELETE FROM mv_branch_account_stats WHERE
    branch_name = prev_branch_name;
  ELSE
    UPDATE mv_branch_account_stats SET
      num_accounts   = num_accounts - 1,
      total_deposits = total_deposits - prev_balance,
      min_balance    = new_min,
      max_balance    = new_max
    WHERE prev_branch_name = branch_name;
  END IF;
END !

CREATE TRIGGER trg_account_delete AFTER DELETE ON account FOR EACH ROW
  BEGIN
  
  CALL deleter(OLD.branch_name, OLD.balance);
  
  END !

DELIMITER ;


-- [Problem 7]
DELIMITER !
-- Now that we have created the procedures, we can create the trigger for UPDATE
CREATE TRIGGER trg_update AFTER UPDATE ON account FOR EACH ROW
BEGIN
  DECLARE new_min NUMERIC(12,2);
  DECLARE new_max NUMERIC(12,2);
  
  SELECT MIN(prev_balance), MAX(prev_balance) INTO
    new_min, new_max FROM account WHERE
    branch_name = prev_branch_name;
    
  IF OLD.branch_name = NEW.branch_name THEN
    UPDATE mv_branch_account_stats SET
      total_deposits = total_deposits + NEW.balance - OLD.balance,
      min_balance    = new_min,
      max_balance    = new_max
	WHERE OLD.branch_name = branch_name;
  ELSE
    CALL deleter(OLD.branch_name, OLD.balance);
    CALL inserter(NEW.branch_name, NEW.balance);
  END IF;
END !

DELIMITER ;
  
  
  
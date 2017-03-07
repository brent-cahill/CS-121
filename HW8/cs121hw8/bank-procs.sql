DROP PROCEDURE IF EXISTS sp_deposit;
DROP PROCEDURE IF EXISTS sp_withdrawl;

-- [Problem 1]
DELIMITER !

CREATE PROCEDURE sp_deposit(
  IN account_number VARCHAR(20),
  IN amount NUMERIC(10,2),
  OUT status INTEGER)
  BEGIN
  
  DECLARE prevBalance NUMERIC(10,2);
  
  SELECT balance FROM account WHERE account.account_number = account_number
    INTO prevBalance;
    
  IF amount < 0 THEN SET status = -1;
  ELSE
    START TRANSACTION;
    UPDATE account SET account.balance = prevBalance + amount
      WHERE account.account_number = account_number;

    IF ROW_COUNT() = 1 THEN
      SET status = 0;
      COMMIT;
	ELSE
      SET status = -2;
      ROLLBACK;
	END IF;
  END IF;
  
END !

DELIMITER ;

CALL sp_deposit ('A-233', -100.00, @outval);
SELECT * FROM account WHERE account_number = 'A-233';

SELECT @outval;

-- [Problem 2]
DELIMITER !

CREATE PROCEDURE sp_withdrawl(
  IN account_number VARCHAR(20),
  IN amount NUMERIC(10,2),
  OUT status INTEGER)
  BEGIN
  
  DECLARE prevBalance NUMERIC(10,2);
    
  DECLARE newBalance NUMERIC(10,2);
  
  SELECT balance FROM account WHERE account.account_number = account_number
    INTO prevBalance;
  
  SET newBalance = prevBalance - amount;
  
  IF amount < 0 THEN SET status = -1;
  ELSE
    IF newBalance < 0 THEN SET status = -3;
    ELSE
      START TRANSACTION;
      UPDATE account SET account.balance = newBalance
        WHERE account.account_number = account_number;

      IF ROW_COUNT() = 1 THEN
        SET status = 0;
        COMMIT;
	  ELSE
        SET status = -2;
        ROLLBACK;
	  END IF;
    END IF;
  END IF;
  
END !

DELIMITER ;

CALL sp_withdrawl ('A-233', 530.00, @outval);
SELECT * FROM account WHERE account_number = 'A-233';

SELECT @outval;

-- [Problem 3]
DELIMITER !

CREATE PROCEDURE sp_transfer(
  IN account_1_number VARCHAR(20),
  IN amount NUMERIC(10,2),
  IN account_2_number VARCHAR(20),
  OUT status INTEGER)
  BEGIN
  DECLARE prevBalance1 NUMERIC(10,2);
  DECLARE prevBalance2 NUMERIC(10,2);
  DECLARE newBalance1  NUMERIC(10,2);
  
  IF amount < 0 
    THEN SET status = -1;
    
  ELSE
    START TRANSACTION;
    SELECT balance FROM account WHERE account.account_number
    = account_1_number INTO prevBalance1;
    SELECT balance FROM account WHERE account.account_number
    = account_2_number INTO prevBalance2;
    
    SET newBalance1 = prevBalance1 - 
    
    IF prevBalance1 IS NULL OR prevBalance2 IS NULL THEN SET status = -2;
	  ROLLBACK;
    END IF;
    
    IF newBalance1 < 0 THEN SET status = -3;
      ROLLBACK;
    ELSE
      UPDATE account SET balance = balance - amount
        WHERE account.account_number = account_1_number;
      UPDATE account SET balance = balance + amount
        WHERE account.account_number = account_2_number;
      SET status = 0;
      COMMIT;

    END IF;
  END IF;
END !
  
DELIMITER ;
  
  
  
  

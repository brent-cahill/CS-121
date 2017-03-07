-- [Problem 1a]

CREATE TABLE user_info(
  username VARCHAR(20),
  salt CHAR(10),
  password_hash CHAR(64)
);


-- [Problem 1b]

DELIMITER !
CREATE PROCEDURE sp_add_user(IN new_username VARCHAR(20),
                             IN password VARCHAR(20))
BEGIN
  DECLARE salt VARCHAR(10);
  SELECT make_salt(10) INTO salt;
  INSERT INTO user_info VALUES
  (new_username, salt, SHA2(CONCAT(salt, password), 256));
END !


-- [Problem 1c]

CREATE PROCEDURE sp_change_password(IN username VARCHAR(20),
                                    IN new_password VARCHAR(20))
BEGIN
  DECLARE new_salt VARCHAR(10);
  SELECT make_salt(10) INTO new_salt;
  UPDATE user_info
  SET salt = new_salt, password_hash =
    SHA2(CONCAT(new_salt, new_password), 256)
  WHERE user_info.username = username;
END !


-- [Problem 1d]

CREATE FUNCTION authenticate(a_username VARCHAR(20), 
                             a_password VARCHAR(20)) RETURNS BOOL
BEGIN
  DECLARE user_salt CHAR(10);
  DECLARE user_password_hash CHAR(64);
 
  IF a_username NOT IN (SELECT username FROM user_info) THEN
    RETURN FALSE;
  END IF;
 
  SELECT salt, password_hash INTO user_salt, user_password_hash FROM user_info 
  WHERE user_info.username = a_username;
  
  RETURN SHA2(CONCAT(user_salt, a_password), 256) = user_password_hash;

END !

DELIMITER ;

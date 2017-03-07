-- [Problem 1a]
SELECT loan_number, amount FROM loan WHERE amount >= 1000 AND amount <= 2000;


-- [Problem 1b]
SELECT loan_number, amount FROM loan NATURAL JOIN borrower NATURAL JOIN customer
  WHERE customer_name = 'Smith' ORDER BY loan_number;


-- [Problem 1c]
SELECT branch_city FROM branch NATURAL JOIN account
  WHERE account_number = 'A-446';


-- [Problem 1d]
SELECT customer_name, account_number, branch_name, balance
  FROM depositor NATURAL JOIN account NATURAL JOIN branch
  WHERE customer_name LIKE 'J%'
  ORDER BY customer_name;


-- [Problem 1e]
SELECT customer_name FROM depositor GROUP BY customer_name
  HAVING COUNT(account_number) > 5;



-- [Problem 2a]
CREATE VIEW pownal_customers AS
  SELECT account_number, customer_name
  FROM depositor NATURAL JOIN account
  WHERE branch_name = 'Pownal';


-- [Problem 2b]
CREATE VIEW onlyacct_customers AS
  SELECT customer_name, customer_street, customer_city
  FROM customer WHERE customer_name IN
  (SELECT customer_name FROM depositor)
  AND customer_name NOT IN
  (SELECT customer_name FROM borrower);


-- [Problem 2c]
CREATE VIEW branch_deposits AS
  SELECT branch_name, IFNULL(SUM(balance), 0) as tot_bal,
  AVG(balance) as avg_bal FROM branch NATURAL LEFT JOIN
  account GROUP BY branch_name;
  


-- [Problem 3a]
SELECT DISTINCT customer_city FROM customer
  WHERE customer_city NOT IN
  (SELECT branch_city FROM branch) GROUP BY customer_city;


-- [Problem 3b]
SELECT customer_name FROM customer WHERE customer_name
  (SELECT customer_name FROM depositor)
  AND customer_name NOT IN (SELECT customer_name FROM borrower);

-- [Problem 3c]
UPDATE account SET balance = balance + 50
  WHERE branch_name IN (SELECT branch_name
  FROM branch WHERE branch_city = 'Horseneck');


-- [Problem 3d]
UPDATE account, branch SET balance = balance + 50
  WHERE branch_city = 'Horseneck';


-- [Problem 3e]
SELECT account_number, branch_name, balance
  FROM account NATURAL JOIN (SELECT branch_name, MAX(balance)
  AS balance FROM account GROUP BY  branch_name) AS max_balance;


-- [Problem 3f]
SELECT account_number, branch_name, balance
  FROM account WHERE (branch_name, balance) IN
  (SELECT branch_name, MAX(balance) AS balance
  FROM account GROUP BY branch_name);


-- [Problem 4]
SELECT branch1.branch_name, branch1.assets,
  COUNT(branch2.assets) + 1 AS ranking FROM branch
  AS branch1 LEFT JOIN branch AS branch2 ON branch1.assets
  < branch2.assets GROUP BY branch1.branch_name ORDER BY ranking;


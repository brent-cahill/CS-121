-- [Problem a]
SELECT customer_name, count(loan_number) AS loans
  FROM customer NATURAL LEFT JOIN borrower GROUP BY customer_name
  ORDER BY loans DESC;
-- This gives the name and number of loans of each borrower at the bank
-- ordered in descending order by the number of loans.


-- [Problem b]
SELECT branch_name, FROM branch NATURAL JOIN (
  SELECT branch_name, SUM(amount) AS total FROM loan
  GROUP BY branch_name) AS total_assets WHERE assets < total;
-- This gives the sum of all loans at each branch where total loans
-- exceed total assets.

-- [Problem c]
SELECT branch_name, (SELECT COUNT(account_number) FROM account AS acct
  WHERE acct.branch_name = brch.branch_name) AS num_accounts,
  (SELECT COUNT(loan_number) FROM loan AS ln WHERE ln.branch_name =
  brch.branch_name) AS num_loans FROM branch AS brch ORDER BY branch_name;


-- [Problem d]
SELECT branch_name, COUNT(DISTINCT account_number) AS num_accounts,
  COUNT(DISTINCT loan_number) AS num_loans FROM branch NATURAL LEFT
  JOIN account NATURAL LEFT JOIN loan GROUP BY branch_name
  ORDER BY branch_name;


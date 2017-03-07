DROP TABLE IF EXISTS employees;
DROP FUNCTION IF EXISTS total_salaries_adjlist;
DROP FUNCTION IF EXISTS total_salaries_nestset;

-- [Problem 1]
CREATE TABLE employees (
  emp_id INTEGER PRIMARY KEY,
  salary INTEGER NOT NULL
);

DELIMITER !
 
CREATE FUNCTION total_salaries_adjlist(in_emp_id INTEGER) RETURNS INTEGER
BEGIN

  DECLARE sal INTEGER;
  
  INSERT INTO employees (SELECT emp_id, salary FROM employee_adjlist
    WHERE employee_adjlist.emp_id = in_emp_id);
  IF ROW_COUNT() = 0 THEN
    RETURN NULL;
  END IF;
  
  REPEAT
  INSERT INTO employees (SELECT emp_id, salary FROM employee_adjlist
    WHERE manager_id IN (SELECT emp_id FROM employees) 
    AND emp_id NOT IN (SELECT emp_id FROM employees));
  UNTIL ROW_COUNT() = 0
  END REPEAT;
  
  SELECT SUM(salary) INTO sal FROM employees;
  
  DELETE FROM employees;
  
  RETURN sal;

END !

-- [Problem 2]
CREATE FUNCTION total_salaries_nestset(in_emp_id INTEGER) RETURNS INTEGER
BEGIN
  DECLARE sal INTEGER;
  DECLARE min INTEGER;
  DECLARE max INTEGER;
  
  SELECT low, high INTO min, max FROM employee_nestset
    WHERE employee_nestset.emp_id = in_emp_id;
  SELECT SUM(salary) INTO sal FROM employee_nestset
    WHERE employee_nestset.low >= min AND employee_nestset.high <= max;
  
  RETURN sal;
END !

DELIMITER ;
-- [Problem 3]

SELECT emp_id, name, salary FROM employee_adjlist AS empl
  WHERE NOT EXISTS (SELECT emp_id FROM employee_adjlist AS eid
  WHERE eid.manager_id = empl.emp_id);

-- [Problem 4]

SELECT emp_id, name, salary FROM employee_nestset AS empl
  WHERE NOT EXISTS (SELECT emp_id FROM employee_nestset AS eid
  WHERE eid.low > empl.low AND eid.high < empl.high);

-- [Problem 5]

CREATE TABLE max_depth (
  emp_id INTEGER PRIMARY KEY
);

DELIMITER !
 
CREATE FUNCTION tree_depth() RETURNS INTEGER
BEGIN
  DECLARE depth INTEGER;
  SET depth = 0;
  
  -- Find the CEO (no manager); this is the final node
  INSERT INTO max_depth SELECT emp_id
   FROM employee_adjlist WHERE manager_id IS NULL;
   
  IF ROW_COUNT() = 0 THEN
    RETURN NULL;
  END IF;
  
  REPEAT
  INSERT INTO max_depth (SELECT emp_id FROM employee_adjlist
    WHERE manager_id IN (SELECT emp_id FROM max_depth) 
    AND emp_id NOT IN (SELECT emp_id FROM max_depth));
  SET depth = depth + 1; -- counter
  UNTIL ROW_COUNT() = 0
  END REPEAT;

  DELETE FROM max_depth;
  RETURN depth;

END !
DELIMITER ;

CREATE TABLE childTree (
  emp_id INTEGER PRIMARY KEY,
  low INTEGER NOT NULL,
  high INTEGER NOT NULL
);

DELIMITER !
 
CREATE FUNCTION emp_reports(in_emp_id INTEGER) RETURNS INTEGER
BEGIN
  DECLARE depth INTEGER;
  DECLARE min INTEGER;
  DECLARE max INTEGER;

  SELECT low, high INTO min, max FROM employee_nestset
    WHERE employee_nestset.emp_id = in_emp_id;
    
  IF min IS NULL OR max IS NULL THEN
    RETURN NULL;
  END IF;
    
  INSERT INTO childTree SELECT emp_id, low, high FROM employee_nestset
    WHERE employee_nestset.low > min and employee_nestset.high < max;
  SELECT COUNT(*) INTO depth FROM (childTree AS child1 LEFT JOIN subtree AS child2 ON
  (child2.low < child.low AND child2.high > child.high)) WHERE child2.emp_id IS NULL;
  
  DELETE FROM subtree;
  RETURN depth;

END !

DELIMITER ;







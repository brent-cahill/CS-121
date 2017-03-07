-- [Problem 1a]
SELECT DISTINCT name FROM student
  NATURAL JOIN takes NATURAL JOIN course
  WHERE course.dept_name = 'Comp. Sci.';

-- [Problem 1c]
SELECT MAX(salary) AS max_salary, dept_name
  FROM instructor GROUP BY dept_name;


-- [Problem 1d]
SELECT MIN(max_salary) AS min_salary, dept_name
  FROM (SELECT MAX(salary) AS max_salary, dept_name
  FROM instructor GROUP BY dept_name) AS max_salaries;


-- [Problem 2a]
INSERT INTO course
  VALUES('CS-001', 'Weekly Seminar', 'Comp. Sci.', 0);

-- [Problem 2b]
INSERT INTO section
  VALUES('CS-001', 1, 'Fall', 2009, null, null, null);

-- [Problem 2c]
INSERT INTO takes SELECT ID, course_id, sec_id, semester, year, null
  FROM student NATURAL JOIN section WHERE student.dept_name = 'Comp. Sci.'
  AND section.course_id = 'CS-001';


-- [Problem 2d]
DELETE takes FROM takes NATURAL JOIN
student WHERE student.name = 'Chavez';

-- [Problem 2e]
DELETE FROM course WHERE course_id = 'CS-001';
/* If you do not delete the sections of CS-001
 * before you delete the course, the sections
 * will still be deleted, since the section
 * relation still relies on the course
 * relation. ie. the course must exist for it
 * to have a section.
 */

-- [Problem 2f]
DELETE takes FROM takes NATURAL JOIN
course WHERE LOWER(title) LIKE '%database%';


-- [Problem 3a]
SELECT DISTINCT name FROM member NATURAL JOIN
borrowed NATURAL JOIN book WHERE book.publisher = 'McGraw-Hill';


-- [Problem 3b]
SELECT name FROM member NATURAL JOIN borrowed NATURAL JOIN book
  WHERE publisher = 'McGraw-Hill' GROUP BY name HAVING COUNT(name) =
  (SELECT COUNT(publisher) FROM book WHERE publisher = 'McGraw-Hill');


-- [Problem 3c]
SELECT publisher, name FROM member NATURAL JOIN borrowed
  NATURAL JOIN book GROUP BY publisher, name HAVING COUNT(*) > 5;


-- [Problem 3d]
SELECT AVG(borrow_count)
  FROM (SELECT COUNT(isbn) as borrow_count FROM member
  LEFT JOIN borrowed USING (memb_no) GROUP BY memb_no) AS all_books;
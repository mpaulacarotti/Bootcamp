/* Lesson 18: Career Simulation */
/* Science QTech is a startup in Data Science field. HR has asked me to 
 * generate reports on employee details, their performance, and projects
 * employees have undertaken. Goal is to analyze employee database */

/* ACTION 1: Create tables and import the corresponding data for them. */
-- DROP TABLE IF EXISTS emp_record_table ;
CREATE TABLE emp_record_table(
emp_id VARCHAR(20),
first_name VARCHAR(40),
last_name VARCHAR(40),
gender VARCHAR(1),
role VARCHAR(60),
dept VARCHAR(40),
exp INT(2),
country VARCHAR(40),
continent VARCHAR(40),
salary INT(7),
emp_rating INT (2),
manager_id VARCHAR(20),
proj_id VARCHAR(20)
) ;

-- DROP TABLE IF EXISTS proj_table ;
CREATE TABLE proj_table(
project_id VARCHAR(20),
proj_name VARCHAR(60),
domain VARCHAR(30),
start_date DATE(10),
closure_date DATE(10),
dev_qtr VARCHAR(2),
status VARCHAR(20)
) ;

-- DROP TABLE IF EXISTS data_science_team ;
CREATE TABLE data_science_team(
emp_id VARCHAR(20),
first_name VARCHAR(40),
last_name VARCHAR(40),
gender VARCHAR(1),
role VARCHAR(60),
dept VARCHAR(40),
exp INT(2),
country VARCHAR(40),
continent VARCHAR(40)
) ;

/* ACTION 2: Create ER Diagram for the 3 tables. Screenshot attached with file upload.
How are these tables connected?
data_science_team and emp_record_table share the 'emp_id' key.
emp_record_table and proj_table share the 'project_id' key (slight name variation among tables) */

/* Before doing anything, let's familiarize ourselves with these 3 tables. */
-- PROJ TABLE
SELECT *
FROM proj_table pt ;

SELECT COUNT(*) as row_count
FROM proj_table pt ;
-- Row #s: 6
SELECT COUNT(DISTINCT project_id) as unique_proj_id
FROM proj_table pt ;
-- Row #s: 6
/* Therefore there are no duplicate project IDs */

SELECT DISTINCT domain
FROM proj_table pt ;
-- 4 distinct domain types

SELECT project_id, status,
ROW_NUMBER() OVER(PARTITION BY status) as status_count
FROM proj_table pt ;
-- 1 project delayed, 2 are done, 3 are WIP, and 1 is YTS

-- EMP_RECORD_TABLE
SELECT *
FROM emp_record_table ert ;

SELECT COUNT(*) as row_count
FROM emp_record_table ert ;
-- Row #s: 19
SELECT COUNT(DISTINCT emp_id) as unique_emp_id
FROM emp_record_table ert ;
-- Row #s: 19
/* Therefore there are no duplicate employee IDs */

SELECT COUNT(DISTINCT dept) as distinct_dept,
COUNT(DISTINCT role) as distinct_role,
COUNT(DISTINCT country) as distinct_country,
COUNT(DISTINCT continent) as distinct_continent,
COUNT(DISTINCT manager_id) as distinct_manager_id, 
COUNT(DISTINCT proj_id) as distinct_proj_id
FROM emp_record_table ert ;
-- 5 distinct depts, 6 distinct roles, 7 distinct countries, 4 distinct continents, 7 distinct managers, 8 distinct project IDs

SELECT salary, max_salary, min_salary, ROUND(avg_salary, 0)
FROM (SELECT salary,
	MAX(salary) OVER() as max_salary,
	MIN(salary) OVER() as min_salary,
	AVG(salary) OVER() as avg_salary
	FROM emp_record_table ert 
	ORDER BY salary DESC ) ;
-- Max salary: $16,500, min salary: $2,800, average salary: $7,463

-- DATA SCIENCE TEAM TABLE
SELECT *
FROM data_science_team dst ;

SELECT COUNT(*) as row_count
FROM data_science_team dst ;
-- Row #s: 13

SELECT COUNT(DISTINCT emp_id) as distinct_emp_id
FROM data_science_team dst ;
-- Row #s: 13
/* Therefore there are no duplicate project IDs */

SELECT COUNT(DISTINCT role) as distinct_role,
COUNT(DISTINCT dept) as distinct_dept,
COUNT(DISTINCT country) as distinct_country,
COUNT(DISTINCT continent) as distinct_continent
FROM data_science_team dst ;
-- 4 distinct roles, 4 distinct depts, 4 distinct countries, 4 distinct continents

/* ACTION 3: Write query to fetch the emp_id, first & last name, gender and dept.
 * Make a list of employees and details of their dept */
SELECT ert.emp_id,
ert.first_name || " " || ert.last_name as employee_name,
ert.gender,
ert.dept,
CASE WHEN
	pt.proj_name IS NULL THEN "Not on Project"
	ELSE pt.proj_name
	END AS 'project_name'
FROM emp_record_table ert 
LEFT JOIN proj_table pt ON ert.proj_id = pt.project_id
ORDER BY project_name ;

/* ACTION 4: Write a query to fetch emp_id, first &l ast name, gender, dept, and emp_rating
 * if the emp rating is < 2, emp rating is > 4 and between 2 & 4 
 * Less than/equal to 2
 * Greater than/equal to 4 */
SELECT emp_id,
first_name || " " || last_name as employee_name,
gender,
dept,
emp_rating
FROM emp_record_table ert 
WHERE emp_rating <= 2 OR emp_rating >= 4 
ORDER BY emp_rating DESC;

/* ACTION 5: Write a query to concatenate the first & last name of the employees in the Finance dept,
 * from emp table. give column alias 'name' */
SELECT emp_id, first_name || " " || last_name as name, dept 
FROM emp_record_table ert 
WHERE dept = 'FINANCE' ;

/* ACTION 6: Write a query to list employees who have someone reporting to them.
 * Show number of reporters, including president */
-- Included the NOT NULL because there is an employee id (E001 Arthur Black) that does not report to anyone
SELECT ert.emp_id as boss_id, ert.first_name || " " || ert.last_name as boss_name,
ert2.emp_id as employee_id, ert2.first_name || " " || ert2.last_name as employee_name,
ROW_NUMBER() OVER(PARTITION BY ert.emp_id) AS number_of_reporters
FROM emp_record_table ert 
JOIN emp_record_table ert2 ON ert.emp_id = ert2.manager_id 

/* ACTION 7: Write a query to list all employees from healthcare and finance dpts using UNION */
SELECT *
FROM emp_record_table ert 
WHERE dept = 'FINANCE' 
UNION
SELECT *
FROM emp_record_table ert2 
WHERE dept = 'HEALTHCARE'
ORDER BY dept ASC ;

/* ACTION 8: Write query to list employee details such as: emp_id, first & last name, role, dept,
 * and emp rating. Include respective emp rating along with max emp rating for the dept */
SELECT emp_id, first_name || " " || last_name AS employee_name, "role", dept, emp_rating,
MAX(emp_rating) OVER(PARTITION BY dept ORDER BY emp_rating DESC) as max_emp_rating_dept
FROM emp_record_table ert 
ORDER BY dept ;

/* ACTION 9: Write a query to calculate the min & max salary of the employees in each role
 * Use the ERT */
SELECT emp_id, first_name || " " || last_name as employee_id, salary, "role",
MAX(salary) OVER(PARTITION BY "role") as max_earning_role,
MIN(salary) OVER(PARTITION BY "role") as min_earning_role
FROM emp_record_table ert 
ORDER BY "role" ASC ;

/* ACTION 10: Write query to assign ranks to each employee based on experience*/
SELECT emp_id, first_name || " " || last_name as employee_name, role, dept, exp,
ROW_NUMBER() OVER(PARTITION BY exp) as experience_rank
FROM emp_record_table ert 
ORDER BY "exp" DESC ;

/* ACTION 11: Create a view to display employees in various countries whose salary is > 6000*/
DROP VIEW IF EXISTS foreign_employees ;
CREATE VIEW foreign_employees AS
SELECT ert.emp_id,
ert.first_name || " " || ert.last_name as employee_name,
ert.role,
ert.dept,
ert.salary,
ert.country,
ert.continent,
CASE WHEN
	pt.proj_name IS NULL THEN 'Not on project'
	ELSE pt.proj_name
	END AS proj_name
FROM emp_record_table ert 
LEFT JOIN proj_table pt ON ert.proj_id = pt.project_id
WHERE salary > 6000 
ORDER BY salary DESC ;

-- Verify view was created correctly:
SELECT *
FROM foreign_employees fe ;

SELECT *
FROM foreign_employees fe 
WHERE dept = 'RETAIL' or dept = 'HEALTHCARE' ;

SELECT *
FROM foreign_employees fe 
WHERE salary < 6000 ;
-- No rows output which is how we meant to create our view

/* ACTION 12: Write nested query to find employees with experience of more than 10 yrs*/
SELECT *
FROM (SELECT ert.emp_id, ert.first_name || " " || ert.last_name as employee_name, ert.role, ert.dept, ert.EXP, pt.proj_name
	FROM emp_record_table ert 
	LEFT JOIN proj_table pt ON ert.proj_id = pt.project_id
	WHERE exp > 10 
	ORDER BY exp DESC)
ORDER BY employee_name ASC ;


/* ACTION 13: Write query to check whether job profile assigned to each employee in data science team 
 * matches the org's standard
 * Wouldn't need LEFT JOIN because everyone on data science team is an employee and exist 
 * in that table BUT I want to include proj table, so will use LEFT JOIN */
SELECT dst.emp_id,
ert.first_name || " " || ert.last_name as employee_name,
CASE WHEN
	pt.proj_name IS NULL THEN 'Not on project'
	ELSE pt.proj_name
	END AS proj_name,
ert.exp,
ert.dept,
CASE
	WHEN dst.exp <= 2 THEN 'JUNIOR DATA SCIENTIST'
	WHEN dst.exp > 2 AND dst.exp <= 5 THEN 'ASSOCIATE DATA SCIENTIST'
	WHEN dst.exp > 5 AND dst.exp <= 10 THEN 'SENIOR DATA SCIENTIST'
	WHEN dst.exp > 10 AND dst.exp <= 12 THEN 'LEAD DATA SCIENTIST'
	WHEN dst.exp > 12 AND dst.exp <= 16 THEN 'MANAGER'
END as re_ranking
FROM data_science_team dst 
LEFT JOIN emp_record_table ert ON dst.emp_id = ert.emp_id 
LEFT JOIN proj_table pt ON ert.proj_id = pt.project_id 
ORDER BY ert.exp DESC ;

/* ACTION 14: Write query to calculate a bonus for all employees, based on their ratings and salaries.
 * Use formula: 5% of salary * emp rating*/
SELECT emp_id, first_name || " " || last_name as employee_name, salary, emp_rating,
(0.05 * salary) * (emp_rating) as bonus_amount
FROM emp_record_table ert 
ORDER BY (0.05 * emp_rating) DESC ;

/* ACTION 15: Write query to calculate average salary distribution based on continent and country */
-- Made this into a subquery so that there is a way to round the values since it can't be done within window function
SELECT continent, country,
CEILING(avg_salary_country) as avg_salary_country_rounded,
CEILING(avg_salary_continent) avg_salary_continent_rounded
FROM(SELECT continent, country,
	AVG(salary) OVER(PARTITION BY country) as avg_salary_country,
	AVG(salary) OVER(PARTITION BY continent) as avg_salary_continent
	FROM emp_record_table ert ) 
ORDER BY continent DESC ;



--Task1.1
DROP TABLE IF EXISTS employees CASCADE;
CREATE TABLE employees(
	emp_id SERIAL PRIMARY KEY,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	job_position VARCHAR(50) NOT NULL,
	salary NUMERIC(8,2),
	start_date DATE NOT NULL,
	birth_date DATE NOT NULL,
	store_id INT,
	department_id INT,
	manager_id INT
);

--Task1.2

DROP TABLE IF EXISTS departments CASCADE;
CREATE TABLE departments(
	department_id SERIAL PRIMARY KEY,
	department VARCHAR(50) NOT NULL,
	division VARCHAR(50) NOT NULL
);

--Task 2
ALTER TABLE employees
ALTER COLUMN department_id SET NOT NULL;

ALTER TABLE employees
ALTER COLUMN start_date SET DEFAULT CURRENT_DATE;

ALTER TABLE employees
ADD COLUMN end_date DATE;

ALTER TABLE employees
ADD CONSTRAINT birth_check CHECK(DATE(birth_date) <= CURRENT_DATE) ;

ALTER TABLE employees
RENAME COLUMN job_position TO position_title;



--Task 3.1
INSERT INTO employees
VALUES(1,'Morrie','Conaboy','CTO',21268.94,'2005-04-30','1983-07-10',1,1,NULL,NULL),
(2,'Miller','McQuarter','Head of BI',14614.00,'2019-07-23','1978-11-09',1,1,1,NULL),
(3,'Christalle','McKenny','Head of Sales',12587.00,'1999-02-05','1973-01-09',2,3,1,NULL),
(4,'Sumner','Seares','SQL Analyst',9515.00,'2006-05-31','1976-08-03',2,1,6,NULL),
(5,'Romain','Hacard','BI Consultant',7107.00,'2012-09-24','1984-07-14',1,1,6,NULL),
(6,'Ely','Luscombe','Team Lead Analytics',12564.00,'2002-06-12','1974-08-01',1,1,2,NULL),
(7,'Clywd','Filyashin','Senior SQL Analyst',10510.00,'2010-04-05','1989-07-23',2,1,2,NULL),
(8,'Christopher','Blague','SQL Analyst',9428.00,'2007-09-30','1990-12-07',2,2,6,NULL),
(9,'Roddie','Izen','Software Engineer',4937.00,'2019-03-22','2008-08-30',1,4,6,NULL),
(10,'Ammamaria','Izhak','Customer Support',2355.00,'2005-03-17','1974-07-27',2,5,3,'2013-04-14'),
(11,'Carlyn','Stripp','Customer Support',3060.00,'2013-09-06','1981-09-05',1,5,3,NULL),
(12,'Reuben','McRorie','Software Engineer',7119.00,'1995-12-31','1958-08-15',1,5,6,NULL),
(13,'Gates','Raison','Marketing Specialist',3910.00,'2013-07-18','1986-06-24',1,3,3,NULL),
(14,'Jordanna','Raitt','Marketing Specialist',5844.00,'2011-10-23','1993-03-16',2,3,3,NULL),
(15,'Guendolen','Motton','BI Consultant',8330.00,'2011-01-10','1980-10-22',2,3,6,NULL),
(16,'Doria','Turbat','Senior SQL Analyst',9278.00,'2010-08-15','1983-01-11',1,1,6,NULL),
(17,'Cort','Bewlie','Project Manager',5463.00,'2013-05-26','1986-10-05',1,5,3,NULL),
(18,'Margarita','Eaden','SQL Analyst',5977.00,'2014-09-24','1978-10-08',2,1,6,'2020-03-16'),
(19,'Hetty','Kingaby','SQL Analyst',7541.00,'2009-08-17','1999-04-25',1,2,6,NULL),
(20,'Lief','Robardley','SQL Analyst',8981.00,'2002-10-23','1971-01-25',2,3,6,'2016-07-01'),
(21,'Zaneta','Carlozzi','Working Student',1525.00,'2006-08-29','1995-04-16',1,3,6,'2012-02-19'),
(22,'Giana','Matz','Working Student',1036.00,'2016-03-18','1987-09-25',1,3,6,NULL),
(23,'Hamil','Evershed','Web Developper',3088.00,'2022-02-03','2012-03-30',1,4,2,NULL),
(24,'Lowe','Diamant','Web Developper',6418.00,'2018-12-31','2002-09-07',1,4,2,NULL),
(25,'Jack','Franklin','SQL Analyst',6771.00,'2013-05-18','2005-10-04',1,2,2,NULL),
(26,'Jessica','Brown','SQL Analyst',8566.00,'2003-10-23','1965-01-29',1,1,2,NULL);



--Task 3.2
INSERT INTO departments
VALUES
(1,'Analytics','IT'),
(2,'Finance','Administration'),
(3,'Sales','Sales'),
(4,'Website', 'IT'),
(5,'Back Office','Administration');


--Task4.1
-- Jack Franklin gets promoted to 'Senior SQL Analyst' and the salary raises to 7200.
-- Update the values accordingly.
UPDATE employees
SET salary = 7200, position_title = 'Senior SQL Analyst'
WHERE first_name = 'Jack' and last_name = 'Franklin';


--Task4.2
-- The responsible people decided to rename the position_title Customer Support to Customer Specialist.
-- Update the values accordingly.
UPDATE employees
SET position_title = 'Customer Specialist'
WHERE position_title = 'Customer Support';

--Task 4.3
-- All SQL Analysts including Senior SQL Analysts get a raise of 6%.
-- Upate the salaries accordingly.
UPDATE employees
SET salary = salary * 1.06
WHERE position_title = 'SQL Analyst' or position_title = 'Senior SQL Analyst';

--Task 4.4
-- What is the average salary of a SQL Analyst in the company (excluding Senior SQL Analyst)?
SELECT AVG(salary)
FROM employees
WHERE position_title = 'SQL Analyst'
GROUP BY position_title;

--Task 5.1
-- Write a query that adds a column called manager that contains  first_name and last_name (in one column) in the data output.
-- Secondly, add a column called is_active with 'false' if the employee has left the company already, otherwise the value is 'true'.

ALTER TABLE employees
ADD COLUMN manager VARCHAR(60);

UPDATE employees
SET manager = first_name || last_name;

ALTER TABLE employees
ADD COLUMN is_active BOOLEAN DEFAULT True;

UPDATE employees
SET is_active = FALSE 
WHERE end_date IS NOT NULL and DATE(end_date) <= DATE(CURRENT_DATE);

--Task 5.2
-- Create a view called v_employees_info from that previous query.
DROP VIEW IF EXISTS v_employees_info;
CREATE VIEW v_employees_info AS
SELECT *
FROM employees;

--Task 6
-- Write a query that returns the average salaries for each positions with appropriate roundings.
SELECT position_title,ROUND(AVG(salary),2)
FROM employees
GROUP BY position_title

--Task 7
-- Write a query that returns the average salaries per division.
SELECT d.department,ROUND(AVG(e.salary),2)
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
GROUP BY d.department_id

--Taks 8.1
-- Write a query that returns the following:
-- emp_id,
-- first_name,
-- last_name,
-- position_title,
-- salary
-- and a column that returns the average salary for every job_position.
-- Order the results by the emp_id.

SELECT emp_id, first_name, last_name, position_title, salary, ROUND(AVG(salary) OVER(PARTITION BY position_title) ,2)as avg_position_salary
FROM employees
ORDER BY emp_id;

--Task 8.2
-- How many people earn less than there avg_position_salary?
-- Write a query that answers that question.
-- Ideally, the output just shows that number directly.
SELECT COUNT(*)
FROM
(SELECT emp_id, first_name, last_name, position_title, salary, ROUND(AVG(salary) OVER(PARTITION BY position_title) ,2)as avg_position_salary
FROM employees
ORDER BY emp_id) AS a
WHERE a.salary < a.avg_position_salary;


--Task 9 
-- Write a query that returns a running total of the salary development ordered by the start_date.
-- In your calculation, you can assume their salary has not changed over time, 
-- and you can disregard the fact that people have left the company (write the query as if they were still working for the company).

SELECT emp_id, salary,start_date, SUM(salary) OVER(ORDER BY start_date) as sum_position_salary
FROM employees


--Task 10  
-- Create the same running total but now also consider the fact that people were leaving the company.
SELECT start_date,SUM(salary) OVER(ORDER BY start_date)
FROM (
	SELECT emp_id,salary,start_date
	FROM employees
	UNION 
	SELECT emp_id,-salary,end_date
	FROM v_employees_info
	WHERE is_active ='false'
	ORDER BY start_date) a 

--Task 11.1
-- Write a query that outputs only the top earner per position_title including first_name and position_title and their salary.
SELECT a.first_name,a.position_title,a.salary
FROM(
SELECT first_name, position_title, salary,RANK() OVER (PARTITION BY position_title ORDER BY salary DESC)
FROM employees) as a
WHERE a.rank = 1 and a.position_title = 'SQL Analyst'


--Task 11.2
-- Add also the average salary per position_title.
SELECT a.first_name,a.position_title,a.salary,a.avg_in_position
FROM(
SELECT first_name, position_title, salary,RANK() OVER (PARTITION BY position_title ORDER BY salary DESC),ROUND(AVG(salary) OVER(PARTITION BY position_title),2) as avg_in_position
FROM employees) as a
WHERE a.rank = 1 
ORDER BY a.salary DESC

--Task 11.3
-- Remove those employees from the output of the previous query that has the same salary as the average of their position_title.
-- These are the people that are the only ones with their position_title.

SELECT a.first_name,a.position_title,a.salary,a.avg_in_position
FROM(
SELECT first_name, position_title, salary,RANK() OVER (PARTITION BY position_title ORDER BY salary DESC),ROUND(AVG(salary) OVER(PARTITION BY position_title),2) as avg_in_position
FROM employees) as a
WHERE a.rank = 1 and a.salary <> a.avg_in_position
ORDER BY a.salary DESC

--Task 12 
-- Write a query that returns all meaningful aggregations of
-- - sum of salary,
-- - number of employees,
-- - average salary
-- grouped by all meaningful combinations of
-- - division,
-- - department,
-- - position_title.
-- Consider the levels of hierarchies in a meaningful way.

SELECT d.division,d.department, e.position_title,SUM(e.salary),COUNT(e.emp_id),ROUND(AVG(e.salary),2)
FROM employees e  JOIN departments d ON (e.department_id = d.department_id)
GROUP BY
	ROLLUP(
		d.division,d.department,e.position_title
	)
ORDER BY 1,2,3

--Task 13
-- Write a query that returns all employees (emp_id) including their position_title, department, their salary, and the rank of that salary partitioned by department.
-- The highest salary per division should have rank 1.
-- Which employee (emp_id) is in rank 7 in the department Analytics?
SELECT ab.emp_id
FROM (
SELECT e.emp_id, e.position_title,d.department, DENSE_RANK()OVER(PARTITION BY d.department ORDER BY salary DESC) ranking
FROM employees e LEFT JOIN departments d ON (e.department_id = d.department_id)
) as ab
WHERE ab.ranking = 7 and ab.department = 'Analytics'

--Task 14
-- Write a query that returns only the top earner of each department including
-- their emp_id, position_title, department, and their salary.
-- Which employee (emp_id) is the top earner in the department Finance?
SELECT e.emp_id, e.position_title,d.department, salary,DENSE_RANK()OVER(PARTITION BY d.department ORDER BY salary DESC) ranking
FROM employees e LEFT JOIN departments d ON (e.department_id = d.department_id)
WHERE d.department = 'Finance'

-- Full name and hire date of people that have salary between 40.000 and 70.000
SELECT e.first_name, e.last_name, e.hire_date
FROM employees.employees e
WHERE EXISTS (
SELECT *
FROM employees.salaries s
WHERE s.salary > 40000
AND e.emp_no = s.emp_no
AND EXISTS (
SELECT *
FROM employees.salaries s
WHERE s.salary < 70000
AND e.emp_no = s.emp_no ) );



-- List the manager of each department with the following information: department number, department name, 
-- the manager's employee number, last name, first name, and start and end employment dates.
SELECT dept_manager.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name, dept_manager.from_date, dept_manager.to_date
FROM dept_manager
INNER JOIN departments ON dept_manager.dept_no = departments.dept_no
INNER JOIN employees ON employees.emp_no = dept_manager.emp_no;



-- Last name of people that are born in 1956 and are in Finance
SELECT e.last_name
FROM employees.employees e
WHERE e.birth_date IN (
SELECT birth_date
FROM employees.employees
WHERE birth_date >= '1956-01-01'
AND birth_date <= '1956-12-31')
AND EXISTS (
SELECT *
FROM employees.employees e, employees.dept_emp de, employees.departments d
WHERE e.emp_no = de.emp_no AND de.dept_no = d.dept_no AND d.dept_name = 'Finance');



-- Full name, title and department of employees
SELECT e.last_name, e.first_name, t.title, d.dept_name
FROM employees.employees e, employees.titles t, employees.departments d
WHERE e.emp_no = t.emp_no
AND d.dept_name IN (
SELECT d.dept_name
FROM employees.dept_emp de
WHERE de.emp_no = e.emp_no AND de.dept_no = d.dept_no);



-- Full name, birth date and hire date of people where the pair (birth date, hire date) is different from all the others
SELECT e.last_name, e.first_name, e.birth_date, e.hire_date
FROM employees.employees e
WHERE (e.birth_date, e.hire_date)  NOT IN (
SELECT em.birth_date, em.hire_date
FROM employees.employees em
WHERE em.hire_date <> e.hire_date
AND em.birth_date <> e.birth_date )
ORDER BY e.birth_date, e.hire_date ;



-- Count of employees for each department
SELECT departments.dept_name, count(employees.emp_no) as count
FROM employees
INNER JOIN dept_emp ON dept_emp.emp_no = employees.emp_no
INNER JOIN departments ON departments.dept_no = dept_emp.dept_no
GROUP BY dept_name
ORDER BY dept_name;



-- Count of employees and salary for each title
SELECT t.title, count(distinct e.emp_no) as count_employees, avg(s.salary)
FROM employees.employees e, employees.titles t, employees.salaries s
WHERE e.emp_no = t.emp_no AND e.emp_no = s.emp_no
GROUP BY t.title;

SELECT count(emp_no)
FROM salaries;



-- Full name, department and hire date of people that have been hired in 1987 ordered by name
SELECT e.last_name, e.first_name, d.dept_name, e.hire_date
FROM employees.employees e, employees.departments d
WHERE e.hire_date IN (
SELECT e.hire_date
FROM employees.employees e
WHERE e.hire_date >= '1987-01-01'
AND e.hire_date NOT IN (
SELECT e.hire_date
FROM employees.employees e
WHERE e.hire_date >= '1990-01-01'))
ORDER BY e.last_name;



SELECT count(distinct last_name)
FROM employees;

-- Count of people with the same surname and the birth date of the older person with that surname
SELECT e.last_name, count(distinct e.first_name) as count_name, max(e.birth_date)
FROM employees.employees e, employees.departments d, employees.departments dp,  employees.dept_manager dm
WHERE e.emp_no = dm.emp_no AND dm.dept_no = d.dept_no AND d.dept_name = dp.dept_name
GROUP BY e.last_name
ORDER BY e.last_name;


-- Count of males and femals for each title
SELECT ef.title, em.Males, ef.Femals
FROM
(SELECT t.title, count(e.gender) as Femals FROM employees.employees e, employees.titles t WHERE e.emp_no = t.emp_no AND e.gender = 'F' GROUP BY t.title) ef,
(SELECT t.title, count(e.gender) as Males FROM employees.employees e, employees.titles t WHERE e.emp_no = t.emp_no AND e.gender = 'M' GROUP BY t.title) em
WHERE ef.title = em.title;


-- Salary for gender
SELECT e.gender, avg(s.salary)
FROM employees.employees e, employees.salaries s
WHERE e.emp_no = s.emp_no
GROUP BY e.gender;

-- Salary for title
SELECT t.title, avg(s.salary)
FROM employees.titles t, employees.salaries s
WHERE t.emp_no = s.emp_no
GROUP BY t.title;

/*

LEO

*/


-- retirement after 10 years
SELECT first_name, last_name
FROM employees
WHERE DATE_ADD(hire_date, interval 10 YEAR);

-- senior staff
SELECT emp_no, first_name, last_name
FROM employees
WHERE emp_no IN
    (SELECT emp_no
     FROM titles WHERE title LIKE 'Senior Staff');
     
-- salary of the employees whose salary is greater than the average salary
SELECT E.first_name, E.last_name
FROM employees E, salaries S
WHERE S.salary > (SELECT AVG(salary) FROM salaries);

-- 3rd maximum salaries of employees (?)
SELECT DISTINCT salary 
FROM salaries a 
WHERE  3 >= (SELECT COUNT(DISTINCT salary) 
FROM salaries b 
WHERE b.salary <= a.salary) 
ORDER BY a.salary DESC;

-- monthly salary
Select e.emp_no, e.first_name, e.last_name, s.salary/12 as avg_monthly_salary 
from employees e join salaries s on e.emp_no=s.emp_no;

-- first name, last name, title, department name, and first and last name of the manager
SELECT DISTINCT employees.first_name, employees.last_name,
titles.title, departments.dept_name, z.first, z.last
FROM employees, dept_emp, departments, titles, 
(
  SELECT employees.first_name AS first, employees.last_name AS last
  FROM employees, dept_emp, dept_manager 
  WHERE 
        employees.emp_no = dept_emp.emp_no 
        AND dept_manager.emp_no = dept_emp.emp_no
) AS z
WHERE
   employees.emp_no = dept_emp.emp_no 
   AND dept_emp.dept_no = departments.dept_no;

-- emp_no, name, last name, from date, to date, dept_name
SELECT e.emp_no, 
       e.first_name, 
       e.last_name, 
       de.from_date, 
       de.to_date, 
       d.dept_name 
FROM employees e
INNER JOIN dept_emp de
    ON e.emp_no = de.emp_no
INNER JOIN departments d
    ON de.dept_no = d.dept_no;
    
-- distinct departments
SELECT COUNT(DISTINCT dept_no) AS mumber_of_departments FROM dept_emp;

-- merge two tables
SELECT e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date FROM dept_manager dm, employees e 
	WHERE dm.emp_no = e.emp_no;
    
-- all possible combinations between managers from dept_manager table and department number 9
SELECT dm.*, d.* FROM departments d CROSS JOIN dept_manager dm WHERE d.dept_no = 'd009' ORDER BY d.dept_name;

-- all managers first and last name, hire date, job title, start date and department name
SELECT e.emp_no, e.first_name, e.last_name, e.hire_date, t.title, dm.from_date, d.dept_name FROM employees e 
	JOIN dept_manager dm ON e.emp_no = dm.emp_no
    JOIN departments d ON dm.dept_no = d.dept_no
    JOIN titles t ON e.emp_no = t.emp_no 
    WHERE t.title = 'Manager' ORDER BY e.emp_no;

-- number of male and female managers in the employees database
SELECT e.gender, COUNT(dm.emp_no) AS number_of_managers FROM employees e 
	JOIN dept_manager dm ON e.emp_no = dm.emp_no 
    GROUP BY gender;

-- all department managers who were hired between the January 1, 1990 and January 1, 1995
SELECT * FROM dept_manager
	WHERE emp_no IN (SELECT emp_no FROM employees WHERE hire_date BETWEEN '1990-01-01' AND '1995-01-01');


-- only ids    
SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A 
UNION SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B;
    
    
    
-- Create emp_manager table and fill using subsets created using subqueries
DROP TABLE IF EXISTS emp_manager;
CREATE TABLE emp_manager (emp_no INT(11) NOT NULL, dept_no CHAR(4) NULL, manager_no INT(11) NOT NULL);

INSERT INTO emp_manager SELECT
U.*
FROM
	(SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A 
UNION SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B UNION SELECT
    C.*
FROM 
	(SELECT
		e.emp_no AS employee_ID, 
			MIN(de.dept_no) AS department_code,
            (SELECT
					emp_no
                FROM 
					dept_manager
				WHERE 
					emp_no = 110039) AS manager_ID
	FROM employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
		e.emp_no = 110022
	GROUP BY e.emp_no
    ORDER BY e.emp_no) AS C UNION SELECT
    D.*
FROM 
	(SELECT
		e.emp_no AS employee_ID, 
			MIN(de.dept_no) AS department_code,
            (SELECT
					emp_no
                FROM 
					dept_manager
				WHERE 
					emp_no = 110022) AS manager_ID
	FROM employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
		e.emp_no = 110039
	GROUP BY e.emp_no
    ORDER BY e.emp_no) AS D) AS U;
    SELECT * FROM emp_manager;
    


/* 
	case statements
*/


-- salary increases
SELECT dm.emp_no, e.first_name, e.last_name,
	MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
		WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more than $30,000'
        WHEN MAX(s.salary) - MIN(s.salary) BETWEEN 20000 AND 30000 THEN 
									'Salary was raised by more than $20,000, but less than $30,000'
		ELSE 'Salary was raised by less than $20,000'
	END AS salary_increase
FROM dept_manager dm
	JOIN employees e ON e.emp_no = dm.emp_no
    JOIN salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no;

-- salary stagnacy
SELECT dm.emp_no, e.first_name, e.last_name,
	MAX(s.salary) - MIN(s.salary) AS salary_difference,
    IF(MAX(s.salary) - MIN(s.salary) > 30000, 'Salary was raised by more than $30,000', 
								'Salary was not raised by more than $30,000') AS salary_increase
FROM dept_manager dm
	JOIN employees e ON e.emp_no = dm.emp_no
    JOIN salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no;


-- still employed
SELECT e.emp_no, e.first_name, e.last_name,
	CASE 
		WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'
        ELSE 'No longer employed'
	END AS current_employee
FROM employees e
	JOIN dept_emp de ON de.emp_no = e.emp_no
GROUP BY de.emp_no;

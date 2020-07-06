-- Creating tables for PH-EmployeeDB
-- DROP TABLE departments, dept_employees, dept_manager, employees, salaries, titles CASCADE;

CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
 	emp_no INT NOT NULL,
 	salary INT NOT NULL,
 	from_date DATE NOT NULL,
 	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
 	PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
-- 	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_employees (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

COPY departments (dept_no, dept_name)
FROM '/Users/chrissycho/Desktop/Pewlett-Hackard-Analysis/departments.csv' WITH (FORMAT CSV, HEADER);
select * from departments;

COPY employees (emp_no,birth_date,first_name,last_name,gender,hire_date)
FROM '/Users/chrissycho/Desktop/Pewlett-Hackard-Analysis/employees.csv' DELIMITER ',' CSV HEADER;
select * from employees;

COPY dept_employees (emp_no, dept_no, from_date, to_date)
FROM '/Users/chrissycho/Desktop/Pewlett-Hackard-Analysis/dept_emp.csv' DELIMITER ',' CSV HEADER;
select * from dept_employees;

select * from dept_manager;

select * from salaries;

select * from titles;

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- 1) Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Create a new table with employees retiring
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--To check the new table
SELECT * FROM retirement_info;

--2) Add emp_no to retirement_info table
drop table retirement_info;
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

--3) Employees who already left the company
-- Joining retirement_info and dept_emp tables

SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_employees.to_date
FROM retirement_info
LEFT JOIN dept_employees
ON retirement_info.emp_no = dept_employees.emp_no;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

--3) current employees (retirement info & dept_employees tables)
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_employees as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

select * from current_emp
select count(emp_no) from current_emp

-- 4) Employee count by department number (How many employees are retiring from each dept)
SELECT COUNT(ce.emp_no), de.dept_no
INTO emp_ri
FROM current_emp as ce
LEFT JOIN dept_employees as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

select * from emp_ri
--5) employee information of those who are leaving (names, gender, salary)
drop table emp_info;
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_employees as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');

select * from emp_info
--6) A list of managers for each department
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
select * from manager_info
--7) Department Retiree

SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_employees AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

select * from dept_info

select * from current_emp
--retirement info for Sales Department
select ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO sales_info
from current_emp as ce
inner join dept_employees as de
on (ce.emp_no = de.emp_no)
inner join departments as d 
on (de.dept_no = d.dept_no)
Where de.dept_no = 'd007'

--retirees in both Sales & Department

select ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO emp_sales_dept
from current_emp as ce
inner join dept_employees as de
on (ce.emp_no = de.emp_no)
inner join departments as d 
on (de.dept_no = d.dept_no)
Where de.dept_no IN ('d005','d007')

select * from emp_sales_dept

--Number of Retiring Employees by Titles
drop table emp_title
select ce.emp_no,
ce.first_name,
ce.last_name,
ti.title,
ti.from_date,
s.salary
INTO emp_title
from current_emp as ce
inner join titles as ti
on (ce.emp_no = ti.emp_no)
inner join salaries as s
on (ce.emp_no = s.emp_no);

select * from emp_title

-- Partition the data to show only most recent title per employee
SELECT emp_no,
 first_name,
 last_name,
 title,
 from_date,
 salary
INTO recent_ti
FROM
 (SELECT emp_no,
first_name,
last_name,
title,
from_date,
salary, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY from_date DESC) rn
 FROM emp_title
 ) tmp WHERE rn = 1
ORDER BY emp_no;

select * from recent_ti

drop table emp_title_number
SELECT count(emp_no), title
INTO emp_title_number
from recent_ti
GROUP BY title

select * from emp_title_number

--Mentorship Eligibility
drop table emp_mentorship
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	de.to_date
-- INTO emp_mentorship
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
INNER JOIN dept_employees as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	 AND (de.to_date = '9999-01-01');

select count(emp_no) from emp_mentorship

--Partitioning the mentorship
drop table partition_emp_mentorship
SELECT emp_no,
	first_name,
	last_name,
	title,
	from_date
INTO partition_emp_mentorship
FROM
  (SELECT emp_no,
	first_name,
	last_name,
	title,
	from_date,
	ROW_NUMBER() OVER
(PARTITION BY (emp_no) ORDER BY from_date DESC) rn
   FROM emp_mentorship
  ) tmp WHERE rn = 1
order by emp_no;

select * from partition_emp_mentorship

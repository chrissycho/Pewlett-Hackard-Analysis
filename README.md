# Chrissy Cho's Pewlett-Hackard-Analysis
### Table of Contents
[ 1. Project Overview ](#desc)<br /> 
[ 2. Resources ](#resc)<br /> 
[ 3. Objectives ](#obj)<br /> 
[ 4. Summary ](#sum)<br /> 
[ 5. Challenge Overview ](#chal)<br /> 
[ 6. Challenge Summary ](#chalsum)<br /> 


<a name="desc"></a>
## Project Overview
In this module, we learned to explore databases with SQL. Throughout the module, we learned to build
an employee database with SQL by applying data modeling, engineering, and analysis. For data modeling, we created
entity relationship diagrams (ERDs). For data engineering, we created a database in Postgresql using GUI(pgAdmin), where we imported data and organized them into tables. We then created queries to perform analysis to determine specific conditions
for a hypothetical company, "Pewlett-Hackard." 

<a name="resc"></a>
## Resources
- Data Source: [departments.csv](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Data/departments.csv), [dept_emp.csv](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Data/dept_emp.csv), [dept_manager.csv](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Data/dept_manager.csv), [employees.csv](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Data/employees.csv), [salaries.csv](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Data/salaries.csv), [titles.csv](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Data/titles.csv)
- Software: [PostgreSQL version 12.3](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads), [pgAdmin](https://www.postgresql.org/ftp/pgadmin/pgadmin4/v4.23/macos/)
- More Information: [PostgreSQL documnetation](https://www.postgresql.org/docs/manuals/), [pgAdmin documentation](https://www.pgadmin.org/docs/)

<a name="obj"></a>
## Objectives
- Data Modeling: identify data relationships, determine entity relationships, create ERDs using [Quick Database Diagram tools](https://www.quickdatabasediagrams.com/)
- Data Engineering: create a database, create tables in SQL, import data, troubleshoot imports (errors)
- Data Analysis: perform conditional queries, join the tables, use count, groupby, and orderby, create additional lists, create a tailored list

<a name="sum"></a>
## Summary
By using Quick Database Diagram tools, we were able to identify entity relationships and create entity relationship diagrams (ERDs or schemas). 
### ERD
![](master/EmployeeDBD.png)
There are three parts of ERD: 1) conceptual diagram (the simplest form with table name and column headers), 2) logical form (conceptual diagram plus data types, primary and foreign keys), 3) physical form (physical relationships between tables). Based on the entity relationships, we can then create
tables with actual data in the postgresql and pgAdmin. On pgAdmin, we will be able to input queries to create a database to hold information of our interest. 


Throughout the module, we have created following tables (csv files):

1)	Retirement eligible screening 
- birth date from 1952-1955 and hired from 1985 to 1988
- new table: [retirement_info](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Data/retirement_info.csv)

2)	Current Employees who will be leaving (already filtered with bday & hiring date) 
- join retirement_info and dept_employees 
- add conditional statement de.to_date = (‘9999-01-01’) to select those who are still working 
- new table: [current_emp](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Data/current_emp.csv)

3)	Employee by departments (how many are leaving by each dept)
- new table current_emp and dept_employees
- group by de.dept_no and order by de.dept_no
- new table: [emp_ri](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Data/emp_ri.csv)

4)	Employee info who’s leaving
- join employees, salaries, dept_employees
- emp_no, names, gender (all from employees table), salary (from salary table), to_date (dept_employees) 
- Conditional statements on e.birth_date, e.hire_date and de.to_date
(Using WHERE, BETWEEN, AND) 
- new table: [emp_info](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Data/emp_info.csv)

5)	Managers info who’s leaving from each department
- join dept_manager, departments, current_emp tables
- dept_no (with dept_manager & departments) 
- emp_no (with dept_manager & current_emp)
- new table: [manager_info](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Data/manager_info.csv)

6)	Department Retirees
- who are leaving and what department
- join current_emp, dept_emp, departments
- join departments with de.dept_no = d.dept_no while ce.emp)no = de.emp_no
- Will see some emp. appearing twice
- new table: [dept_info](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Data/dept_info.csv)

7)	Sales department retirees
- join current_emp, dept_emp, departments
- condition where de.dept_no. = ‘d007’ will return Sales department only with the current employees who are eligible for retirement 
- new table: [sales_info](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Data/sales_info.csv)

8)	Retirees from both Sales & Department
- join current_emp, dept_employees, departments (d)
- join ce.emp_no & de.emp_no; de.dept_no & d.dept_no 
- new table: [emp_sales_dept](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Data/emp_sales_dept.csv)

<a name="chal"></a>
## Challenge Overview
Based on the module, we performed two additional analyses: 1) Number of Retiring Employees by Title, 2) Mentorship Eligibility.



<a name="chalsum"></a>
## Challenge Summary
1. Technical Analysis Deliverable 1:
We were instructed to find employees who were born between 1952-1955, grouped by job title. 
We wanted employee number, first & last name, title, from_date, and salary in a table. 
Since we already screened out employees who are eligible for retirement during the module. We will select columns from 
current_emp table (see #2 above). 

- Number of Retiring Employees by Title
    - [emp_title](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Challenge/emp_title.csv)
    - We selected employee number, first and last name from current_emp table, title and from_date from title table, and salary from the salary table.
    - We joined current_emp table with titles table and salaries table. 
  ![](Table%20pictures/emp_title.png) ![](Table%20pictures/emp_title%20pic.png)
    - One problem we noticed with the emp_title table is that we had duplicates of employee number because they might have changed their titles in between. Thus, we had to perform a query to partition the data to show only most recent title per employee. 

- Most recent title per retiring employee
    - [rent_ti](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Challenge/recent_ti.csv)
- Number of retirees by each title (Only accounted for recent title)
    - [emp_title_number](https://github.com/chrissycho/Pewlett-Hackard-Analysis/blob/master/Challenge/emp_title_number.csv)

2.  







In your first paragraph, introduce the problem that you were using data to solve.
In your second paragraph, summarize the steps that you took to solve the problem, as well as the challenges that you encountered along the way. This is an excellent spot to provide examples and descriptions of the code that you used.
In your final paragraph, share the results of your analysis and discuss the data that you’ve generated. Have you identified any limitations to the analysis? What next steps would you recommend?




Delivering Results: A README.md in the form of a technical report that details your analysis and findings
Technical Analysis Deliverable 1: Number of Retiring Employees by Title. You will create three new tables, one showing number of [titles] retiring, one showing number of employees with each title, and one showing a list of current employees born between Jan. 1, 1952 and Dec. 31, 1955. New tables are exported as CSVs. 
Technical Analysis Deliverable 2: Mentorship Eligibility. A table containing employees who are eligible for the mentorship program You will submit your table and the CSV containing the data (and the CSV containing the data

In your first paragraph, introduce the problem that you were using data to solve.
In your second paragraph, summarize the steps that you took to solve the problem, as well as the challenges that you encountered along the way. This is an excellent spot to provide examples and descriptions of the code that you used.
In your final paragraph, share the results of your analysis and discuss the data that you’ve generated. Have you identified any limitations to the analysis? What next steps would you recommend?

Be sure to include an image of the ERD you created when mapping out the database in your README.md.
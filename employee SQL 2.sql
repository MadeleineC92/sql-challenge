--add csv's into tables - make primary keys 

set datestyle TO 'ISO,DMY';

CREATE TABLE "departments1" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "prk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
	CONSTRAINT "prk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "employees1" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR  NOT NULL,
    "birth_date" TEXT   NOT NULL,
    "first_name" VARCHAR  NOT NULL,
    "last_name" VARCHAR  NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" TEXT  NOT NULL,
    CONSTRAINT "prk_employees" PRIMARY KEY (
        "emp_no"
     )
); 

SET datestyle TO 'ISO, MDY';

ALTER TABLE employees1
    ALTER COLUMN hire_date TYPE DATE USING hire_date::DATE;
	
ALTER TABLE employees1
    ALTER COLUMN birth_date TYPE DATE USING hire_date::DATE;

select * from employees1


CREATE TABLE "salaries" (
     "emp_no" int   NOT NULL,
     "salary" int   NOT NULL
);

 CREATE TABLE "dept_emp" (
     "emp_no" int   NOT NULL,
     "dept_no" varchar   NOT NULL
);

 CREATE TABLE "dept_manager" (
     "dept_no" varchar   NOT NULL,
     "emp_no" int   NOT NULL
);

ALTER TABLE "employees1" ADD CONSTRAINT "forkey_employees_title" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_emp" ADD CONSTRAINT "forkey_deptemp_empno" FOREIGN KEY("emp_no")
REFERENCES "employees1" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "forkey_depart_deptem" FOREIGN KEY("dept_no")
REFERENCES "departments1" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "forkey_deptman_depart" FOREIGN KEY("dept_no")
REFERENCES "departments1" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "forkey_deptman_empl" FOREIGN KEY("emp_no")
REFERENCES "employees1" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "forkey_sal_empl" FOREIGN KEY("emp_no")
REFERENCES "employees1" ("emp_no");

--questions and answers 

-- List the employee number, last name, first name, sex, and salary of each employee.
	--get emp_no, last_name, first_name, sex from employees table 
		-- get salary from Salaries table 
			--common- emp_no
SELECT 
	employees1.emp_no, 
	employees1.last_name, 
	employees1.first_name, 
	employees1.sex, salaries.salary
FROM employees1
JOIN salaries ON employees1.emp_no = salaries.emp_no;

-- List the first name, last name, and hire date for the employees who were hired in 1986.
	-- all from salaries 
		--use where to find date 
select 
	employees1.last_name, 
	employees1.first_name,
	employees1.hire_date
from employees1
where extract(year from employees1.hire_date) = 1986;

-- List the manager of each department along with their department number, department name, employee number, last name, and first name.
	-- get dept_no, Dept Name from departments
	 	-- get emp_no, last and first name from employees
			-- common join emp_no for employyee and dept manager then dept manager with departments 
select 
	departments1.dept_no,
	departments1.dept_name,
	employees1.emp_no,
	employees1.last_name,
	employees1.first_name
from dept_manager
join employees1
on dept_manager.emp_no = employees1.emp_no
join departments1
on dept_manager.dept_no = departments1.dept_no;


-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
		-- dep manager, department and employees 
select 
	departments1.dept_no,
	employees1.emp_no,
	employees1.last_name,
	employees1.first_name,
	departments1.dept_name
from dept_manager
join employees1
on dept_manager.emp_no = employees1.emp_no
join departments1
on dept_manager.dept_no = departments1.dept_no;
	
-- List the first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
select 
	employees1.last_name,
	employees1.first_name,
	employees1.sex
from employees1
where employees1.first_name = 'Hercules' and employees1.last_name like 'B%'
;


-- List each employee in the Sales department, including their employee number, last name, and first name.
	--common link emp no and dept no 
select 
	employees1.emp_no,
	employees1.last_name,
	employees1.first_name,
	departments1.dept_name
from employees1
join dept_emp
on employees1.emp_no = dept_emp.emp_no
join departments1 
on dept_emp.dept_no = departments1.dept_no
where departments1.dept_name = 'Sales';
-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
		-- common emp no and dept no 

select 
	employees1.emp_no,
	employees1.last_name,
	employees1.first_name,
	departments1.dept_name
from employees1
join dept_emp
on employees1.emp_no = dept_emp.emp_no
join departments1 
on dept_emp.dept_no = departments1.dept_no
where departments1.dept_name = 'Sales' or departments1.dept_name ='Development';

-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).

SELECT last_name, COUNT(last_name) as frequency
FROM employees1
GROUP BY last_name
ORDER BY frequency DESC;



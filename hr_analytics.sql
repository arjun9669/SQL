-- 🧑‍💼 HR Analytics – SQL Case Study
-- Author: Arjun | Date: 2025-04-21

-- -----------------------------
-- 🧱 Schema Setup
-- -----------------------------

CREATE DATABASE IF NOT EXISTS hr_analytics;
USE hr_analytics;

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(100),
    salary DECIMAL(10, 2),
    hire_date DATE,
    attrition ENUM('Yes', 'No') DEFAULT 'No'
);

-- -----------------------------
-- 📥 Sample Data
-- -----------------------------

INSERT INTO employees (name, department, salary, hire_date, attrition) VALUES
('Arjun', 'IT', 60000, '2020-01-15', 'No'),
('Sneha', 'HR', 50000, '2019-03-12', 'Yes'),
('Ravi', 'Finance', 75000, '2018-07-10', 'No'),
('Priya', 'IT', 65000, '2021-04-25', 'No'),
('Meera', 'HR', 52000, '2020-06-20', 'Yes'),
('Karan', 'Finance', 72000, '2017-09-30', 'No'),
('Simran', 'Marketing', 58000, '2022-01-10', 'No'),
('Rahul', 'Marketing', 59000, '2023-02-01', 'Yes');

-- -----------------------------
-- 📊 Analysis Queries
-- -----------------------------

-- 1. Highest paid employee per department
SELECT department, name, salary
FROM employees e
WHERE salary = (
  SELECT MAX(salary)
  FROM employees
  WHERE department = e.department
);

-- 2. Attrition count by department
SELECT department, COUNT(*) AS attrition_count
FROM employees
WHERE attrition = 'Yes'
GROUP BY department;

-- 3. Average salary by department
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;

-- 4. Departments with most hires after 2021
SELECT department, COUNT(*) AS new_hires
FROM employees
WHERE hire_date > '2021-01-01'
GROUP BY department
ORDER BY new_hires DESC;

-- 5. Employees who left with salary > ₹55,000
SELECT name, department, salary
FROM employees
WHERE attrition = 'Yes' AND salary > 55000;

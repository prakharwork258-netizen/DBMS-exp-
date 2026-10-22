CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2),
    manager_id INT NULL,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
    FOREIGN KEY (manager_id) REFERENCES Employee(emp_id)
);

INSERT INTO Department (dept_id, dept_name, location)
VALUES
(1, 'IT', 'Delhi'),
(2, 'HR', 'Mumbai'),
(3, 'Finance', 'Bangalore'),
(4, 'Marketing', 'Pune'),
(5, 'Operations', 'Lucknow');

INSERT INTO Employee (emp_id, emp_name, salary, manager_id, dept_id)
VALUES
(101, 'Amit', 90000, NULL, 1),
(102, 'Neha', 85000, NULL, 2),
(103, 'Rahul', 95000, NULL, 3),
(104, 'Priya', 80000, NULL, 4),
(105, 'Vikas', 88000, NULL, 5);

INSERT INTO Employee (emp_id, emp_name, salary, manager_id, dept_id)
VALUES
(106, 'Arjun', 60000, 101, 1),
(107, 'Riya', 55000, 101, 1),
(108, 'Karan', 65000, 101, 1),
(109, 'Simran', 52000, 102, 2),
(110, 'Pooja', 58000, 102, 2),
(111, 'Ankit', 50000, 102, 2),
(112, 'Rohit', 70000, 103, 3),
(113, 'Sneha', 62000, 103, 3),
(114, 'Manish', 58000, 103, 3),
(115, 'Kavya', 54000, 104, 4),
(116, 'Nitin', 59000, 104, 4),
(117, 'Shreya', 61000, 104, 4),
(118, 'Deepak', 57000, 105, 5),
(119, 'Anjali', 53000, 105, 5),
(120, 'Mohit', 60000, 105, 5),
(121, 'Varun', 48000, 106, 1),
(122, 'Isha', 47000, 107, 1),
(123, 'Aman', 49000, 109, 2),
(124, 'Tanya', 46000, 110, 2),
(125, 'Raj', 51000, 112, 3),
(126, 'Nisha', 50000, 113, 3),
(127, 'Yash', 45000, 115, 4),
(128, 'Meera', 47000, 116, 4),
(129, 'Sahil', 49000, 118, 5),
(130, 'Pallavi', 48000, 119, 5);

CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

INSERT INTO Project (project_id, project_name, dept_id)
VALUES
(201, 'Website Development', 1),
(202, 'Cloud Migration', 1),
(203, 'Recruitment System', 2),
(204, 'Payroll Management', 2),
(205, 'Financial Analysis', 3),
(206, 'Digital Marketing', 4),
(207, 'Supply Chain System', 5),
(208, 'Inventory Management', 5);

-- 1. INNER JOIN
SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employee e
INNER JOIN Department d
ON e.dept_id = d.dept_id;

-- 2. LEFT JOIN
SELECT e.emp_id, e.emp_name, d.dept_name
FROM Employee e
LEFT JOIN Department d
ON e.dept_id = d.dept_id;

-- 3. SELF JOIN
SELECT e.emp_name AS Employee,
       m.emp_name AS Manager
FROM Employee e
LEFT JOIN Employee m
ON e.manager_id = m.emp_id;

-- 4. THREE-WAY JOIN
SELECT e.emp_name, d.dept_name, p.project_name
FROM Employee e
JOIN Department d
ON e.dept_id = d.dept_id
JOIN Project p
ON d.dept_id = p.dept_id;

-- 5. CORRELATED SUBQUERY
SELECT e.emp_id, e.emp_name, e.salary
FROM Employee e
WHERE e.salary >
(
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.dept_id = e.dept_id
);

-- 6. EXISTS
SELECT d.dept_id, d.dept_name
FROM Department d
WHERE EXISTS
(
    SELECT 1
    FROM Employee e
    WHERE e.dept_id = d.dept_id
);

-- 7. SIMULATED INTERSECT
SELECT e.emp_id, e.emp_name
FROM Employee e
WHERE EXISTS
(
    SELECT 1
    FROM Project p
    WHERE p.dept_id = e.dept_id
);

-- 8. SIMULATED EXCEPT
SELECT e.emp_id, e.emp_name
FROM Employee e
WHERE NOT EXISTS
(
    SELECT 1
    FROM Project p
    WHERE p.dept_id = e.dept_id
);

-- 9. EXPLAIN
EXPLAIN
SELECT e.emp_name, d.dept_name
FROM Employee e
JOIN Department d
ON e.dept_id = d.dept_id;

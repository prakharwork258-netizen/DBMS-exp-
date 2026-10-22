
-- 1. Department Salary Summary View
CREATE VIEW Department_Salary_Summary AS
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    SUM(e.salary) AS total_salary,
    AVG(e.salary) AS average_salary
FROM Department d
LEFT JOIN Employee e
ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

SELECT *
FROM Department_Salary_Summary;

-- 2. Employee Hierarchy View
CREATE VIEW Employee_Hierarchy AS
SELECT
    e.emp_id,
    e.emp_name AS employee_name,
    e.salary,
    e.manager_id,
    m.emp_name AS manager_name
FROM Employee e
LEFT JOIN Employee m
ON e.manager_id = m.emp_id;

SELECT *
FROM Employee_Hierarchy;

-- 3. Create a Simple Updatable View
CREATE VIEW Employee_Basic AS
SELECT
    emp_id,
    emp_name,
    salary,
    dept_id
FROM Employee;

-- 4. Update the View
UPDATE Employee_Basic
SET salary = 60000
WHERE emp_id = 101;

-- 5. Check Original Table
SELECT *
FROM Employee
WHERE emp_id = 101;

-- 6. Recursive CTE
WITH RECURSIVE EmployeeChain AS
(
    -- Anchor Query
    SELECT
        emp_id,
        emp_name,
        manager_id,
        0 AS level
    FROM Employee
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive Query
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        ec.level + 1
    FROM Employee e
    INNER JOIN EmployeeChain ec
    ON e.manager_id = ec.emp_id
)
SELECT
    emp_id,
    emp_name,
    manager_id,
    level
FROM EmployeeChain
ORDER BY level, emp_id;

-- 7. Display Reporting Chain with Indentation
WITH RECURSIVE EmployeeChain AS
(
    -- First level: Employees who have no manager
    SELECT
        emp_id,
        emp_name,
        manager_id,
        0 AS level
    FROM Employee
    WHERE manager_id IS NULL

    UNION ALL

    -- Next levels: Employees reporting to previous employees
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        ec.level + 1
    FROM Employee e
    INNER JOIN EmployeeChain ec
    ON e.manager_id = ec.emp_id
)
SELECT
    emp_id,
    CONCAT(REPEAT(' ', level), emp_name) AS employee_hierarchy,
    manager_id,
    level
FROM EmployeeChain
ORDER BY level, emp_id;

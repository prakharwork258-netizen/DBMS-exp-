
-- 1. Create Salary Audit Table
CREATE TABLE Salary_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Salary_Audit (emp_id, old_salary, new_salary)
VALUES
(106, 55000, 60000),
(107, 50000, 55000),
(108, 60000, 65000),
(109, 48000, 52000),
(110, 55000, 58000);

-- 2. Stored Procedure
DELIMITER $$

CREATE PROCEDURE transfer_employee(
    IN p_emp_id INT,
    IN p_new_dept_id INT
)
BEGIN
    DECLARE v_old_dept_id INT;
    DECLARE v_employee_count INT;
    DECLARE v_department_count INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Check employee
    SELECT COUNT(*)
    INTO v_employee_count
    FROM Employee
    WHERE emp_id = p_emp_id;

    IF v_employee_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee does not exist';
    END IF;

    -- Check department
    SELECT COUNT(*)
    INTO v_department_count
    FROM Department
    WHERE dept_id = p_new_dept_id;

    IF v_department_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Department does not exist';
    END IF;

    -- Get current department
    SELECT dept_id
    INTO v_old_dept_id
    FROM Employee
    WHERE emp_id = p_emp_id;

    -- Check same department
    IF v_old_dept_id = p_new_dept_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Employee is already in this department';
    END IF;

    -- Transfer employee
    UPDATE Employee
    SET dept_id = p_new_dept_id
    WHERE emp_id = p_emp_id;

    COMMIT;
END$$

DELIMITER ;

-- 3. Salary Validation Trigger for INSERT
DELIMITER $$

CREATE TRIGGER validate_employee_salary
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Salary must be greater than zero';
    END IF;
END$$

DELIMITER ;

-- 4. Salary Validation Trigger for UPDATE
DELIMITER $$

CREATE TRIGGER validate_salary_update
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Updated salary must be greater than zero';
    END IF;
END$$

DELIMITER ;

-- 5. Salary Audit Trigger
DELIMITER $$

CREATE TRIGGER salary_audit
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO Salary_Audit
            (emp_id, old_salary, new_salary)
        VALUES
            (NEW.emp_id, OLD.salary, NEW.salary);
    END IF;
END$$

DELIMITER ;

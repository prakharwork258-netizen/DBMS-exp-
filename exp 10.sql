
CREATE DATABASE QueryOptimizationDB;
USE QueryOptimizationDB;

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    City VARCHAR(50),
    Category VARCHAR(50),
    Quantity INT,
    Amount DECIMAL(10,2),
    SaleDate DATE
);

-- Generate 10,000 records
DELIMITER //

CREATE PROCEDURE GenerateSales()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 10000 DO
        INSERT INTO Sales VALUES (
            i,
            1 + (i % 1000),
            1 + (i % 100),
            CASE
                WHEN i % 4 = 0 THEN 'Delhi'
                WHEN i % 4 = 1 THEN 'Mumbai'
                WHEN i % 4 = 2 THEN 'Chennai'
                ELSE 'Pune'
            END,
            CASE
                WHEN i % 3 = 0 THEN 'Electronics'
                WHEN i % 3 = 1 THEN 'Clothing'
                ELSE 'Furniture'
            END,
            1 + (i % 10),
            100 + (i % 5000),
            DATE_ADD('2024-01-01', INTERVAL (i % 730) DAY)
        );

        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

CALL GenerateSales();
DROP PROCEDURE GenerateSales();

SELECT COUNT(*) AS TotalRecords FROM Sales;

-- QUERY 1: Search by city
EXPLAIN
SELECT * FROM Sales
WHERE City = 'Delhi';

-- QUERY 2: Search by category and amount
EXPLAIN
SELECT * FROM Sales
WHERE Category = 'Electronics'
AND Amount > 2000;

-- QUERY 3: Search by customer and date
EXPLAIN
SELECT * FROM Sales
WHERE CustomerID = 101
AND SaleDate >= '2025-01-01';

-- QUERY 4: Search using a function on date
EXPLAIN
SELECT * FROM Sales
WHERE YEAR(SaleDate) = 2025;

-- QUERY 5: Group and sort sales
EXPLAIN
SELECT City, SUM(Amount) AS TotalSales
FROM Sales
GROUP BY City
ORDER BY TotalSales DESC;

-- OPTIMIZATION: Create indexes
CREATE INDEX idx_city ON Sales(City);

CREATE INDEX idx_category_amount
ON Sales(Category, Amount);

CREATE INDEX idx_customer_date
ON Sales(CustomerID, SaleDate);

CREATE INDEX idx_sale_date
ON Sales(SaleDate);

-- ANALYZE TABLE
ANALYZE TABLE Sales;

-- OPTIMIZED QUERY 1
EXPLAIN
SELECT * FROM Sales
WHERE City = 'Delhi';

-- OPTIMIZED QUERY 2
EXPLAIN
SELECT * FROM Sales
WHERE Category = 'Electronics'
AND Amount > 2000;

-- OPTIMIZED QUERY 3
EXPLAIN
SELECT * FROM Sales
WHERE CustomerID = 101
AND SaleDate >= '2025-01-01';

-- OPTIMIZED QUERY 4: Rewrite to use index
EXPLAIN
SELECT * FROM Sales
WHERE SaleDate >= '2025-01-01'
AND SaleDate < '2026-01-01';

-- OPTIMIZED QUERY 5
EXPLAIN
SELECT City, SUM(Amount) AS TotalSales
FROM Sales
GROUP BY City
ORDER BY TotalSales DESC;

-- Measure actual execution time and plan
EXPLAIN ANALYZE
SELECT * FROM Sales
WHERE City = 'Delhi';

EXPLAIN ANALYZE
SELECT * FROM Sales
WHERE Category = 'Electronics'
AND Amount > 2000;

EXPLAIN ANALYZE
SELECT * FROM Sales
WHERE CustomerID = 101
AND SaleDate >= '2025-01-01';

EXPLAIN ANALYZE
SELECT * FROM Sales
WHERE SaleDate >= '2025-01-01'
AND SaleDate < '2026-01-01';

EXPLAIN ANALYZE
SELECT City, SUM(Amount) AS TotalSales
FROM Sales
GROUP BY City
ORDER BY TotalSales DESC;

-- View indexes
SHOW INDEX FROM Sales;

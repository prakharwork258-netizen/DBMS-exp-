
CREATE DATABASE RailwayDB;
USE RailwayDB;

CREATE TABLE RailwayBooking (
    BookingID INT PRIMARY KEY,
    PassengerName VARCHAR(50),
    TrainNo INT,
    Source VARCHAR(50),
    Destination VARCHAR(50),
    BookingDate DATE,
    SeatNo INT,
    Fare DECIMAL(10,2)
);

DELIMITER //

CREATE PROCEDURE InsertBookings()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 5000 DO
        INSERT INTO RailwayBooking
        VALUES (
            i,
            CONCAT('Passenger', i),
            100 + (i % 20),
            CASE WHEN i % 3 = 0 THEN 'Delhi'
                 WHEN i % 3 = 1 THEN 'Mumbai'
                 ELSE 'Chennai' END,
            CASE WHEN i % 3 = 0 THEN 'Jaipur'
                 WHEN i % 3 = 1 THEN 'Pune'
                 ELSE 'Kolkata' END,
            DATE_ADD('2025-01-01', INTERVAL (i % 365) DAY),
            1 + (i % 100),
            500 + (i % 2000)
        );

        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

CALL InsertBookings();
DROP PROCEDURE InsertBookings;

SELECT COUNT(*) AS TotalRecords FROM RailwayBooking;

-- 1. Benchmark before creating indexes
EXPLAIN
SELECT * FROM RailwayBooking
WHERE TrainNo = 105;

EXPLAIN
SELECT * FROM RailwayBooking
WHERE Source = 'Delhi'
AND Destination = 'Jaipur';

-- 2. Create single-column indexes
CREATE INDEX idx_train
ON RailwayBooking(TrainNo);

CREATE INDEX idx_source
ON RailwayBooking(Source);

-- 3. Benchmark after single-column indexes
EXPLAIN
SELECT * FROM RailwayBooking
WHERE TrainNo = 105;

EXPLAIN
SELECT * FROM RailwayBooking
WHERE Source = 'Delhi'
AND Destination = 'Jaipur';

-- 4. Create composite index
CREATE INDEX idx_source_destination
ON RailwayBooking(Source, Destination);

-- 5. Benchmark after composite index
EXPLAIN
SELECT * FROM RailwayBooking
WHERE Source = 'Delhi'
AND Destination = 'Jaipur';

-- 6. Compare actual query execution time
EXPLAIN ANALYZE
SELECT * FROM RailwayBooking
WHERE TrainNo = 105;

EXPLAIN ANALYZE
SELECT * FROM RailwayBooking
WHERE Source = 'Delhi'
AND Destination = 'Jaipur';

-- 7. Display all indexes
SHOW INDEX FROM RailwayBooking;

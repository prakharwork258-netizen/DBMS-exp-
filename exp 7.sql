
CREATE TABLE Customers (
    CustomerID VARCHAR(10) PRIMARY KEY,
    CustomerName VARCHAR(50)
);

CREATE TABLE Products (
    ProductID VARCHAR(10) PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID VARCHAR(10),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID VARCHAR(10),
    Qty INT,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Customers VALUES
('C1', 'Rahul'),
('C2', 'Aman');

INSERT INTO Products VALUES
('P1', 'Laptop', 50000),
('P2', 'Mouse', 500),
('P3', 'Keyboard', 1000);

INSERT INTO Orders VALUES
(101, 'C1'),
(102, 'C2'),
(103, 'C1');

INSERT INTO OrderDetails VALUES
(101, 'P1', 1),
(101, 'P2', 2),
(102, 'P1', 1),
(103, 'P3', 1);

SELECT O.OrderID, O.CustomerID, C.CustomerName,
       D.ProductID, P.ProductName, D.Qty, P.Price
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN OrderDetails D ON O.OrderID = D.OrderID
JOIN Products P ON D.ProductID = P.ProductID;

SELECT OrderID, CustomerID
FROM Orders
WHERE CustomerID NOT IN (
    SELECT CustomerID FROM Customers
);

SELECT OrderID, ProductID
FROM OrderDetails
WHERE ProductID NOT IN (
    SELECT ProductID FROM Products
);

-- 1. CREATE TABLE: Create the Customers table.
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50),
    join_date DATE,
    phone_number VARCHAR(15) UNIQUE
);

-- 2. CREATE TABLE: Create the Orders table and set up the foreign key constraint for customer_id.
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 3. CREATE TABLE: Create the Suppliers table.
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50)
);


-- 4. CREATE TABLE: Create the Products table with a foreign key referencing Suppliers.
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    supplier_id INT,
    stock_quantity INT NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- Insert data into Customers table
INSERT INTO Customers (customer_id, first_name, last_name, email, city, join_date, phone_number)
VALUES
(1, 'John', 'Doe', 'john.doe@example.com', 'New York', '2023-06-15', '1234567890'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', 'Los Angeles', '2024-02-01', '2345678901'),
(3, 'Michael', 'Johnson', 'michael.johnson@example.com', 'Chicago', '2023-12-20', '3456789012'),
(4, 'Sarah', 'Davis', 'sarah.davis@example.com', 'New York', '2022-08-10', '4567890123'),
(5, 'Emma', 'Wilson', 'emma.wilson@example.com', 'San Francisco', '2023-09-23', '5678901234');

-- Insert data into Orders table
INSERT INTO Orders (order_id, customer_id, order_date, total_amount)
VALUES
(101, 1, '2024-01-05', 350.00),
(102, 2, '2024-02-15', 220.00),
(103, 3, '2023-12-25', 450.00),
(104, 1, '2024-03-01', 300.00),
(105, 5, '2023-09-27', 500.00);


-- Insert data into Suppliers table
INSERT INTO Suppliers (supplier_id, supplier_name, contact_email, city)
VALUES
(301, 'ABC Suppliers', 'contact@abc.com', 'New York'),
(302, 'XYZ Distributors', 'contact@xyz.com', 'Chicago'),
(303, 'Global Tech Supplies', 'info@globaltech.com', 'San Francisco');


-- Insert data into Products table
INSERT INTO Products (product_id, product_name, price, supplier_id, stock_quantity)
VALUES
(201, 'Wireless Earbuds', 150.00, 301, 25),
(202, 'Bluetooth Speaker', 120.00, 302, 10),
(203, 'Laptop Stand', 50.00, 303, 100),
(204, 'Mechanical Keyboard', 200.00, 301, 15),
(205, 'USB-C Hub', 80.00, 302, 5),
(206, 'Noise-Cancelling Headphones', 220.00, 301, 8),
(207, 'Portable Charger', 40.00, 303, 60);

--   Questions


-- 1. CREATE TABLE: Create the Customers table with the structure provided.
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50),
    join_date DATE,
    phone_number VARCHAR(15) UNIQUE
);

-- 2. CREATE TABLE: Create the Orders table with a foreign key constraint for customer_id.
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 3. ALTER TABLE: Add a new column phone_number with a unique constraint.
ALTER TABLE Customers
ADD phone_number VARCHAR(15) UNIQUE;

-- 4. DELETE: Delete records from the Customers table where the city is NULL.
DELETE FROM Customers
WHERE city IS NULL;

-- 5. UPDATE: Increase the total_amount of all orders placed after January 1, 2024, by 10%.
UPDATE Orders
SET total_amount = total_amount * 1.10
WHERE order_date > '2024-01-01';

-- 6. UPDATE: Update stock_quantity in Products for a product supplied by 'ABC Suppliers' to 50.
UPDATE Products
SET stock_quantity = 50
WHERE supplier_id = (SELECT supplier_id FROM Suppliers WHERE supplier_name = 'ABC Suppliers');

-- 7. Constraints: Add a check constraint to ensure price is greater than 0 in Products.
ALTER TABLE Products
ADD CONSTRAINT chk_price_positive CHECK (price > 0);

-- 8. WHERE Clause: Retrieve all customers who joined after July 1, 2023, and reside in "New York".
SELECT * FROM Customers
WHERE join_date > '2023-07-01' AND city = 'New York';

-- 9. WHERE Clause: Find all products with stock_quantity less than 10.
SELECT * FROM Products
WHERE stock_quantity < 10;

-- 10. DISTINCT: Retrieve a list of unique cities where suppliers are located.
SELECT DISTINCT city FROM Suppliers;

-- 11. ORDER BY: Retrieve all orders sorted by order_date in descending order.
SELECT * FROM Orders
ORDER BY order_date DESC;

-- 12. ORDER BY: Retrieve all products sorted by price in ascending order, grouped by supplier_id.
SELECT * FROM Products
ORDER BY supplier_id, price ASC;

-- 13. GROUP BY: Calculate the total amount spent by each customer.
SELECT customer_id, SUM(total_amount) AS total_spent
FROM Orders
GROUP BY customer_id;

-- 14. GROUP BY: Retrieve the average price of products provided by each supplier with at least 3 products.
SELECT supplier_id, AVG(price) AS avg_price
FROM Products
GROUP BY supplier_id
HAVING COUNT(product_id) >= 3;

-- 15. HAVING Clause: List suppliers with an average product price of more than $200.
SELECT supplier_id, AVG(price) AS avg_price
FROM Products
GROUP BY supplier_id
HAVING AVG(price) > 200;

-- 16. UPDATE with WHERE: Update product prices if below the average price in their category.
UPDATE Products p
SET price = (SELECT AVG(price) FROM Products WHERE supplier_id = p.supplier_id)
WHERE price < (SELECT AVG(price) FROM Products WHERE supplier_id = p.supplier_id);

-- 17. Complex Query: Find customers who spent more than the average spending of all customers.
SELECT customer_id, SUM(total_amount) AS total_spent
FROM Orders
GROUP BY customer_id
HAVING SUM(total_amount) > (SELECT AVG(total_amount) FROM Orders GROUP BY customer_id);

-- 18. CREATE TABLE: Create a Reviews table with constraints.
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    rating INT DEFAULT 3 CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 19. Modify Products table to add product_category with ENUM constraint.
ALTER TABLE Products
ADD product_category ENUM('Electronics', 'Accessories', 'Home Office');

-- 20. Add quantity column with a CHECK constraint to Orders table.
ALTER TABLE Orders
ADD quantity INT CHECK (quantity > 0 AND quantity <= 100);

-- 21. Set order_date in Orders table to have a default value of the current date.
ALTER TABLE Orders
MODIFY order_date DATE DEFAULT CURRENT_DATE;

-- 22. Add payment_method column with ENUM constraint to Orders.
ALTER TABLE Orders
ADD payment_method ENUM('Credit Card', 'Debit Card', 'PayPal', 'Cash') DEFAULT 'Credit Card';

-- 23. CREATE TABLE: Create Inventory table with constraints.
CREATE TABLE Inventory (
    location_id INT PRIMARY KEY,
    product_id INT,
    stock_level INT DEFAULT 0 CHECK (stock_level >= 0),
    last_restocked_date DATE,
    PRIMARY KEY (location_id, product_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);





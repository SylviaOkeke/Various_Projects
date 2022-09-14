-- Playing with the data from the Customers table

-- Searching
-- First name are Elka or Ambur

SELECT * 
FROM sql_store.customers
WHERE first_name REGEXP 'Elka|Ambur'

-- Last name ends with EY or ON

SELECT * 
FROM sql_store.customers
WHERE last_name REGEXP 'ey$|on$'

-- Last name start with MY or contains SE

SELECT * 
FROM sql_store.customers
WHERE last_name REGEXP '^my|se'

-- Last name contain B followed by R or U

SELECT * 
FROM sql_store.customers
WHERE last_name REGEXP 'b[ru]'

-- Customers who doesn't have a phone number in the table

SELECT * 
FROM sql_store.customers
WHERE phone IS NULL

-- Customers who have a phone number in the table

SELECT * 
FROM sql_store.customers
WHERE phone IS NOT NULL

-- Orders that are not shipped yet

SELECT * 
FROM sql_store.orders
WHERE shipped_date IS NULL
ORDER BY order_date ASC

-- Select all the items for order with ID2 and sort them by their total price in desc order

SELECT *, quantity * unit_price AS total_price
FROM sql_store.order_items
WHERE order_id = 2
ORDER BY total_price DESC

-- Limit Operator, retrieve customers on page 3
-- page 1: 1 - 3
-- page 2: 4 - 6
-- page 3: 7 - 9
SELECT *
FROM sql_store.customers
LIMIT 6, 3

-- Get the top 3 loyal customers (that have more points than anyone else)

SELECT first_name, last_name, points
FROM sql_store.customers
ORDER BY points DESC
LIMIT 3

-- Select the orders in the orders table but instead of showing the customer id, we show full name for each customer

SELECT order_id, orders.customer_id, first_name, last_name 
FROM sql_store.orders
	INNER JOIN customers ON orders.customer_id = customers.customer_id

-- You can use aliases for the tables

SELECT order_id, o.customer_id, first_name, last_name 
FROM sql_store.orders o
	INNER JOIN customers c ON o.customer_id = c.customer_id

/* Join order_items and products table so for each order return both the product id as well as this name, 
followed by the quantity and the unit price from the order items table*/

SELECT order_id, oi.product_id, quantity, oi.unit_price
FROM order_items oi
	JOIN products p ON oi.product_id = p.product_id

-- We want to join products table from sql_inventory database with the order_items table in sql_store database

SELECT *
FROM order_items oi
	JOIN sql_inventory.products p 
		ON oi.product_id = p.product_id
        
/*Self joins
We want to see the manager for every employee, all from the same table*/

USE sql_hr;

SELECT 
e.employee_id,
e.first_name,
m.first_name AS manager
FROM employees e
JOIN employees m
	ON e.reports_to = m.employee_id

-- Joining multiple tables

USE sql_store;

SELECT 
	o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    os.name  AS status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
JOIN order_statuses os
	ON o.status = os.order_status_id

-- Join clients, payment_methods and payments table from sql_invoicing database

SELECT
payments.date,
payments.invoice_id,
amount, 
clients.name, 
payment_methods.name AS payment_method
FROM clients
JOIN payments
	ON clients.client_id = payments.client_id
JOIN payment_methods
	ON payments.payment_method = payment_methods.payment_method_id
    
-- Compound join conditions

USE sql_store;

SELECT *
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id = oin.order_id
	AND oi.product_id = oin.product_id

-- Outer joins - left join

SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id

-- Outer joins - right join

SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM orders o
RIGHT JOIN customers c
	ON o.customer_id = c.customer_id
ORDER BY c.customer_id

/* Write a query that produces product_id (product table) / name (product table) / quantity (order_items table)
We want to see products with zero quantity as well*/

SELECT 
	p.product_id,
    p.name,
    oi.quantity
FROM products p
LEFT JOIN order_items oi
	ON p.product_id = oi.product_id

-- Outer Join Between Multiple Tables

SELECT 
	c.customer_id,
    c.first_name,
    o.order_id,
    sh.name AS shipper
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id

-- Exercise

SELECT
	o.order_date,
    o.order_id,
    c.first_name AS customer,
    sh.name AS shipper,
    os.name AS status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
LEFT JOIN order_statuses os
	ON o.status = os.order_status_id
ORDER BY status

-- Self outer joins

USE sql_hr;

SELECT 
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM employees e
LEFT JOIN employees m
	ON e.reports_to = m.employee_id
    
-- The USING Clause

USE sql_store;

SELECT
	o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders o
JOIN customers c
	-- ON o.customer_id = c.customer.id
    USING (customer_id)
LEFT JOIN shippers sh
	USING (shipper_id)
    
-- 2 primary keys

SELECT *
FROM order_items oi
JOIN order_item_notes oin
	-- ON oi.order_id = oin.order_id 
    -- AND oi.product_id = oin.product_id
    USING (order_id, product_id)

/* Write the query to select from the sql_invoicing database and 
produce table: date/client/amount/payment method(creditcard/cash)*/

USE sql_invoicing;

SELECT 
	p.date,
    c.name AS client,
    p.amount,
    pm.name as payment_method    
FROM payments p
JOIN clients c
	USING (client_id)
LEFT JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id

-- Cross joints

USE sql_store;

-- Explicit syntax

SELECT shipper_id, sh.name as shippers, p.name as products
FROM shippers sh
CROSS JOIN products p
ORDER BY shipper_id


-- Implicit syntax

SELECT shipper_id, sh.name as shippers, p.name as products
FROM shippers sh, products p
ORDER BY shipper_id

-- Unions (from the same table)

SELECT 
	order_id,
    order_date,
    'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'

UNION

SELECT 
	order_id,
    order_date,
    'Archived' AS status
FROM orders
WHERE order_date <= '2019-01-01'

-- Unions (from different tables)

SELECT first_name
FROM customers
UNION
SELECT name
FROM shippers

/* Exercise: Write a query for the report 
(customer_id, first_name, points, type(bronze/silver/gold)
<2000 points = bronze,
200-3000 points = silver,
>3000 points = gold*/

SELECT 
	customer_id, 
    first_name, 
    points, 
    'Bronze' AS type
FROM customers
WHERE points < 2000

UNION

SELECT 
	customer_id, 
    first_name, 
    points, 
    'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000

UNION

SELECT 
	customer_id, 
    first_name, 
    points, 'Gold' AS type
FROM customers
WHERE points > 3000

ORDER BY first_name

-- Insert single row

INSERT INTO customers
VALUES (DEFAULT, 'John', 'Smith', '1990-01-01', NULL, 'address', 'city', 'UT', DEFAULT)

-- Insert multiple rows in one go

INSERT INTO shippers (name)
VALUES 
	('Shipper1'),
    ('Shipper2'),
    ('Shipper3')

-- Insert multiple rows in the products table

USE sql_inventory;

INSERT INTO products (name, quantity_in_stock, unit_price)
VALUES
	('Onion', 50, 0.45),
    ('Strawberries', 30, 0.75)

-- How to insert data in multiple tables

USE sql_store;

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-02', 1);

INSERT INTO order_items
VALUES	(LAST_INSERT_ID(), 1, 1, 2.95),
		(LAST_INSERT_ID(), 2, 1, 3.95)
        
-- Copy data from one table to another

CREATE TABLE orders_archived AS 
SELECT *
FROM orders

/* We want to copy only a subset of records from the orders table 
(only order placed before 2019.) into orders_archived table*/

INSERT INTO orders_archived
	SELECT *
	FROM orders
	WHERE order_date < '2019-01-01'
    
/* We want to create copy of the records in the invoices table 
and put them in a new table called invoices archive
In that table, instead of client_id column, we want to have the client name column 
so we need to join this table with the clients table and then use that query as a 
subquery in a create table statement
Also, copy only the invoices that do have a payment*/

CREATE TABLE invoices_arhive AS
	SELECT 
		i.invoice_id,
		i.number,
		c.name AS client,
		i.invoice_total,
		i.payment_total,
		i.invoice_date,
		i.due_date,
		i.payment_date
	FROM invoices i
	JOIN clients c
		USING (client_id)
	WHERE payment_total > 0

-- Update a single row in the table

UPDATE invoices
SET 
	payment_total = 10, 
    payment_date = '2019-01-01'
WHERE invoice_id = 1

-- or

UPDATE invoices
SET 
	payment_total = invoice_total *0.5, 
    payment_date = due_date
WHERE client_id IN (3,4)

-- Write a SQL statement to give any customers born before 1990, 15 extra points 
USE sql_store;

UPDATE customers
SET points = points + 15
WHERE birth_date < '1990-01-01'

-- Using subqueries in updates
UPDATE invoices
SET 
	payment_total = invoice_total *0.5, 
    payment_date = due_date
WHERE client_id =
			(SELECT client_id
			FROM clients
			WHERE name = 'Myworks')
            
-- or

UPDATE invoices
SET 
	payment_total = invoice_total *0.5, 
    payment_date = due_date
WHERE client_id IN
			(SELECT client_id
			FROM clients
			WHERE state IN ('CA', 'NY'))
            
-- Write a SQL statement to update the comments in the orders table for customers who have more than 3000 points (Gold customer)

UPDATE orders
SET comments = 'Gold'
WHERE customer_id IN  
		(SELECT customer_id
		FROM customers
        WHERE points > 3000)
        
-- Deleting rows

USE sql_invoicing;

DELETE FROM invoices
WHERE client_id = (
	SELECT client_id
	FROM clients
	WHERE name = 'MyWorks')

-- Summarizing data

SELECT
	MAX(invoice_total) AS highest,
    MIN(invoice_total) AS lowest,
    AVG(invoice_total) AS average,
    SUM(invoice_total*1.1) AS total,
    COUNT(DISTINCT client_id) AS total_records
FROM invoices

-- Writing a query against the invoice table to generate the report
-- 4 columns: date_range, total_sales, total_payments, what_we_expect (difference between the last two columns)

SELECT
	'First half of 2019' AS date_range,
	SUM(invoice_total) AS total_sales,
	SUM(payment_total) AS total_payments,
	SUM(invoice_total-payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date 
	BETWEEN '2019-01-01' AND '2019-06-30'
    
UNION

SELECT
	'Second half of 2019' AS date_range,
	SUM(invoice_total) AS total_sales,
	SUM(payment_total) AS total_payments,
	SUM(invoice_total-payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date 
	BETWEEN '2019-07-01' AND '2019-12-31'
    
UNION

SELECT
	'Total' AS date_range,
	SUM(invoice_total) AS total_sales,
	SUM(payment_total) AS total_payments,
	SUM(invoice_total-payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date 
	BETWEEN '2019-01-01' AND '2019-12-31'

-- The GROUP BY Clause

SELECT
	state,
    city,
	SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients USING (client_id)
GROUP BY state,city

-- Writing a query against the payments table that generates report:
-- Colums: date, payment_method, total_payments

SELECT 
	date,
	name AS payment_method,
    SUM(amount) AS total_payments
FROM payments p
JOIN payment_methods pm ON p.payment_method = pm.payment_method_id
GROUP BY payment_method, date
ORDER BY date

-- The HAVING Clause

SELECT
	client_id,
	SUM(invoice_total) AS total_sales,
    COUNT(*) as number_of_invoices
FROM invoices 
GROUP BY client_id
HAVING total_sales > 500 AND number_of_invoices > 5

-- Get the customers from SQL Store Database who are located in Virginia and who spent more than $100

USE sql_store;

SELECT
	c.customer_id,
	c.first_name,
    c.last_name,
    state,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM customers c
JOIN orders o
	USING (customer_id)
JOIN order_items oi
	USING (order_id)
WHERE state = 'VA'
GROUP BY 
	c.customer_id, 
    c.first_name, 
    c.last_name
HAVING total_sales > 100

-- The ROLLUP Operator

SELECT 
state,
city,
SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients c USING (client_id)
GROUP BY state, city WITH ROLLUP

-- Exercize
SELECT 
	pm.name AS payment_method,
    SUM(amount) AS total
FROM payments p
JOIN payment_methods pm 
	ON p.payment_method = pm.payment_method_id
GROUP BY pm.name WITH ROLLUP

-- Subqueries

-- Find products that are more expensive than Lettuce (id=3)

USE sql_store;

SELECT *
FROM products
WHERE unit_price > (
	SELECT unit_price
    FROM products
    WHERE product_id = 3
)

-- In sql_hr database, find employees whose earn more than average

USE sql_hr;

SELECT *
FROM employees
WHERE salary > (
	SELECT AVG(salary)
    FROM employees
	)

-- IN Operator

-- Find the products that have never been ordered

USE sql_store;

SELECT *
FROM products
WHERE product_id NOT IN (
	SELECT DISTINCT product_id 
	FROM order_items
	)

-- In the sql_invoicing database find clients without invoices
USE sql_invoicing;

SELECT *
FROM clients
WHERE client_id NOT IN (
	SELECT DISTINCT client_id
	FROM invoices
	)
    
-- Find customers who have ordered lettuce (id=3)
-- Select customer_id, first_name, Last_name

USE sql_store;

-- Solving using joins

SELECT DISTINCT
 	customer_id, 
 	first_name, 
 	last_name
FROM customers c
JOIN orders o USING (customer_id)
JOIN order_items oi USING (order_id)
WHERE product_id = 3

-- Solving using subqueries

SELECT 
 	customer_id, 
 	first_name, 
 	last_name
FROM customers
WHERE customer_id IN (
	SELECT o.customer_id
    FROM order_items oi
    JOIN ORDERS O USING (order_id)
    WHERE product_id = 3)
    
-- Triggers and Events

DELIMITER $$

DROP TRIGGER IF EXISTS payments_after_insert;

CREATE TRIGGER payments_after_insert
	AFTER INSERT ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
    
    INSERT INTO payments_audit
    VALUES (NEW.client_id, NEW.date, NEW.amount, 'Insert', NOW());
    
END $$

DELIMITER ;

-- Update table
INSERT INTO payments
VALUES(DEFAULT,5,3,'2019-01-01',10,1);

-- Create trigger that gets fired when we delete a payment

DELIMITER $$

DROP TRIGGER IF EXISTS payments_after_delete;

CREATE TRIGGER payments_after_delete
	AFTER DELETE ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
    
        INSERT INTO payments_audit
		VALUES (OLD.client_id, OLD.date, OLD.amount, 'Delete', NOW());
    
END $$

DELIMITER ;

-- Update table
DELETE
FROM payments
WHERE payment_id = 10;

-- Update table to see change in payments_audit

INSERT INTO payments
VALUES (DEFAULT, 5, 3, '2019-01-01', 10, 1)

-- Delete record to see change in payments_audit

DELETE FROM payments
WHERE payment_id = 11


-- Show Triggers

SHOW TRIGGERS LIKE 'payments%';

-- Events

SHOW VARIABLES LIKE 'event%'

-- How to create an event

DELIMITER $$

CREATE EVENT yearly_delete_stale_audit_rows
ON SCHEDULE 
	-- AT '2019-05-01'  -- If you want to execute it only once
    -- EVERY 2 DAYS -- If you want t execute it on a regular basis, use 'EVERY'
    EVERY 1 YEAR STARTS '2019-01-01' ENDS '2029-01-01'
DO BEGIN
	DELETE FROM payments_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
END $$

DELIMITER ;

-- View events

SHOW EVENTS;

-- Transactions

USE sql_ştore;

START TRANSACTION;

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-01', 1);

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 1);

COMMIT;

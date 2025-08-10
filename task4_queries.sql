-- TASK 4 SQL Script
-- This script covers basic retrieval, filtering, aggregation, joins, subqueries, views, and indexes.

-- 1. Basic Data Retrieval
-- Example: Retrieve all data from customers
SELECT * FROM customers;

-- Filtering & Conditions
-- Find all orders after July 1, 2024
SELECT * FROM orders WHERE order_date > '2024-07-01';

-- List customers who bought more than 2 items in a single order
SELECT * FROM orders WHERE quantity > 2;

-- 2. Aggregates & Grouping
-- Total quantity sold per product
SELECT p.product_name, SUM(o.quantity) AS total_sold
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name;

-- Average order quantity per country
SELECT c.country, AVG(o.quantity) AS avg_quantity
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.country;

-- 3. JOIN Queries
-- Show customer name, product name, and order date
SELECT c.name, p.product_name, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id;

-- List all customers with their orders (including those without orders)
SELECT c.name, o.order_id, o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 4. Subqueries
-- Find products more expensive than the average price
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- List customers who have ordered 'Laptop'
SELECT name
FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM orders
    WHERE product_id = (
        SELECT product_id FROM products WHERE product_name = 'Laptop'
    )
);

-- 5. Views
-- Create a view of high-value orders (> $500 total price)
DROP VIEW IF EXISTS high_value_orders;
CREATE VIEW high_value_orders AS
SELECT o.order_id, c.name, p.product_name, (o.quantity * p.price) AS total_price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE (o.quantity * p.price) > 500;

-- Select from the view
SELECT * FROM high_value_orders;

-- Indexes
CREATE INDEX idx_product_category ON products(category);

-- Verify the index exists
SELECT * FROM products
WHERE category = 'Electronics';

-- 🛒 E-Commerce Dashboard – SQL Case Study
-- Author: Arjun | Date: 2025-04-21

-- 📁 Create Database
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- 📦 Create Tables

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    product_id INT,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 📥 Insert Data

INSERT INTO customers (name, city) VALUES
('Priya', 'Mumbai'),
('Rohan', 'Delhi'),
('Simran', 'Bangalore');

INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 55000),
('Headphones', 'Accessories', 1500),
('Shoes', 'Footwear', 2500),
('Book', 'Stationery', 300);

INSERT INTO orders (customer_id, order_date, product_id, quantity) VALUES
(1, '2024-04-01', 1, 1),
(2, '2024-04-02', 2, 2),
(3, '2024-04-05', 3, 1),
(1, '2024-04-07', 4, 3),
(2, '2024-04-09', 3, 2);

-- 📊 Analysis Queries

-- 1. Total Revenue
SELECT SUM(p.price * o.quantity) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id;

-- 2. Top 3 Products by Revenue
SELECT p.product_name, SUM(p.price * o.quantity) AS product_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY product_revenue DESC
LIMIT 3;

-- 3. Most Active Customer
SELECT c.name, COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_orders DESC
LIMIT 1;

-- 4. Revenue by Category
SELECT p.category, SUM(p.price * o.quantity) AS category_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;

-- 5. Monthly Sales Trend
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(p.price * o.quantity) AS monthly_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY month
ORDER BY month;

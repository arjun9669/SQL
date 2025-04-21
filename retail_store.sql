-- 🛒 Retail Store Sales Analytics – SQL Case Study
-- Author: Arjun | Date: 2025-04-21

-- -----------------------------
-- 🧱 Schema Setup
-- -----------------------------

CREATE DATABASE IF NOT EXISTS retail_store;
USE retail_store;

-- Customers Table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100)
);

-- Products Table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Stores Table
CREATE TABLE stores (
    store_id INT AUTO_INCREMENT PRIMARY KEY,
    store_location VARCHAR(100)
);

-- Sales Table
CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_date DATE,
    customer_id INT,
    product_id INT,
    store_id INT,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- -----------------------------
-- 📥 Sample Data
-- -----------------------------

INSERT INTO customers (customer_name, city) VALUES
('Arjun', 'Mumbai'),
('Sneha', 'Delhi'),
('Ravi', 'Bangalore');

INSERT INTO products (product_name, category, price) VALUES
('Notebook', 'Stationery', 50),
('Pen', 'Stationery', 10),
('Backpack', 'Accessories', 800),
('Water Bottle', 'Accessories', 150);

INSERT INTO stores (store_location) VALUES
('Mumbai'), ('Delhi'), ('Bangalore');

INSERT INTO sales (sale_date, customer_id, product_id, store_id, quantity) VALUES
('2024-04-01', 1, 1, 1, 5),
('2024-04-01', 1, 2, 1, 10),
('2024-04-02', 2, 3, 2, 1),
('2024-04-03', 3, 4, 3, 2),
('2024-04-04', 2, 1, 2, 2),
('2024-04-04', 3, 3, 3, 1),
('2024-04-05', 1, 4, 1, 1);

-- -----------------------------
-- 📊 Analysis Queries
-- -----------------------------

-- 1. Total revenue per store
SELECT s.store_location, SUM(p.price * sa.quantity) AS total_revenue
FROM sales sa
JOIN stores s ON sa.store_id = s.store_id
JOIN products p ON sa.product_id = p.product_id
GROUP BY s.store_location
ORDER BY total_revenue DESC;

-- 2. Best-selling product by quantity sold
SELECT p.product_name, SUM(sa.quantity) AS total_quantity_sold
FROM sales sa
JOIN products p ON sa.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- 3. Top-spending customer
SELECT c.customer_name, SUM(p.price * sa.quantity) AS total_spent
FROM sales sa
JOIN customers c ON sa.customer_id = c.customer_id
JOIN products p ON sa.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 1;

-- 4. Category-wise sales summary
SELECT p.category, SUM(sa.quantity) AS total_units_sold, SUM(p.price * sa.quantity) AS total_revenue
FROM sales sa
JOIN products p ON sa.product_id = p.product_id
GROUP BY p.category;

-- 5. Day with highest revenue
SELECT sa.sale_date, SUM(p.price * sa.quantity) AS daily_revenue
FROM sales sa
JOIN products p ON sa.product_id = p.product_id
GROUP BY sa.sale_date
ORDER BY daily_revenue DESC
LIMIT 1;

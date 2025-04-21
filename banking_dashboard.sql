-- 🏦 Banking Transactions – SQL Case Study
-- Author: Arjun | Date: 2025-04-21

-- -----------------------------
-- 🧱 Schema Setup
-- -----------------------------
CREATE DATABASE IF NOT EXISTS banking_db;
USE banking_db;

-- Customers Table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100)
);

-- Transactions Table
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    transaction_date DATE,
    transaction_type ENUM('Deposit', 'Withdrawal') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- -----------------------------
-- 📥 Insert Sample Data
-- -----------------------------

INSERT INTO customers (customer_name, city) VALUES
('Arjun', 'Mumbai'),
('Sneha', 'Delhi'),
('Vikram', 'Bangalore');

INSERT INTO transactions (customer_id, transaction_date, transaction_type, amount) VALUES
(1, '2024-04-01', 'Deposit', 5000.00),
(1, '2024-04-03', 'Withdrawal', 1000.00),
(2, '2024-04-02', 'Deposit', 8000.00),
(2, '2024-04-04', 'Withdrawal', 3000.00),
(3, '2024-04-01', 'Deposit', 10000.00),
(3, '2024-04-06', 'Withdrawal', 5000.00),
(1, '2024-04-08', 'Withdrawal', 3000.00);

-- -----------------------------
-- 📊 Analysis Queries
-- -----------------------------

-- 1. Net balance per customer
SELECT 
  c.customer_name,
  SUM(CASE WHEN t.transaction_type = 'Deposit' THEN t.amount ELSE -t.amount END) AS net_balance
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_name;

-- 2. Highest single transaction
SELECT 
  c.customer_name,
  t.amount,
  t.transaction_type,
  t.transaction_date
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
ORDER BY t.amount DESC
LIMIT 1;

-- 3. Top withdrawer
SELECT 
  c.customer_name,
  SUM(t.amount) AS total_withdrawn
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
WHERE t.transaction_type = 'Withdrawal'
GROUP BY c.customer_name
ORDER BY total_withdrawn DESC
LIMIT 1;

-- 4. Average deposit per customer
SELECT 
  c.customer_name,
  AVG(t.amount) AS avg_deposit
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
WHERE t.transaction_type = 'Deposit'
GROUP BY c.customer_name;

-- 5. Flag customers with multiple withdrawals over ₹2500
SELECT 
  c.customer_name,
  COUNT(*) AS high_value_withdrawals
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
WHERE t.transaction_type = 'Withdrawal' AND t.amount > 2500
GROUP BY c.customer_name
HAVING high_value_withdrawals > 1;

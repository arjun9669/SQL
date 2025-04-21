CREATE DATABASE IF NOT EXISTS pizza_runner;
USE pizza_runner;

-- 1. Runners Table
CREATE TABLE runners (
    runner_id INT AUTO_INCREMENT PRIMARY KEY,
    registration_date DATE NOT NULL
);

-- 2. Customer Orders Table
CREATE TABLE customer_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    pizza_id INT NOT NULL,
    exclusions TEXT,
    extras TEXT,
    order_time DATETIME NOT NULL
);

-- 3. Runner Orders Table
CREATE TABLE runner_orders (
    order_id INT PRIMARY KEY,
    runner_id INT NOT NULL,
    pickup_time DATETIME,
    distance VARCHAR(10),
    duration VARCHAR(10),
    cancellation TEXT
);

-- 4. Pizza Names
CREATE TABLE pizza_names (
    pizza_id INT AUTO_INCREMENT PRIMARY KEY,
    pizza_name VARCHAR(50) NOT NULL
);

-- 5. Pizza Recipes
CREATE TABLE pizza_recipes (
    pizza_id INT PRIMARY KEY,
    toppings TEXT NOT NULL
);

-- 6. Pizza Toppings
CREATE TABLE pizza_toppings (
    topping_id INT AUTO_INCREMENT PRIMARY KEY,
    topping_name VARCHAR(50) NOT NULL
);

-- -----------------------------
-- 📥 INSERT SAMPLE DATA
-- -----------------------------

-- Runners
INSERT INTO runners (registration_date)
VALUES ('2021-01-01'), ('2021-01-03');

-- Customer Orders
INSERT INTO customer_orders (customer_id, pizza_id, exclusions, extras, order_time)
VALUES 
    (101, 1, NULL, NULL, '2021-01-01 18:05:00'),
    (102, 2, NULL, NULL, '2021-01-01 19:00:00');

-- Runner Orders
INSERT INTO runner_orders (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES 
    (1, 1, '2021-01-01 18:15:34', '20km', '32min', NULL),
    (2, 1, NULL, NULL, NULL, 'Customer cancelled');

-- Pizza Names
INSERT INTO pizza_names (pizza_name)
VALUES ('Meatlovers'), ('Vegetarian');

-- Pizza Recipes
INSERT INTO pizza_recipes (pizza_id, toppings)
VALUES 
    (1, '1,2,3,4,5,6,8,10'), 
    (2, '4,6,7,9,11,12');

-- Pizza Toppings
INSERT INTO pizza_toppings (topping_name)
VALUES 
    ('Bacon'), ('BBQ Sauce'), ('Cheese'), ('Chicken'), 
    ('Mushrooms'), ('Olives'), ('Onions'), ('Pepperoni'), 
    ('Peppers'), ('Tomatoes'), ('Sausage'), ('Spinach');

-- -----------------------------
-- 📊 ANALYSIS QUERIES
-- -----------------------------

-- 1. Successful Orders
SELECT COUNT(*) AS successful_orders
FROM runner_orders
WHERE cancellation IS NULL;

-- 2. Average Delivery Duration
SELECT AVG(CAST(REPLACE(duration, 'min', '') AS UNSIGNED)) AS avg_minutes
FROM runner_orders
WHERE cancellation IS NULL;

-- 3. Total Distance by Runner
SELECT runner_id, SUM(CAST(REPLACE(distance, 'km', '') AS DECIMAL(5,2))) AS total_km
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

-- 4. Most Ordered Pizza
SELECT pn.pizza_name, COUNT(*) AS order_count
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY pn.pizza_name
ORDER BY order_count DESC;

-- 5. Most Used Toppings
SELECT pt.topping_name, COUNT(*) AS usage_count
FROM pizza_recipes pr
JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, pr.toppings)
GROUP BY pt.topping_name
ORDER BY usage_count DESC;

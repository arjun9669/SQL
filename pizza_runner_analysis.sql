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

CREATE TABLE pizza_runner.runners (
    runner_id SERIAL PRIMARY KEY,
    registration_date DATE NOT NULL
);
CREATE TABLE pizza_runner.customer_orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    pizza_id INT NOT NULL,
    exclusions TEXT,  -- Stores excluded toppings (comma-separated)
    extras TEXT,      -- Stores extra toppings (comma-separated)
    order_time TIMESTAMP NOT NULL
);CREATE TABLE pizza_runner.runner_orders (
    order_id INT PRIMARY KEY,
    runner_id INT NOT NULL,
    pickup_time TIMESTAMP,
    distance VARCHAR(10), -- Can store 'km' values like '10km'
    duration VARCHAR(10), -- Can store 'min' values like '30min'
    cancellation TEXT,
    FOREIGN KEY (order_id) REFERENCES pizza_runner.customer_orders(order_id),
    FOREIGN KEY (runner_id) REFERENCES pizza_runner.runners(runner_id)
);
CREATE TABLE pizza_runner.pizza_names (
    pizza_id SERIAL PRIMARY KEY,
    pizza_name VARCHAR(50) NOT NULL
);
CREATE TABLE pizza_runner.pizza_recipes (
    pizza_id INT PRIMARY KEY,
    toppings TEXT NOT NULL,  -- Stores topping IDs as comma-separated values
    FOREIGN KEY (pizza_id) REFERENCES pizza_runner.pizza_names(pizza_id)
);
CREATE TABLE pizza_runner.pizza_toppings (
    topping_id SERIAL PRIMARY KEY,
    topping_name VARCHAR(50) NOT NULL
);
INSERT INTO pizza_runner.runners (registration_date)
VALUES ('2021-01-01'), ('2021-01-03');
INSERT INTO pizza_runner.customer_orders (customer_id, pizza_id, exclusions, extras, order_time)
VALUES 
    (101, 1, NULL, NULL, '2021-01-01 18:05:00'),
    (102, 2, NULL, NULL, '2021-01-01 19:00:00');
INSERT INTO pizza_runner.runner_orders (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES 
    (1, 1, '2021-01-01 18:15:34', '20km', '32min', NULL),
    (2, 1, NULL, NULL, NULL, 'Customer cancelled');
INSERT INTO pizza_runner.pizza_names (pizza_name)
VALUES ('Meatlovers'), ('Vegetarian');
INSERT INTO pizza_runner.pizza_recipes (pizza_id, toppings)
VALUES 
    (1, '1,2,3,4,5,6,8,10'), 
    (2, '4,6,7,9,11,12');
INSERT INTO pizza_runner.pizza_toppings (topping_name)
VALUES 
    ('Bacon'), ('BBQ Sauce'), ('Cheese'), ('Chicken'), 
    ('Mushrooms'), ('Olives'), ('Onions'), ('Pepperoni'), 
    ('Peppers'), ('Tomatoes'), ('Sausage'), ('Spinach');
SELECT * FROM pizza_runner.customer_orders;
SELECT * FROM pizza_runner.runner_orders;
SELECT * FROM pizza_runner.pizza_names;
SELECT * FROM pizza_runner.pizza_recipes;
SELECT * FROM pizza_runner.pizza_toppings;





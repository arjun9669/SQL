-- 🏋️ Gym Membership & Equipment Usage – SQL Case Study
-- Author: Arjun | Date: 2025-06-07

-- -----------------------------
-- 🧱 Schema Setup
-- -----------------------------
CREATE DATABASE IF NOT EXISTS gym_analytics;
USE gym_analytics;

-- Members table
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    gender VARCHAR(10),
    join_date DATE
);

-- Subscriptions table
CREATE TABLE subscriptions (
    sub_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    plan_type ENUM('Monthly', 'Quarterly', 'Yearly'),
    start_date DATE,
    end_date DATE,
    amount_paid DECIMAL(10,2),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Equipment table
CREATE TABLE equipment (
    equipment_id INT AUTO_INCREMENT PRIMARY KEY,
    equipment_name VARCHAR(50),
    category VARCHAR(50),
    maintenance_cost DECIMAL(10,2)
);

-- Equipment Usage table
CREATE TABLE equipment_usage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    equipment_id INT,
    usage_date DATE,
    duration_minutes INT,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
);

-- Trainers table
CREATE TABLE trainers (
    trainer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    specialization VARCHAR(50)
);

-- Trainer Sessions table
CREATE TABLE trainer_sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    trainer_id INT,
    member_id INT,
    session_date DATE,
    session_type VARCHAR(50),
    duration_minutes INT,
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- -----------------------------
-- 📥 Insert Sample Data
-- -----------------------------
-- Members
INSERT INTO members (full_name, gender, join_date) VALUES
('Ravi Kumar', 'Male', '2023-01-01'),
('Anjali Mehta', 'Female', '2023-02-01'),
('Vikas Patel', 'Male', '2023-03-01');

-- Subscriptions
INSERT INTO subscriptions (member_id, plan_type, start_date, end_date, amount_paid) VALUES
(1, 'Monthly', '2023-04-01', '2023-04-30', 2000.00),
(2, 'Quarterly', '2023-03-15', '2023-06-14', 5000.00),
(3, 'Yearly', '2023-01-01', '2023-12-31', 15000.00);

-- Equipment
INSERT INTO equipment (equipment_name, category, maintenance_cost) VALUES
('Treadmill', 'Cardio', 3000.00),
('Bench Press', 'Strength', 1500.00),
('Elliptical', 'Cardio', 2500.00);

-- Equipment Usage
INSERT INTO equipment_usage (member_id, equipment_id, usage_date, duration_minutes) VALUES
(1, 1, '2023-04-01', 30),
(2, 3, '2023-04-02', 25),
(3, 2, '2023-04-03', 45),
(1, 2, '2023-04-04', 20);

-- Trainers
INSERT INTO trainers (name, specialization) VALUES
('Kiran Reddy', 'Weight Training'),
('Neha Singh', 'Cardio Fitness');

-- Trainer Sessions
INSERT INTO trainer_sessions (trainer_id, member_id, session_date, session_type, duration_minutes) VALUES
(1, 1, '2023-04-01', 'Strength', 60),
(2, 2, '2023-04-02', 'Cardio', 45),
(1, 3, '2023-04-05', 'Strength', 30);

-- -----------------------------
-- 📊 Analysis Queries (10)
-- -----------------------------

-- 1. Total revenue collected from all subscription plans
SELECT SUM(amount_paid) AS total_revenue FROM subscriptions;

-- 2. Number of active members (subscriptions valid in April 2023)
SELECT COUNT(*) AS active_members
FROM subscriptions
WHERE '2023-04-15' BETWEEN start_date AND end_date;

-- 3. Most used equipment (by number of sessions)
SELECT e.equipment_name, COUNT(*) AS usage_count
FROM equipment_usage eu
JOIN equipment e ON eu.equipment_id = e.equipment_id
GROUP BY e.equipment_name
ORDER BY usage_count DESC
LIMIT 1;

-- 4. Average session time per trainer
SELECT t.name, AVG(ts.duration_minutes) AS avg_duration
FROM trainer_sessions ts
JOIN trainers t ON ts.trainer_id = t.trainer_id
GROUP BY t.name;

-- 5. Gender-wise subscription totals
SELECT m.gender, SUM(s.amount_paid) AS total_paid
FROM subscriptions s
JOIN members m ON s.member_id = m.member_id
GROUP BY m.gender;

-- 6. Equipment maintenance cost by category
SELECT category, SUM(maintenance_cost) AS total_maintenance
FROM equipment
GROUP BY category;

-- 7. Members who used both cardio and strength equipment
SELECT DISTINCT m.full_name
FROM members m
JOIN equipment_usage eu ON m.member_id = eu.member_id
JOIN equipment e ON eu.equipment_id = e.equipment_id
GROUP BY m.full_name
HAVING COUNT(DISTINCT e.category) > 1;

-- 8. Members who had trainer sessions but no equipment usage
SELECT m.full_name
FROM members m
WHERE m.member_id IN (
    SELECT member_id FROM trainer_sessions
)
AND m.member_id NOT IN (
    SELECT member_id FROM equipment_usage
);

-- 9. Equipment usage duration per member
SELECT m.full_name, SUM(eu.duration_minutes) AS total_minutes
FROM equipment_usage eu
JOIN members m ON eu.member_id = m.member_id
GROUP BY m.full_name;

-- 10. Average subscription amount by plan type
SELECT plan_type, ROUND(AVG(amount_paid), 2) AS avg_payment
FROM subscriptions
GROUP BY plan_type;

-- 💸 Crowdfunding Campaign Tracker – SQL Case Study
-- Author: Arjun | Date: 2025-06-07

-- -----------------------------
-- 🧱 Schema Setup
-- -----------------------------
CREATE DATABASE IF NOT EXISTS crowdfunding_db;
USE crowdfunding_db;

-- Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50)
);

-- Campaigns Table
CREATE TABLE campaigns (
    campaign_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    category VARCHAR(50),
    goal_amount DECIMAL(10,2),
    launch_date DATE,
    deadline DATE,
    creator_id INT,
    FOREIGN KEY (creator_id) REFERENCES users(user_id)
);

-- Donations Table
CREATE TABLE donations (
    donation_id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT,
    donor_id INT,
    donation_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id),
    FOREIGN KEY (donor_id) REFERENCES users(user_id)
);

-- Comments Table
CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT,
    user_id INT,
    comment_text TEXT,
    comment_date DATE,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Campaign Updates Table
CREATE TABLE updates (
    update_id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT,
    update_date DATE,
    update_text TEXT,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

-- -----------------------------
-- 📥 Insert Sample Data
-- -----------------------------
-- Users
INSERT INTO users (full_name, email, city) VALUES
('Ankita Sharma', 'ankita@example.com', 'Delhi'),
('Kunal Verma', 'kunal@example.com', 'Mumbai'),
('Priya Desai', 'priya@example.com', 'Bangalore');

-- Campaigns
INSERT INTO campaigns (title, category, goal_amount, launch_date, deadline, creator_id) VALUES
('Smart Water Bottle', 'Technology', 50000.00, '2023-04-01', '2023-04-30', 1),
('Pet Shelter Fundraiser', 'Charity', 30000.00, '2023-04-05', '2023-05-05', 2),
('Art Therapy for Kids', 'Art', 20000.00, '2023-04-10', '2023-05-10', 3);

-- Donations
INSERT INTO donations (campaign_id, donor_id, donation_date, amount) VALUES
(1, 2, '2023-04-02', 5000.00),
(1, 3, '2023-04-04', 8000.00),
(2, 1, '2023-04-06', 3000.00),
(2, 3, '2023-04-08', 7000.00),
(3, 1, '2023-04-11', 5000.00);

-- Comments
INSERT INTO comments (campaign_id, user_id, comment_text, comment_date) VALUES
(1, 2, 'Amazing idea!', '2023-04-02'),
(2, 1, 'Keep going strong!', '2023-04-06'),
(3, 3, 'Excited to support this.', '2023-04-11');

-- Updates
INSERT INTO updates (campaign_id, update_date, update_text) VALUES
(1, '2023-04-03', 'Reached 10% of our goal!'),
(2, '2023-04-07', 'Midway to our target!'),
(3, '2023-04-12', 'Thank you for your support!');

-- -----------------------------
-- 📊 Analysis Queries (10)
-- -----------------------------

-- 1. Total amount raised per campaign
SELECT c.title, SUM(d.amount) AS total_raised
FROM campaigns c
JOIN donations d ON c.campaign_id = d.campaign_id
GROUP BY c.title;

-- 2. Percentage of goal achieved per campaign
SELECT 
  c.title,
  ROUND(SUM(d.amount) / c.goal_amount * 100, 2) AS percent_achieved
FROM campaigns c
JOIN donations d ON c.campaign_id = d.campaign_id
GROUP BY c.title, c.goal_amount;

-- 3. Top 3 most donated campaigns
SELECT c.title, SUM(d.amount) AS total_donations
FROM campaigns c
JOIN donations d ON c.campaign_id = d.campaign_id
GROUP BY c.title
ORDER BY total_donations DESC
LIMIT 3;

-- 4. Donors who donated to multiple campaigns
SELECT u.full_name, COUNT(DISTINCT d.campaign_id) AS campaign_count
FROM donations d
JOIN users u ON d.donor_id = u.user_id
GROUP BY u.full_name
HAVING campaign_count > 1;

-- 5. Campaigns with no donations
SELECT title
FROM campaigns
WHERE campaign_id NOT IN (
    SELECT DISTINCT campaign_id FROM donations
);

-- 6. Average donation amount by category
SELECT c.category, ROUND(AVG(d.amount), 2) AS avg_donation
FROM campaigns c
JOIN donations d ON c.campaign_id = d.campaign_id
GROUP BY c.category;

-- 7. Number of comments per campaign
SELECT c.title, COUNT(*) AS comment_count
FROM comments cm
JOIN campaigns c ON cm.campaign_id = c.campaign_id
GROUP BY c.title;

-- 8. Most active donor (by number of donations)
SELECT u.full_name, COUNT(*) AS donation_count
FROM donations d
JOIN users u ON d.donor_id = u.user_id
GROUP BY u.full_name
ORDER BY donation_count DESC
LIMIT 1;

-- 9. Total number of updates shared per campaign
SELECT c.title, COUNT(*) AS update_count
FROM updates u
JOIN campaigns c ON u.campaign_id = c.campaign_id
GROUP BY c.title;

-- 10. City-wise total donations
SELECT u.city, SUM(d.amount) AS total_donated
FROM donations d
JOIN users u ON d.donor_id = u.user_id
GROUP BY u.city;

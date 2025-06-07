-- 🎵 Music Festival Ticketing & Merch Sales – SQL Case Study
-- Author: Arjun | Date: 2025-06-07

-- -----------------------------
-- 🧱 Schema Setup
-- -----------------------------
CREATE DATABASE IF NOT EXISTS music_festival_db;
USE music_festival_db;

-- Attendees
CREATE TABLE attendees (
    attendee_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50)
);

-- Tickets
CREATE TABLE tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    attendee_id INT,
    ticket_type ENUM('General', 'VIP', 'Backstage'),
    purchase_date DATE,
    price DECIMAL(10,2),
    FOREIGN KEY (attendee_id) REFERENCES attendees(attendee_id)
);

-- Artists
CREATE TABLE artists (
    artist_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    genre VARCHAR(50)
);

-- Performances
CREATE TABLE performances (
    performance_id INT AUTO_INCREMENT PRIMARY KEY,
    artist_id INT,
    stage VARCHAR(50),
    performance_date DATE,
    duration_minutes INT,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);

-- Merchandise
CREATE TABLE merchandise (
    merch_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Merch Sales
CREATE TABLE merch_sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    merch_id INT,
    attendee_id INT,
    sale_date DATE,
    quantity INT,
    FOREIGN KEY (merch_id) REFERENCES merchandise(merch_id),
    FOREIGN KEY (attendee_id) REFERENCES attendees(attendee_id)
);

-- -----------------------------
-- 📥 Insert Sample Data
-- -----------------------------
-- Attendees
INSERT INTO attendees (full_name, email, city) VALUES
('Megha Rao', 'megha@example.com', 'Delhi'),
('Rohan Mehta', 'rohan@example.com', 'Mumbai'),
('Ishita Jain', 'ishita@example.com', 'Pune');

-- Tickets
INSERT INTO tickets (attendee_id, ticket_type, purchase_date, price) VALUES
(1, 'VIP', '2023-04-01', 4000.00),
(2, 'General', '2023-04-02', 2000.00),
(3, 'Backstage', '2023-04-03', 6000.00);

-- Artists
INSERT INTO artists (name, genre) VALUES
('DJ Blaze', 'EDM'),
('The Strings', 'Rock'),
('Soul Sisters', 'Pop');

-- Performances
INSERT INTO performances (artist_id, stage, performance_date, duration_minutes) VALUES
(1, 'Main Stage', '2023-04-10', 90),
(2, 'Stage B', '2023-04-10', 60),
(3, 'Acoustic Corner', '2023-04-11', 45);

-- Merchandise
INSERT INTO merchandise (item_name, category, price) VALUES
('Festival T-Shirt', 'Clothing', 500.00),
('LED Wristband', 'Accessory', 300.00),
('Poster Pack', 'Souvenir', 200.00);

-- Merch Sales
INSERT INTO merch_sales (merch_id, attendee_id, sale_date, quantity) VALUES
(1, 1, '2023-04-10', 2),
(2, 2, '2023-04-10', 1),
(3, 3, '2023-04-11', 3),
(1, 3, '2023-04-11', 1);

-- -----------------------------
-- 📊 Analysis Queries (10)
-- -----------------------------

-- 1. Total revenue from ticket sales
SELECT SUM(price) AS total_ticket_revenue FROM tickets;

-- 2. Most popular ticket type
SELECT ticket_type, COUNT(*) AS count
FROM tickets
GROUP BY ticket_type
ORDER BY count DESC
LIMIT 1;

-- 3. Total merch revenue per category
SELECT m.category, SUM(m.price * ms.quantity) AS total_revenue
FROM merch_sales ms
JOIN merchandise m ON ms.merch_id = m.merch_id
GROUP BY m.category;

-- 4. Attendee with highest merch spending
SELECT a.full_name, SUM(m.price * ms.quantity) AS total_spent
FROM merch_sales ms
JOIN merchandise m ON ms.merch_id = m.merch_id
JOIN attendees a ON ms.attendee_id = a.attendee_id
GROUP BY a.full_name
ORDER BY total_spent DESC
LIMIT 1;

-- 5. City-wise ticket sales revenue
SELECT a.city, SUM(t.price) AS city_revenue
FROM tickets t
JOIN attendees a ON t.attendee_id = a.attendee_id
GROUP BY a.city;

-- 6. Total performance duration per artist
SELECT ar.name, SUM(p.duration_minutes) AS total_duration
FROM performances p
JOIN artists ar ON p.artist_id = ar.artist_id
GROUP BY ar.name;

-- 7. Average ticket price by ticket type
SELECT ticket_type, ROUND(AVG(price), 2) AS avg_price
FROM tickets
GROUP BY ticket_type;

-- 8. Most sold merch item
SELECT m.item_name, SUM(ms.quantity) AS total_sold
FROM merch_sales ms
JOIN merchandise m ON ms.merch_id = m.merch_id
GROUP BY m.item_name
ORDER BY total_sold DESC
LIMIT 1;

-- 9. Performances scheduled on 2023-04-10
SELECT ar.name, p.stage, p.performance_date
FROM performances p
JOIN artists ar ON p.artist_id = ar.artist_id
WHERE p.performance_date = '2023-04-10';

-- 10. Attendees who bought merch but didn't buy VIP tickets
SELECT a.full_name
FROM attendees a
WHERE a.attendee_id IN (
    SELECT DISTINCT attendee_id FROM merch_sales
)
AND a.attendee_id NOT IN (
    SELECT attendee_id FROM tickets WHERE ticket_type = 'VIP'
);

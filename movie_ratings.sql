-- 🎬 Movie Ratings Analytics – SQL Case Study
-- Author: Arjun | Date: 2025-04-21

-- -----------------------------
-- 🧱 Schema Setup
-- -----------------------------
CREATE DATABASE IF NOT EXISTS movie_ratings;
USE movie_ratings;

-- Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(100)
);

-- Movies Table
CREATE TABLE movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    genre VARCHAR(50),
    release_year YEAR
);

-- Ratings Table
CREATE TABLE ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    movie_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    rating_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

-- -----------------------------
-- 📥 Sample Data
-- -----------------------------

-- Users
INSERT INTO users (user_name) VALUES 
('Arjun'), ('Sneha'), ('Ravi');

-- Movies
INSERT INTO movies (title, genre, release_year) VALUES
('Inception', 'Sci-Fi', 2010),
('3 Idiots', 'Drama', 2009),
('The Dark Knight', 'Action', 2008),
('Dangal', 'Sports', 2016);

-- Ratings
INSERT INTO ratings (user_id, movie_id, rating, rating_date) VALUES
(1, 1, 5, '2024-04-01'),
(1, 2, 4, '2024-04-02'),
(2, 1, 4, '2024-04-03'),
(2, 3, 5, '2024-04-04'),
(3, 1, 3, '2024-04-05'),
(3, 4, 4, '2024-04-06'),
(1, 3, 4, '2024-04-07'),
(2, 2, 5, '2024-04-08');

-- -----------------------------
-- 📊 Analysis Queries
-- -----------------------------

-- 1. Top-rated movie
SELECT 
  m.title,
  ROUND(AVG(r.rating), 2) AS avg_rating
FROM ratings r
JOIN movies m ON r.movie_id = m.movie_id
GROUP BY m.title
ORDER BY avg_rating DESC
LIMIT 1;

-- 2. Average rating per genre
SELECT 
  m.genre,
  ROUND(AVG(r.rating), 2) AS avg_rating
FROM ratings r
JOIN movies m ON r.movie_id = m.movie_id
GROUP BY m.genre
ORDER BY avg_rating DESC;

-- 3. Most active users
SELECT 
  u.user_name,
  COUNT(r.rating_id) AS total_ratings
FROM ratings r
JOIN users u ON r.user_id = u.user_id
GROUP BY u.user_name
ORDER BY total_ratings DESC;

-- 4. Movies with more than 2 ratings
SELECT 
  m.title,
  COUNT(r.rating_id) AS total_ratings
FROM ratings r
JOIN movies m ON r.movie_id = m.movie_id
GROUP BY m.title
HAVING total_ratings > 2;

-- 5. Movies with average rating below 4
SELECT 
  m.title,
  ROUND(AVG(r.rating), 2) AS avg_rating
FROM ratings r
JOIN movies m ON r.movie_id = m.movie_id
GROUP BY m.title
HAVING avg_rating < 4;

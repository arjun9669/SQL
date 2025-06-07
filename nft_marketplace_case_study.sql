-- 🧬 NFT Marketplace – SQL Case Study
-- Author: Arjun | Date: 2025-06-07

-- -----------------------------
-- 🧱 Schema Setup
-- -----------------------------
CREATE DATABASE IF NOT EXISTS nft_marketplace_db;
USE nft_marketplace_db;

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100),
    join_date DATE
);

-- NFTs table
CREATE TABLE nfts (
    nft_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    creator_id INT,
    category VARCHAR(50),
    price DECIMAL(10,2),
    FOREIGN KEY (creator_id) REFERENCES users(user_id)
);

-- Transactions table
CREATE TABLE transactions (
    txn_id INT AUTO_INCREMENT PRIMARY KEY,
    nft_id INT,
    buyer_id INT,
    seller_id INT,
    txn_date DATE,
    gas_fee DECIMAL(10,2),
    sale_price DECIMAL(10,2),
    FOREIGN KEY (nft_id) REFERENCES nfts(nft_id),
    FOREIGN KEY (buyer_id) REFERENCES users(user_id),
    FOREIGN KEY (seller_id) REFERENCES users(user_id)
);

-- Wallets table
CREATE TABLE wallets (
    wallet_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    wallet_balance DECIMAL(12,2),
    last_activity DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- NFT Likes table
CREATE TABLE nft_likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    nft_id INT,
    liked_by INT,
    like_date DATE,
    FOREIGN KEY (nft_id) REFERENCES nfts(nft_id),
    FOREIGN KEY (liked_by) REFERENCES users(user_id)
);

-- -----------------------------
-- 📥 Insert Sample Data
-- -----------------------------
INSERT INTO users (username, join_date) VALUES
('Alice', '2023-01-10'),
('Bob', '2023-02-15'),
('Charlie', '2023-03-20');

INSERT INTO nfts (title, creator_id, category, price) VALUES
('Galaxy Cat', 1, 'Art', 2000.00),
('Crypto Sword', 2, 'Gaming', 3500.00),
('Neon Ape', 1, 'Art', 5000.00);

INSERT INTO transactions (nft_id, buyer_id, seller_id, txn_date, gas_fee, sale_price) VALUES
(1, 2, 1, '2023-04-01', 150.00, 2200.00),
(2, 3, 2, '2023-04-05', 200.00, 3600.00),
(3, 3, 1, '2023-04-10', 250.00, 5100.00);

INSERT INTO wallets (user_id, wallet_balance, last_activity) VALUES
(1, 12000.00, '2023-04-15'),
(2, 8000.00, '2023-04-10'),
(3, 9500.00, '2023-04-12');

INSERT INTO nft_likes (nft_id, liked_by, like_date) VALUES
(1, 2, '2023-03-30'),
(1, 3, '2023-03-31'),
(2, 1, '2023-04-01'),
(2, 3, '2023-04-02'),
(3, 2, '2023-04-03'),
(3, 3, '2023-04-04');

-- -----------------------------
-- 📊 Analysis Queries (10)
-- -----------------------------

-- 1. Top 5 users by total NFT sales
SELECT u.username, SUM(t.sale_price) AS total_sales
FROM transactions t
JOIN users u ON t.seller_id = u.user_id
GROUP BY u.username
ORDER BY total_sales DESC
LIMIT 5;

-- 2. Average gas fee per transaction
SELECT ROUND(AVG(gas_fee), 2) AS avg_gas_fee
FROM transactions;

-- 3. Highest revenue-generating NFT category
SELECT category, SUM(sale_price) AS total_revenue
FROM transactions t
JOIN nfts n ON t.nft_id = n.nft_id
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 1;

-- 4. NFTs created but never sold
SELECT n.title
FROM nfts n
LEFT JOIN transactions t ON n.nft_id = t.nft_id
WHERE t.nft_id IS NULL;

-- 5. Average resale price of NFTs
SELECT n.title, n.price AS original_price, AVG(t.sale_price) AS avg_resale_price
FROM transactions t
JOIN nfts n ON t.nft_id = n.nft_id
GROUP BY n.nft_id;

-- 6. Most active buyer
SELECT u.username, COUNT(*) AS purchases
FROM transactions t
JOIN users u ON t.buyer_id = u.user_id
GROUP BY u.username
ORDER BY purchases DESC
LIMIT 1;

-- 7. Average wallet balance by join year
SELECT YEAR(join_date) AS join_year, ROUND(AVG(w.wallet_balance), 2) AS avg_balance
FROM users u
JOIN wallets w ON u.user_id = w.user_id
GROUP BY join_year;

-- 8. % of NFTs liked by more than 1 user
SELECT 
  ROUND(COUNT(DISTINCT nft_id) * 100.0 / (SELECT COUNT(*) FROM nfts), 2) AS percentage_liked_by_multiple
FROM nft_likes
GROUP BY nft_id
HAVING COUNT(*) > 1;

-- 9. Top 3 NFTs with highest likes
SELECT n.title, COUNT(*) AS like_count
FROM nft_likes l
JOIN nfts n ON l.nft_id = n.nft_id
GROUP BY n.title
ORDER BY like_count DESC
LIMIT 3;

-- 10. Day with highest number of transactions
SELECT txn_date, COUNT(*) AS txn_count
FROM transactions
GROUP BY txn_date
ORDER BY txn_count DESC
LIMIT 1;

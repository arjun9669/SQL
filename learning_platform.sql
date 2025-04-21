-- 📘 Online Learning Platform Analytics – SQL Case Study
-- Author: Arjun | Date: 2025-04-21

-- -----------------------------
-- 🧱 Schema Setup
-- -----------------------------

CREATE DATABASE IF NOT EXISTS learning_platform;
USE learning_platform;

-- Students
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100),
    join_date DATE
);

-- Instructors
CREATE TABLE instructors (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    instructor_name VARCHAR(100)
);

-- Courses
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_title VARCHAR(100),
    category VARCHAR(50),
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

-- Enrollments
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    completion_status ENUM('Completed', 'In Progress', 'Dropped'),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- -----------------------------
-- 📥 Sample Data
-- -----------------------------

INSERT INTO students (student_name, join_date) VALUES
('Arjun', '2024-01-15'),
('Sneha', '2024-02-01'),
('Ravi', '2024-02-10');

INSERT INTO instructors (instructor_name) VALUES
('John Doe'), ('Anjali Sharma'), ('Rahul Verma');

INSERT INTO courses (course_title, category, instructor_id) VALUES
('SQL for Beginners', 'Data', 1),
('Python Basics', 'Programming', 2),
('Data Visualization with Power BI', 'BI Tools', 3);

INSERT INTO enrollments (student_id, course_id, enrollment_date, completion_status) VALUES
(1, 1, '2024-02-01', 'Completed'),
(1, 2, '2024-02-10', 'In Progress'),
(2, 1, '2024-02-05', 'Dropped'),
(2, 3, '2024-02-15', 'Completed'),
(3, 2, '2024-02-20', 'Completed'),
(3, 3, '2024-02-21', 'Completed');

-- -----------------------------
-- 📊 Analysis Queries
-- -----------------------------

-- 1. Overall course completion rate
SELECT 
  ROUND(
    (SUM(CASE WHEN completion_status = 'Completed' THEN 1 ELSE 0 END) / COUNT(*)) * 100,
    2
  ) AS completion_rate_percentage
FROM enrollments;

-- 2. Most popular courses by enrollments
SELECT 
  c.course_title,
  COUNT(*) AS total_enrollments
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_title
ORDER BY total_enrollments DESC;

-- 3. Instructor with most course completions
SELECT 
  i.instructor_name,
  COUNT(*) AS total_completions
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
JOIN instructors i ON c.instructor_id = i.instructor_id
WHERE e.completion_status = 'Completed'
GROUP BY i.instructor_name
ORDER BY total_completions DESC
LIMIT 1;

-- 4. Students who dropped any course
SELECT 
  s.student_name,
  c.course_title
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.completion_status = 'Dropped';

-- 5. Completion count per category
SELECT 
  c.category,
  COUNT(*) AS completed_courses
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
WHERE e.completion_status = 'Completed'
GROUP BY c.category;

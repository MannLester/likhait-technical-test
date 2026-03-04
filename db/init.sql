-- Create database if not exists
CREATE DATABASE IF NOT EXISTS expense_system_development CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE expense_system_development;

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create expenses table
CREATE TABLE IF NOT EXISTS expenses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  description VARCHAR(255) NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  date DATE NOT NULL,
  category_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT,
  INDEX idx_category_id (category_id),
  INDEX index_expenses_on_date (date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed categories
INSERT INTO categories (name) VALUES
  ('Food'),
  ('Transport'),
  ('Supplies'),
  ('Entertainment'),
  ('Utilities')
ON DUPLICATE KEY UPDATE name=name;

-- Seed expenses
INSERT INTO expenses (description, amount, category_id, date) VALUES
  ('Team Lunch at Italian Restaurant', 1500.50, 1, '2026-02-01'),
  ('Grab to Client Meeting', 350.00, 2, '2026-02-01'),
  ('Office Supplies - Pens and Paper', 450.75, 3, '2026-02-02'),
  ('Team Building Dinner', 2800.00, 1, '2026-02-03'),
  ('Taxi to Airport', 800.00, 2, '2026-02-04'),
  ('Coffee and Snacks for Meeting', 250.25, 1, '2026-02-05'),
  ('Printer Ink Cartridges', 680.00, 3, '2026-02-06'),
  ('Uber for Site Visit', 420.50, 2, '2026-02-07'),
  ('Client Lunch Meeting', 1850.00, 1, '2026-02-08'),
  ('Office Cleaning Supplies', 320.00, 3, '2026-02-09'),
  ('Team Movie Night', 1200.00, 4, '2026-02-10'),
  ('Internet Bill', 2500.00, 5, '2026-02-11'),
  ('Breakfast Meeting with Client', 580.00, 1, '2026-02-12'),
  ('Bus Tickets for Conference', 150.00, 2, '2026-02-13'),
  ('Electricity Bill', 3200.00, 5, '2026-02-14');
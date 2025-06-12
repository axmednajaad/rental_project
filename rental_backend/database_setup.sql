-- Database setup for Rental Management System
-- Run this script to create the database and tables

-- Create database (if not exists)
CREATE DATABASE IF NOT EXISTS rental_db;
USE rental_db;

-- Create Users table with password field
CREATE TABLE IF NOT EXISTS Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    role ENUM('user', 'admin') DEFAULT 'user',
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Properties table
CREATE TABLE IF NOT EXISTS Properties (
    property_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(100) NOT NULL,
    size VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Bookings table
CREATE TABLE IF NOT EXISTS Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT NOT NULL,
    user_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Insert sample admin user (password: admin123)
-- Note: This is a bcrypt hash of 'admin123' with salt rounds 10
INSERT IGNORE INTO Users (name, email, phone, role, password) VALUES
('Admin User', 'admin@rental.com', '+1234567890', 'admin', '$2b$10$kXTKNAabcbSmd/Mc6zSDtuzhLMCZ6GzWv.CUX5xbNhN5ematnCkFS');

-- Insert sample regular user (password: user123)
-- Note: This is a bcrypt hash of 'user123' with salt rounds 10
INSERT IGNORE INTO Users (name, email, phone, role, password) VALUES
('John Doe', 'user@rental.com', '+1234567891', 'user', '$2b$10$hDOqS2NzAVjv7g9hhNyVxO0QkqOA3mKFngqWiup3M2toPRZxTMc/m');

-- Insert sample properties
INSERT IGNORE INTO Properties (name, description, type, size, location, price) VALUES 
('Modern Downtown Apartment', 'Beautiful 2-bedroom apartment in the heart of downtown with city views', 'Apartment', '2 BHK, 1200 sq ft', 'Downtown, City Center', 2500.00),
('Cozy Suburban House', 'Spacious 3-bedroom house with garden in quiet neighborhood', 'House', '3 BHK, 1800 sq ft', 'Suburban Area, Green Valley', 3200.00),
('Luxury Condo', 'High-end 1-bedroom condo with premium amenities', 'Condo', '1 BHK, 800 sq ft', 'Uptown, Luxury District', 3500.00),
('Student Studio', 'Affordable studio apartment perfect for students', 'Studio', 'Studio, 400 sq ft', 'University Area', 1200.00),
('Family Villa', 'Large 4-bedroom villa with pool and garden', 'Villa', '4 BHK, 2500 sq ft', 'Residential Hills', 4500.00);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_bookings_user_id ON Bookings(user_id);
CREATE INDEX idx_bookings_property_id ON Bookings(property_id);
CREATE INDEX idx_bookings_dates ON Bookings(check_in_date, check_out_date);

-- Show tables created
SHOW TABLES;

-- Display sample data
SELECT 'Users Table:' as Info;
SELECT user_id, name, email, phone, role, created_at FROM Users;

SELECT 'Properties Table:' as Info;
SELECT property_id, name, type, location, price FROM Properties;

SELECT 'Database setup completed successfully!' as Status;

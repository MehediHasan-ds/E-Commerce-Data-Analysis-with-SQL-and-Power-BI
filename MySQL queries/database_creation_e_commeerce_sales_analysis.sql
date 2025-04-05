-- Drop the database if it exists
-- DROP DATABASE IF EXISTS ecommerce_analysis;

CREATE DATABASE ecommerce_analysis;

USE ecommerce_analysis;

-- Customers Table
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    gender ENUM('M', 'F', 'Other'),
    age INT,
    registration_date VARCHAR(20),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    yearly_income DECIMAL(10, 2),
    no_of_children ENUM('Not Married', '0 Children', '1 or More Children')
);

-- Product Categories Table
CREATE TABLE product_category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100),
    description TEXT,
    created_at VARCHAR(15)
);

-- Product Subcategories Table
CREATE TABLE product_subcategory (
    subcategory_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT NOT NULL,
    subcategory_name VARCHAR(100),
    description TEXT,
    created_at VARCHAR(30)
);

-- Products Table
CREATE TABLE all_unique_products (
	product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(100),
    brand_name VARCHAR(50),
    subcategory_id INT,
    cost DECIMAL(10, 2),
    price DECIMAL(10, 2),
    stock_quantity INT,
    supplier_id INT,
    added_date VARCHAR(15)
);

-- Orders Table
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    order_date VARCHAR(20),
    order_status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled', 'Returned'),
    total_amount DECIMAL(10, 2),
    payment_method ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Cash on Delivery'),
    discount_applied DECIMAL(10, 2),
    tax_amount DECIMAL(10, 2),
    shipping_cost DECIMAL(10, 2),
    shipment_date VARCHAR(20),
    delivery_date VARCHAR(20),
    specific_shipping_address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    order_source ENUM('Website', 'Mobile App', 'Social Media')
);

-- Order Items Table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    quantity INT
);

-- Payments Table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    payment_date VARCHAR(20),
    payment_method ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Cash on Delivery'),
    payment_status ENUM('Pending', 'Completed', 'Failed', 'Refunded'),
    transaction_id VARCHAR(50),
    amount_paid DECIMAL(10, 2)
);

-- Customer Sessions Table
CREATE TABLE customer_sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id VARCHAR(50) NOT NULL,
    login_time VARCHAR(20),
    logout_time VARCHAR(20),
    device_type ENUM('Desktop', 'Mobile', 'Tablet'),
    browser VARCHAR(50),
    pages_visited INT,
    session_duration INT
);

-- Reviews Table
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    rating DECIMAL(3, 2),
    review_text TEXT,
    review_date VARCHAR(30)
);

-- Add Foreign Key Constraints
ALTER TABLE product_subcategory
ADD CONSTRAINT fk_product_category
FOREIGN KEY (category_id) REFERENCES product_category(category_id) ON DELETE CASCADE;

ALTER TABLE brands
ADD CONSTRAINT fk_brands_subcategory
FOREIGN KEY (subcategory_id) REFERENCES product_subcategory(subcategory_id) ON DELETE CASCADE;

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE;

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_order
FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
ADD CONSTRAINT fk_order_items_product
FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE;

ALTER TABLE payments
ADD CONSTRAINT fk_payments_order
FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
ADD CONSTRAINT fk_payments_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE;

ALTER TABLE customer_sessions
ADD CONSTRAINT fk_customer_sessions_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE;

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
ADD CONSTRAINT fk_reviews_product
FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE;

-- Triggers for Generating Unique IDs
DELIMITER //

CREATE TRIGGER before_insert_customer
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
    DECLARE uuid_part VARCHAR(8);
    DECLARE email_part VARCHAR(4);
    DECLARE phone_part VARCHAR(10);  -- Use full phone number
    DECLARE date_part VARCHAR(6);

    -- Generate a UUID and take the first 8 characters
    SET uuid_part = LEFT(UUID(), 8);

    -- Extract first 4 characters of the email (before '@')
    SET email_part = LEFT(SUBSTRING_INDEX(NEW.email, '@', 1), 4);

    -- Use the full phone number instead of just the last 4 digits
    SET phone_part = NEW.phone_number;

    -- Extract year and month from registration_date (VARCHAR)
    -- Ensure the registration_date is in 'YYYY-MM-DD' or 'YYYY-MM-DD HH:MM:SS' format
    SET date_part = DATE_FORMAT(STR_TO_DATE(NEW.registration_date, '%Y-%m-%d %H:%i:%s'), '%Y%m');

    -- Combine all parts to create customer_id
    SET NEW.customer_id = CONCAT(uuid_part, '_', email_part, phone_part, date_part);
END;
//

-- Trigger for generating product_id
CREATE TRIGGER before_insert_product
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    SET NEW.product_id = CONCAT(LEFT(UUID(), 8), LPAD((SELECT subcategory_id FROM brands WHERE model_name = NEW.product_name LIMIT 1), 4, '0'));
END;
//

-- Trigger for generating order_id
CREATE TRIGGER before_insert_order
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    SET NEW.order_id = CONCAT(NEW.customer_id, '_', LEFT(UUID(), 5));
END;
//

DELIMITER ;
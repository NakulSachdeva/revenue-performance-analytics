CREATE DATABASE ecommerce_sql;
USE ecommerce_sql;

CREATE TABLE platforms (
    platform_id INT PRIMARY KEY,
    platform_name VARCHAR(50),
    commission_rate DECIMAL(5,2)
);

CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY,
    warehouse_city VARCHAR(100),
    state VARCHAR(100),
    capacity INT
);

CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    state VARCHAR(100),
    zone VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(200),
    category VARCHAR(100),
    brand VARCHAR(100),
    cost_price DECIMAL(10,2),
    mrp DECIMAL(10,2),
    launch_date DATE
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    signup_date DATE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    platform_id INT,
    warehouse_id INT,
    order_date DATE,
    order_status VARCHAR(50),
    payment_method VARCHAR(50),

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (platform_id) REFERENCES platforms(platform_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);


CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    selling_price DECIMAL(10,2),
    discount DECIMAL(10,2),
    final_price DECIMAL(10,2),

    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY,
    order_id INT,
    shipping_partner VARCHAR(100),
    shipping_cost DECIMAL(10,2),
    dispatch_date DATE,
    delivery_date DATE,

    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_item_id INT,
    return_reason VARCHAR(200),
    return_date DATE,
    refund_amount DECIMAL(10,2),

    FOREIGN KEY (order_item_id) REFERENCES order_items(order_item_id)
);


CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(200),
    country VARCHAR(100)
);

CREATE TABLE product_suppliers (
    product_id INT,
    supplier_id INT,
    supply_cost DECIMAL(10,2),

    PRIMARY KEY (product_id, supplier_id),

    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);


CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY,
    product_id INT,
    warehouse_id INT,
    stock_available INT,
    reorder_level INT,
    last_updated DATE,

    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);


CREATE TABLE marketing_campaigns (
    campaign_id INT PRIMARY KEY,
    platform VARCHAR(100),
    campaign_name VARCHAR(200),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12,2)
);

CREATE TABLE campaign_sales (
    campaign_sale_id INT PRIMARY KEY,
    campaign_id INT,
    order_id INT,

    FOREIGN KEY (campaign_id) REFERENCES marketing_campaigns(campaign_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE expenses (
    expense_id INT PRIMARY KEY,
    expense_type VARCHAR(100),
    amount DECIMAL(12,2),
    expense_date DATE
);

SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;
SET AUTOCOMMIT = 0;


TRUNCATE TABLE customers;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE customers 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n' -- Try '\n' first, it's more universal
IGNORE 1 ROWS;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. PRODUCT
TRUNCATE TABLE products;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- 2. ORDERS
TRUNCATE TABLE orders;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
INTO TABLE orders FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- 3. ORDER ITEMS
TRUNCATE TABLE order_items;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_items.csv'
INTO TABLE order_items FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- 4. SHIPMENTS
TRUNCATE TABLE shipments;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/shipments.csv'
INTO TABLE shipments FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- 5. RETURNS
TRUNCATE TABLE returns;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/returns.csv'
INTO TABLE returns FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- 6. INVENTORY
TRUNCATE TABLE inventory;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/inventory.csv'
INTO TABLE inventory FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- 7. SUPPLIERS
TRUNCATE TABLE suppliers;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/suppliers.csv'
INTO TABLE suppliers FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- 8. PRODUCT SUPPLIERS
TRUNCATE TABLE product_suppliers;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_suppliers.csv'
INTO TABLE product_suppliers FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- 9. MARKETING CAMPAIGNS
TRUNCATE TABLE marketing_campaigns;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/marketing_campaigns.csv'
INTO TABLE marketing_campaigns FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- 10. CAMPAIGN SALES
TRUNCATE TABLE campaign_sales;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/campaign_sales.csv'
INTO TABLE campaign_sales FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- 11. EXPENSES
TRUNCATE TABLE expenses;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/expenses.csv'
INTO TABLE expenses FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;













	

























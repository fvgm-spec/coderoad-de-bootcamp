select 1 + 2 as three

CREATE TABLE sales (
    id INT AUTO_INCREMENT PRIMARY KEY,  -- New column ID autoincremental as PK
    date DATE NOT NULL,
    site_code INT NOT NULL,
    sku BIGINT,  -- SKU NULL
    sales_qty INT NOT NULL
);

SELECT *  FROM sales

CREATE TABLE products (
    gtin VARCHAR(255) NOT NULL,
    categoryParent VARCHAR(255),
    colorLabel VARCHAR(255),
    modelLabel VARCHAR(255),
    productLabelLong TEXT,  -- Use TEXT to long string?
    sizeLabel VARCHAR(255),
    productCode VARCHAR(255),
    PRIMARY KEY (gtin, productCode) -- PK composed
);

SELECT * FROM products

CREATE TABLE soh (
    site_code INT NOT NULL,
    sku VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    date DATE NOT NULL,
    PRIMARY KEY (site_code, sku, quantity, date) -- PK composed
);


-- APPLYING the correct data types

CREATE TABLE sales2 (
    id INT AUTO_INCREMENT PRIMARY KEY,  -- New column ID autoincremental as PK
    date DATE NOT NULL,
    site_code SMALLINT NOT NULL,
    sku VARCHAR(15),  -- SKU NULL
    sales_qty INT NOT NULL
);

SELECT *  FROM sales

CREATE TABLE products2 (
    gtin VARCHAR(15) NOT NULL,
    categoryParent VARCHAR(50),
    colorLabel VARCHAR(5),
    modelLabel VARCHAR(10),
    productLabelLong VARCHAR(100),
    sizeLabel VARCHAR(15),
    productCode VARCHAR(15),
    PRIMARY KEY (gtin, productCode) --- PK composed
);

SELECT * FROM products

CREATE TABLE soh2 (
    site_code SMALLINT NOT NULL,
    sku VARCHAR(15) NOT NULL,  
    quantity INT NOT NULL,
    date DATE NOT NULL,
    PRIMARY KEY (site_code, sku, date) -- PK composed
);


CREATE TABLE soh3 (
    site_code SMALLINT NOT NULL,
    sku VARCHAR(15) NOT NULL,  
    quantity INT NOT NULL,
    date DATE NOT NULL,
    PRIMARY KEY (site_code, sku, date) -- PK composed
);

SELECT * FROM soh3 s 

SELECT COUNT(*)  FROM soh2 

-- Select all columns from SALES:
SELECT *
FROM sales;

-- EXPLAIN
EXPLAIN
SELECT *
FROM soh2;

-- EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT *
FROM soh2;


-- Select specific columns from PRODUCT:

SELECT productCode, categoryParent, colorLabel
FROM products;

-- Aggregate Functions

-- Total sales quantity for each site_code:
SELECT site_code, SUM(sales_qty) as total_sales
FROM sales
GROUP BY site_code

-- Total sales quantity for each site_code and order by total sales descendingly
SELECT site_code, SUM(sales_qty) as total_sales
FROM sales
GROUP BY site_code
ORDER BY total_sales desc

-- Average stock on hand for each sku:
SELECT sku, AVG(quantity) as avg_soh
FROM soh2
GROUP BY sku;


SELECT * FROM products p 
where productCode ='12926448705'

-- Sorting Data
-- Sort SALES by date in descending order:
SELECT `date` , site_code , sku , sales_qty 
FROM sales
ORDER BY date DESC;

-- Sort SOH by quantity in ascending order:
SELECT *
FROM soh2
ORDER BY quantity ASC;

-- Sort SOH by quantity in descending order:
SELECT *
FROM soh2
ORDER BY quantity DESC;

-- * Sort SOH by date in descending order and quantity in descending order:
SELECT *
FROM soh2
ORDER BY `date` DESC,quantity DESC;

-- * Sort SOH by date in descending order and quantity in descending order:
SELECT *
FROM soh2
ORDER BY `date` DESC,quantity DESC
LIMIT 5;

-- Grouping Data
-- Group SALES by date and site_code:
SELECT date, site_code, SUM(sales_qty) as daily_sales
FROM sales
GROUP BY date, site_code;

-- Group PRODUCT by categoryParent:
SELECT categoryParent, COUNT(categoryParent) as num_products
FROM products
GROUP BY categoryParent;

-- Limitations of WHERE
-- We only want to filter for the number of products higher than 500
SELECT categoryParent, COUNT(categoryParent) as num_products
FROM products
WHERE COUNT(categoryParent) > 500
GROUP BY categoryParent;

-- Aggregate functions are not allowed in WHERE!

-- SQL HAVING
SELECT categoryParent, COUNT(categoryParent) as num_products
FROM products
GROUP BY categoryParent
HAVING COUNT(categoryParent) > 500



-- Joining Tables
-- Join SALES and PRODUCT on sku (assuming sku is consistent across tables):
SELECT 
    S.date, 
    S.site_code, 
    S.sku, 
    S.sales_qty, 
    P.categoryParent, 
    P.colorLabel
FROM sales S
JOIN products P ON S.sku = P.productCode; 


-- Join SALES and SOH on site_code and sku:
SELECT 
    S.date, 
    S.site_code, 
    S.sku, 
    S.sales_qty, 
    ST.quantity as stock_qty
FROM sales S
JOIN soh ST ON S.site_code = ST.site_code AND S.sku = ST.sku;



-- Join SALES and SOH on site_code and sku (v2 soh2 with INDEX)
SELECT 
    S.date, 
    S.site_code, 
    S.sku, 
    S.sales_qty, 
    ST.quantity as stock_qty
FROM sales2 S
JOIN soh2 ST ON S.site_code = ST.site_code AND S.sku = ST.sku;


-- EXPLAIN ANALYZE
-- Join SALES and SOH on site_code and sku
EXPLAIN ANALYZE
SELECT 
    S.date, 
    S.site_code, 
    S.sku, 
    S.sales_qty, 
    ST.quantity as stock_qty
FROM sales S
JOIN soh ST ON S.site_code = ST.site_code AND S.sku = ST.sku;

-- EXPLAIN ANALYZE
-- Join SALES and SOH on site_code and sku (v2 soh2 with INDEX)
EXPLAIN ANALYZE
SELECT 
    S.date, 
    S.site_code, 
    S.sku, 
    S.sales_qty, 
    ST.quantity as stock_qty
FROM sales2 S
JOIN soh2 ST ON S.site_code = ST.site_code AND S.sku = ST.sku;


-- Calculate sales trend over time:
SELECT date, SUM(sales_qty) as total_sales
FROM sales s 
GROUP BY date
ORDER BY date;

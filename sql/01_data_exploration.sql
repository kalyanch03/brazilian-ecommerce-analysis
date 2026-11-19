
-- =====================================================
-- PROJECT: Brazilian E-Commerce Data Analysis
-- DATA SOURCE: Olist Brazilian E-Commerce Dataset
-- DATABASE: olist_ecommerce
-- TOOL: MySQL 8.0
-- =====================================================

USE olist_ecommerce;


-- 1. CHECK TOTAL ORDERS

SELECT
    COUNT(*) AS total_orders
FROM orders;


-- 2. CHECK ORDER STATUS DISTRIBUTION

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- 3. CHECK CUSTOMER RECORDS AND UNIQUE CUSTOMERS

SELECT
    COUNT(*) AS customer_records,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;


-- 4. CHECK ORDER DATE RANGE

SELECT
    MIN(order_purchase_timestamp) AS first_order_date,
    MAX(order_purchase_timestamp) AS last_order_date
FROM orders;

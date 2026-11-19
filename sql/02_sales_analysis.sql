
-- =====================================================
-- PROJECT: Brazilian E-Commerce Data Analysis
-- MODULE: Sales Analysis
-- DATABASE: olist_ecommerce
-- TOOL: MySQL 8.0
-- =====================================================

USE olist_ecommerce;


-- 1. OVERALL ORDER-ITEM VALUE (ALL ORDER STATUSES)
-- This query includes all order statuses; it is not delivered-only revenue.

SELECT
    COUNT(*) AS total_order_items,
    ROUND(SUM(price), 2) AS total_product_sales,
    ROUND(SUM(freight_value), 2) AS total_freight,
    ROUND(SUM(price + freight_value), 2) AS total_order_value
FROM order_items;


-- 2. MONTHLY PRODUCT REVENUE TREND
-- Includes delivered orders only

SELECT
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS monthly_revenue
FROM orders o
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    order_year,
    order_month;


-- 3. PRODUCT CATEGORY REVENUE ANALYSIS
-- Delivered orders only

SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'uncategorized'
    ) AS product_category,
    COUNT(*) AS items_sold,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
INNER JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY product_category
ORDER BY total_revenue DESC;


-- 4. PRODUCT CATEGORY REVENUE CONTRIBUTION (%)

SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'uncategorized'
    ) AS product_category,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(
        SUM(oi.price) * 100.0 /
        (
            SELECT SUM(oi2.price)
            FROM order_items oi2
            INNER JOIN orders o2
                ON oi2.order_id = o2.order_id
            WHERE o2.order_status = 'delivered'
        ),
        2
    ) AS revenue_percentage
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
INNER JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY product_category
ORDER BY total_revenue DESC;


-- 5. AVERAGE SELLING PRICE BY PRODUCT CATEGORY
-- Minimum 100 delivered items per category

SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'uncategorized'
    ) AS product_category,
    COUNT(*) AS items_sold,
    ROUND(AVG(oi.price), 2) AS average_selling_price,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
INNER JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY product_category
HAVING COUNT(*) >= 100
ORDER BY average_selling_price DESC;


-- 6. TOP 10 PRODUCTS BY REVENUE
-- Delivered orders only

SELECT
    oi.product_id,
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'uncategorized'
    ) AS product_category,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
INNER JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY
    oi.product_id,
    product_category
ORDER BY total_revenue DESC
LIMIT 10;


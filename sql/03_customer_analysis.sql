
-- =====================================================
-- CUSTOMER ANALYSIS
-- PROJECT: Brazilian E-Commerce Data Analysis
-- OBJECTIVE: Analyse order distribution by customer state
-- =====================================================

USE olist_ecommerce;


-- 1. STATE-WISE ORDER DISTRIBUTION

SELECT
    c.customer_state,
    COUNT(o.order_id) AS total_orders
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;


-- 2. STATE-WISE ORDER CONTRIBUTION (%)

SELECT
    c.customer_state,
    COUNT(o.order_id) AS total_orders,
    ROUND(
        COUNT(o.order_id) * 100.0 /
        (SELECT COUNT(*) FROM orders),
        2
    ) AS order_percentage
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;


-- 3. REPEAT CUSTOMER COUNT

SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        c.customer_unique_id
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) > 1
) AS repeat_customer_list;


-- 4. REPEAT CUSTOMER RATE (%)

SELECT
    COUNT(*) AS repeat_customers,
    (SELECT COUNT(DISTINCT customer_unique_id)
     FROM customers) AS unique_customers,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(DISTINCT customer_unique_id)
         FROM customers),
        2
    ) AS repeat_customer_rate
FROM (
    SELECT
        c.customer_unique_id
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) > 1
) AS repeat_customer_list;


-- 5. CUSTOMER ORDER FREQUENCY SEGMENTATION

SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time customer'
        WHEN order_count = 2 THEN 'Two orders'
        ELSE 'Three or more orders'
    END AS customer_type,
    COUNT(*) AS total_customers
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS customer_orders
GROUP BY customer_type
ORDER BY total_customers DESC;

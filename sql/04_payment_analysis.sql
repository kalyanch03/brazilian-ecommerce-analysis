
-- PROJECT: Brazilian E-Commerce Data Analysis
-- ANALYSIS: Payment Method Analysis
-- DATABASE: olist_ecommerce
-- TOOL: MySQL 8.0

USE olist_ecommerce;

-- 1. PAYMENT METHOD DISTRIBUTION

SELECT
    payment_type,
    COUNT(*) AS payment_records,
    COUNT(DISTINCT order_id) AS unique_orders,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
GROUP BY payment_type
ORDER BY unique_orders DESC;


-- 2. PAYMENT VALUE CONTRIBUTION BY METHOD (%)

SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS payment_value,
    ROUND(
        SUM(payment_value) * 100.0 /
        (SELECT SUM(payment_value) FROM payments),
        2
    ) AS payment_value_percentage
FROM payments
GROUP BY payment_type
ORDER BY payment_value DESC;


-- 3. CREDIT CARD INSTALMENT ANALYSIS

SELECT
    payment_installments,
    COUNT(*) AS payment_records,
    COUNT(DISTINCT order_id) AS unique_orders,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM payments
WHERE payment_type = 'credit_card'
GROUP BY payment_installments
ORDER BY payment_installments;


-- 4. AVERAGE PAYMENT VALUE BY PAYMENT METHOD

SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS unique_orders,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(
        SUM(payment_value) / COUNT(DISTINCT order_id),
        2
    ) AS average_payment_per_order
FROM payments
GROUP BY payment_type
ORDER BY average_payment_per_order DESC;


-- 5. PAYMENT RECORDS PER ORDER

SELECT
    payment_count,
    COUNT(*) AS total_orders
FROM (
    SELECT
        order_id,
        COUNT(*) AS payment_count
    FROM payments
    GROUP BY order_id
) AS order_payments
GROUP BY payment_count
ORDER BY payment_count;

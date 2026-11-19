
-- PROJECT: Brazilian E-Commerce Data Analysis
-- ANALYSIS: Delivery Performance
-- DATABASE: olist_ecommerce
-- TOOL: MySQL 8.0

USE olist_ecommerce;

-- 1. OVERALL DELIVERY PERFORMANCE
-- Calendar-day calculations, consistent with the Power BI DATEDIFF(..., DAY) measure.
-- Average actual and estimated days use the same delivered orders with a valid actual delivery date.

SELECT
    COUNT(*) AS total_delivered_orders,
    COUNT(order_delivered_customer_date) AS orders_with_delivery_date,
    ROUND(
        AVG(DATEDIFF(
            order_delivered_customer_date,
            order_purchase_timestamp
        )),
        2
    ) AS avg_actual_delivery_days,
    ROUND(
        AVG(DATEDIFF(
            order_estimated_delivery_date,
            order_purchase_timestamp
        )),
        2
    ) AS avg_estimated_delivery_days,
    ROUND(
        AVG(DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        )),
        2
    ) AS avg_days_vs_estimate
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- 2. EARLY, ON-TIME AND LATE DELIVERY CLASSIFICATION

SELECT
    delivery_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM (
    SELECT
        CASE
            WHEN DATE(order_delivered_customer_date)
                 < DATE(order_estimated_delivery_date)
                THEN 'Early'

            WHEN DATE(order_delivered_customer_date)
                 = DATE(order_estimated_delivery_date)
                THEN 'On Time'

            ELSE 'Late'
        END AS delivery_status
    FROM orders
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
) AS delivery_classification
GROUP BY delivery_status
ORDER BY total_orders DESC;


-- 3. LATE DELIVERY RATE BY CUSTOMER STATE
-- Denominator includes all delivered orders (same definition as the Power BI rate);
-- orders without an actual delivery timestamp cannot be counted as late.

SELECT
    c.customer_state,
    COUNT(*) AS total_delivered_orders,

    SUM(
        CASE
            WHEN DATE(o.order_delivered_customer_date)
                 > DATE(o.order_estimated_delivery_date)
            THEN 1
            ELSE 0
        END
    ) AS late_orders,

    ROUND(
        SUM(
            CASE
                WHEN DATE(o.order_delivered_customer_date)
                     > DATE(o.order_estimated_delivery_date)
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_percentage

FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id

WHERE o.order_status = 'delivered'

GROUP BY c.customer_state
HAVING COUNT(*) >= 100
ORDER BY late_delivery_percentage DESC;


-- 4. AVERAGE DELIVERY TIME BY CUSTOMER STATE

SELECT
    c.customer_state,
    COUNT(*) AS delivered_orders,

    ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp
            )
        ),
        2
    ) AS avg_delivery_days

FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL

GROUP BY c.customer_state
HAVING COUNT(*) >= 100
ORDER BY avg_delivery_days DESC;


-- 5. DELIVERY DELAY SEVERITY ANALYSIS

SELECT
    COUNT(*) AS late_orders,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                HOUR,
                order_estimated_delivery_date,
                order_delivered_customer_date
            ) / 24
        ),
        2
    ) AS avg_days_late,

    ROUND(
        MAX(
            TIMESTAMPDIFF(
                HOUR,
                order_estimated_delivery_date,
                order_delivered_customer_date
            ) / 24
        ),
        2
    ) AS max_days_late,

    ROUND(
        SUM(
            TIMESTAMPDIFF(
                HOUR,
                order_estimated_delivery_date,
                order_delivered_customer_date
            ) / 24
        ),
        2
    ) AS total_delay_days

FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND DATE(order_delivered_customer_date)
      > DATE(order_estimated_delivery_date);


-- 6. MONTHLY LATE DELIVERY PERFORMANCE
-- Denominator includes all delivered orders in each month, matching the overall late-delivery KPI.

SELECT
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,

    COUNT(*) AS delivered_orders,

    SUM(
        CASE
            WHEN DATE(o.order_delivered_customer_date)
                 > DATE(o.order_estimated_delivery_date)
            THEN 1
            ELSE 0
        END
    ) AS late_orders,

    ROUND(
        SUM(
            CASE
                WHEN DATE(o.order_delivered_customer_date)
                     > DATE(o.order_estimated_delivery_date)
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_percentage

FROM orders o
WHERE o.order_status = 'delivered'

GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)

ORDER BY
    order_year,
    order_month;


-- 7. ORDER APPROVAL AND CARRIER HANDOVER ANALYSIS

SELECT
    COUNT(*) AS total_orders,

    COUNT(order_approved_at) AS approved_orders,

    COUNT(order_delivered_carrier_date)
        AS carrier_handover_orders,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                HOUR,
                order_purchase_timestamp,
                order_approved_at
            )
        ),
        2
    ) AS avg_purchase_to_approval_hours,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                HOUR,
                order_approved_at,
                order_delivered_carrier_date
            )
        ),
        2
    ) AS avg_approval_to_carrier_hours

FROM orders
WHERE order_status = 'delivered';


-- 8. CARRIER-TO-CUSTOMER DELIVERY TIME
-- Excludes inconsistent records where customer delivery precedes carrier handover.

SELECT
    COUNT(*) AS orders_with_both_dates,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                HOUR,
                order_delivered_carrier_date,
                order_delivered_customer_date
            ) / 24
        ),
        2
    ) AS avg_carrier_delivery_days,

    ROUND(
        MAX(
            TIMESTAMPDIFF(
                HOUR,
                order_delivered_carrier_date,
                order_delivered_customer_date
            ) / 24
        ),
        2
    ) AS max_carrier_delivery_days

FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date >= order_delivered_carrier_date;


-- 9. TOP 10 LONGEST CARRIER-TO-CUSTOMER DELIVERIES
-- Excludes inconsistent records where customer delivery precedes carrier handover.

SELECT
    o.order_id,
    c.customer_state,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,

    ROUND(
        TIMESTAMPDIFF(
            HOUR,
            o.order_delivered_carrier_date,
            o.order_delivered_customer_date
        ) / 24,
        2
    ) AS carrier_delivery_days

FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_carrier_date IS NOT NULL
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_delivered_customer_date >= o.order_delivered_carrier_date

ORDER BY carrier_delivery_days DESC
LIMIT 10;


-- 10. CHECK INCONSISTENT DELIVERY TIMESTAMPS

SELECT
    COUNT(*) AS inconsistent_delivery_records
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date
      < order_delivered_carrier_date;

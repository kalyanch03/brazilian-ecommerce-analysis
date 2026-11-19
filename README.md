# Brazilian E-Commerce Analysis (Olist)

## Project Overview

This project analyses the Brazilian E-Commerce Public Dataset by Olist
using MySQL and Power BI. It explores order performance, revenue,
customers, payment behaviour, product categories and delivery
performance.

The analysis uses a public dataset, not proprietary company data.

## Tools

-   MySQL 8 -- data exploration, joins, aggregations, subqueries, CTEs
    and analytical queries
-   Power BI Desktop -- data modelling, DAX measures, calculated columns
    and dashboard visualisation

## Dataset

**Source:** [Brazilian E-Commerce Public Dataset by Olist --
Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

Tables used: - `orders` - `customers` - `order_items` - `products` -
`payments` - `category_translation`

The dataset contains 99,441 orders and covers an incomplete period from
2016 to 2018. The initial and final years are partial periods, so
monthly and year-over-year comparisons should be interpreted with that
limitation in mind.

## Business Questions

1.  How many orders were placed, delivered and cancelled?
2.  What are delivered product revenue and average order value?
3.  Which months and product categories generated the most revenue?
4.  How are customers distributed geographically, and how many made
    repeat purchases?
5.  Which payment methods account for the largest payment value?
6.  How long does delivery take, and how often do orders arrive later
    than estimated?
7.  Which customer states have higher late-delivery rates?

## Key Findings

### Overall Performance

  Metric                                  Result
  --------------------------- ------------------
  Total orders                            99,441
  Delivered orders                        96,478
  Cancelled orders                           625
  Unique customers                        96,096
  Delivered product revenue     R\$13,221,498.11
  Average order value                  R\$137.04

**Revenue definition:** Delivered product revenue is the sum of
`order_items.price` for orders with `order_status = 'delivered'`. It
excludes freight and is not profit.

### Customer Analysis

-   96,096 distinct customers were identified using
    `customer_unique_id`.
-   2,997 customers placed more than one order, a repeat-customer rate
    of approximately 3.12%.
-   São Paulo, Rio de Janeiro and Minas Gerais together account for
    approximately 66.60% of orders by customer state.

The low observed repeat-customer rate is a finding in this dataset; it
does not, by itself, explain why customers did not return.

### Product and Sales Analysis

-   The top 10 product categories account for approximately 62.43% of
    delivered product revenue.
-   Health & Beauty generated the highest category revenue, followed by
    Watches & Gifts and Bed, Bath & Table.
-   November 2017 was the highest-revenue month in the delivered-order
    monthly analysis, at approximately R\$987,765.37.

Monthly trends should be interpreted carefully because 2016 and 2018 are
incomplete periods.

### Payment Analysis

-   Credit cards accounted for approximately 78.34% of recorded payment
    value.
-   Boleto accounted for approximately 17.92%.
-   Voucher and debit-card payments contributed smaller shares.

Payment value comes from the `payments` table and is different from
product revenue calculated using `order_items.price`.

### Delivery Analysis

-   Average purchase-to-delivery time was 12.50 calendar days for
    delivered orders with a customer delivery timestamp.
-   6,534 delivered orders were late based on a comparison of calendar
    dates.
-   The late-delivery rate was approximately 6.77% of delivered orders.
-   Among delivered orders with valid delivery timestamps, 88,644 were
    early, 6,534 were late and 1,292 were on time.
-   Eight delivered orders had no customer delivery timestamp and are
    excluded from delivery-status classification.

Late-delivery rates vary by customer state. State comparisons should be
interpreted alongside delivered-order volume.

## Power BI Dashboard

The report includes: - KPI cards for revenue, orders, customers, average
order value and delivery performance - Order-status breakdown - Monthly
delivered-revenue trend - Top 10 product categories by delivered
revenue - Revenue by payment method - Delivery performance
distribution - Late-delivery rate by customer state

The monthly revenue trend uses a chronological Month-Year field.
Delivery status is classified by calendar date: Early, Late or On Time.

## Project Structure

``` text
brazilian-ecommerce-analysis/
├── sql/
│   ├── 01_data_exploration.sql
│   ├── 02_sales_analysis.sql
│   ├── 03_customer_analysis.sql
│   ├── 04_payment_analysis.sql
│   └── 05_delivery_analysis.sql
├── insights/
│   ├── customer_analysis_findings.md
│   ├── delivery_analysis_findings.md
│   └── payment_analysis_findings.md
├── powerbi/
│   └── Olist_Ecommerce_Analysis.pbix
├── screenshots/
│   └── olist_dashboard.png
└── README.md
```

## How to Explore

1.  Download the dataset from the Kaggle source linked above.
2.  Import the required CSV files into a MySQL database named
    `olist_ecommerce`.
3.  Run the SQL scripts in the `sql` folder.
4.  Open `powerbi/Olist_Ecommerce_Analysis.pbix` in Power BI Desktop.
5.  View `screenshots/olist_dashboard.png` for a preview of the report.

The raw CSV dataset is not included in this repository. Download it from
the original source and follow its terms of use.

## Notes and Limitations

-   The dataset covers an incomplete period from 2016 to 2018.
-   Revenue is delivered product item value, not profit.
-   Payment value and product revenue are different measures from
    different tables.
-   Repeat-customer analysis uses `customer_unique_id`, not the
    order-specific `customer_id`.
-   Delivery classification compares calendar dates rather than exact
    timestamps.
-   Eight delivered orders have no customer delivery timestamp.
-   State-level delivery comparisons should be considered together with
    order volume.

## Acknowledgement

Dataset: **Brazilian E-Commerce Public Dataset by Olist**, made
available on Kaggle. Refer to the original dataset page for source
information and applicable terms.

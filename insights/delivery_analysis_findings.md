
# Delivery Performance Analysis – Olist E-Commerce

## 1. Overall Delivery Performance
- Total delivered orders: 96,478.
- Orders with delivery timestamps: 96,470.
- Average actual delivery time: 12.54 days.
- Average estimated delivery time: 23.72 days.
- Actual delivery was approximately 11.16 days earlier than estimated on average.

## 2. Delivery Status Distribution
- Early deliveries: 88,644 (91.89%).
- On-time deliveries: 1,292 (1.34%).
- Late deliveries: 6,534 (6.77%).

## 3. Regional Delivery Performance
- Alagoas (AL) recorded the highest late-delivery rate at 21.41%.
- Maranhão (MA) followed with 17.43%.
- Amazonas (AM) had the longest average delivery time at 26.40 days.
- São Paulo (SP) had the shortest average delivery time at 8.74 days.
- São Paulo also recorded the highest number of late orders (1,820), despite a relatively low late-delivery rate of 4.49%.

## 4. Delivery Delay Severity
- Total late orders: 6,534.
- Average delay: 11.28 days.
- Maximum recorded delay: approximately 188.96 days.
- Combined delay across late orders: 73,707.46 days.

## 5. Monthly Delivery Performance
- November 2017 recorded a late-delivery rate of 12.40%.
- February 2018 recorded 14.13%.
- March 2018 recorded the highest substantial-volume monthly rate at 18.96%.
- April 2018 dropped to 4.50%.
- Monthly comparisons should be interpreted cautiously because the dataset has incomplete periods.

## 6. Order Processing and Transportation
- Average purchase-to-approval time: 9.93 hours.
- Average approval-to-carrier handover time: 66.70 hours.
- Average carrier-to-customer delivery time: 9.31 days.
- The transportation stage took the longest time in the measured delivery journey.

## 7. Extreme Delivery Cases
- The longest carrier-to-customer delivery took approximately 205.17 days.
- Several of the longest cases involved delivery on September 19, 2017.
- These unusual records require further investigation.

## 8. Data Quality Observations
- Eight delivered orders have missing customer delivery timestamps.
- Twenty-three records have customer delivery timestamps earlier than carrier handover timestamps.
- One order has no corresponding payment record.
- Extreme delivery durations should be investigated rather than automatically removed.

## Business Recommendations
- Investigate delivery performance in states with high late-delivery rates.
- Review logistics operations in regions with longer average delivery times.
- Examine the approval-to-carrier handover process for possible processing improvements.
- Investigate extreme delivery cases and inconsistent timestamps.
- Monitor late-delivery percentage as a key operational KPI.

## Data Source
Brazilian E-Commerce Public Dataset by Olist (Kaggle).

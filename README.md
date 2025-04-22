# E-Commerce Data Analysis Plan

This project outlines a comprehensive set of analyses to be performed on an e-commerce dataset, ranging from basic metrics to advanced business intelligence and predictive modeling.  

step by step data processing and analysis are stored here: https://docs.google.com/document/d/1abebqsE34jJFqVtDfr_EtFKU9kB2iUx5ocDSNXNeU14/edit?usp=sharing

### Simple Analyses
1. **Customer Demographics Analysis**  
   - What is the distribution of customers by age, gender, city, state, and country?  
   - How does yearly income vary across different customer segments?  
   - What is the average number of children per customer, and how does it correlate with purchasing behavior?

2. **Customer Registration Trends**  
   - How has customer registration trended over time (monthly/quarterly/yearly)?  
   - Are there specific cities or states with higher registration rates?  
   - What is the retention rate of customers post-registration?

3. **Product Popularity Analysis**  
   - Which products (by product_id or product_name) have the highest/lowest sales volume?  
   - Which product categories and subcategories have the highest/lowest stock quantities?  
   - What is the distribution of product prices and costs across categories?

4. **Order Trends**  
   - What are the monthly/quarterly trends in order volume and total_amount?  
   - Which payment methods are most commonly used?  
   - What is the average discount_applied and tax_amount per order?

5. **Review Sentiment Analysis**  
   - What is the distribution of ratings (1-5) across products?  
   - Which products have the highest/lowest average ratings?  
   - How frequently are reviews submitted relative to orders?

6. **Basic Sales Metrics**  
   - What is the average order value (total_amount) by customer segment (e.g., age, income, location)?  
   - What percentage of orders include discounts?  
   - How does shipping_cost vary by city, state, or country?

7. **Stock and Supply Analysis**  
   - Which products have low stock_quantity relative to their sales volume?  
   - How frequently are products added (added_date) compared to their sales?  
   - Which suppliers (supplier_id) contribute to the most/least popular products?

### Intermediate Analyses
8. **Customer Purchase Behavior**  
   - What is the average number of orders per customer?  
   - How does the frequency of purchases vary by customer demographics (age, gender, income)?  
   - Which customers have high yearly_income but low order frequency?

9. **Product Category Performance**  
   - Which product categories/subcategories contribute the most to total revenue?  
   - How does the profit margin (price - cost) vary across categories/subcategories?  
   - Are there categories with high stock but low sales?

10. **Order Fulfillment Analysis**  
    - What is the average time between order_date and delivery_date?  
    - How does delivery time vary by city, state, or country?  
    - What percentage of orders have a shipment_date significantly delayed from order_date?

11. **Payment Issues**  
    - What is the rate of failed or pending payments (payment_status)?  
    - How does payment_method correlate with payment_status?  
    - Are there patterns in payment failures by customer segment or order size?

12. **Customer Session Behavior**  
    - What is the average session_duration and pages_visited per session?  
    - How does device_type or browser impact session_duration or order conversion?  
    - Are there differences in session behavior between high- and low-spending customers?

13. **Geographic Sales Analysis**  
    - Which cities/states/countries generate the highest/lowest revenue?  
    - How does order_source (e.g., online, app, in-store) vary by geographic region?  
    - Are there regions with high customer registrations but low order volumes?

14. **Discount Impact**  
    - How does discount_applied correlate with order volume or total_amount?  
    - Are there products or categories where discounts lead to higher sales?  
    - What is the relationship between discount_applied and customer retention?

### Complex/Advanced Analyses
15. **Customer Segmentation**  
    - Can customers be clustered based on demographics, purchase frequency, and session behavior?  
    - Which customer segments have the highest lifetime value (LTV)?  
    - How do high-LTV customers differ from low-LTV customers in behavior and preferences?

16. **Cohort Analysis**  
    - What is the churn rate of customers (no orders after a certain period)?  
    - Are there patterns in churn by demographics, order_source, or product preferences?  
    - How does session behavior (e.g., pages_visited, session_duration) predict churn?

17. **Product Recommendation Opportunities**  
    - Which products are frequently purchased together (market basket analysis)?  
    - Are there subcategory_id combinations that could be bundled to increase sales?  
    - How do reviews (rating, review_text) influence subsequent purchases of similar products?

18. **Pricing Strategy Analysis**  
    - How does price elasticity vary across products or categories?  
    - Are there products where a price increase/decrease could optimize revenue?  
    - How does the gap between cost and price impact sales volume?

19. **Customer Acquisition Analysis**  
    - What is the cost of acquiring customers (based on order_source and first order)?  
    - Which order_source channels yield the highest retention or LTV?  
    - Are there seasonal patterns in customer acquisition by region?

20. **Supply Chain Efficiency**  
    - How does supplier_id performance correlate with stock_quantity and delivery_date?  
    - Are there products with frequent stockouts that impact sales?  
    - What is the relationship between added_date and sales velocity?

21. **Funnel Conversion Analysis**  
    - What is the conversion rate from customer_sessions to orders?  
    - How do pages_visited and session_duration impact conversion rates?  
    - Are there specific device_type or browser combinations with lower conversion rates?

22. **Predictive Sales Modeling**  
    - Can historical order data predict future sales by product or category?  
    - What factors (e.g., discounts, reviews, stock) most strongly predict order volume?  
    - How accurately can customer demographics predict repeat purchases?

23. **Cross-Channel Behavior Analysis**  
    - How does customer behavior differ across order_source (e.g., app vs. website)?  
    - Are there customers who use multiple channels but have low order frequency?  
    - How does session behavior on different devices impact order completion?

24. **Anomaly Detection**  
    - Are there outliers in order_amount, discount_applied, or shipping_cost that indicate errors or fraud?  
    - Which customers exhibit unusual session behavior (e.g., extremely short/long sessions)?  
    - Are there products with unexpected sales drops despite high stock and good reviews?

These analyses range from descriptive (simple) to predictive and prescriptive (complex), covering customer behavior, product performance, operational efficiency, and strategic opportunities. Each question or scenario is designed to uncover potential problems or growth levers for the company.



---

### **Goal: Perform Cohort Analysis and Calculate CLV (Customer Lifetime Value)**  
We want to understand how valuable our customers are over time and how retention and churn evolve in monthly cohorts.

---

### **Section 1: Calculate `grand_total` for Each Order**

**Target**  
Calculate the total monetary value (grand total) of each order.

**Importance**  
This is crucial because Customer Lifetime Value depends on how much a customer spends — we need accurate total order values to analyze revenue per customer over time.

**Implementation**  
I’ve created a **view named `grand_total`** that adds the product of price and quantity for each order, then adds tax and shipping cost, and subtracts any discount applied. This ensures each order has its correct revenue.

```sql
CREATE OR REPLACE VIEW grand_total AS
WITH find_grand_total AS (
  SELECT order_id, SUM(aup.price * oi.quantity) AS total
  FROM order_items oi
  LEFT JOIN all_unique_products aup ON oi.product_id = aup.product_id
  GROUP BY order_id
)
SELECT o.order_id, (fgt.total + o.tax_amount + o.shipping_cost - o.discount_applied) AS grand_total
FROM orders o
LEFT JOIN find_grand_total fgt ON o.order_id = fgt.order_id;
```

---

### **Section 2: Perform Cohort Analysis**

**Target**  
Group customers into cohorts based on their first purchase month and track their monthly activity since that first purchase.

**Importance**  
This helps visualize customer behavior over time — like retention, churn, and engagement — which is key for measuring loyalty and business health.

**Implementation**  
I’ve assigned each customer to their first transaction month, then calculated how many months have passed since that transaction for each order. This helps build month-by-month cohort behavior.

```sql
WITH cohort_analysis AS (
  SELECT 
    customer_id,
    DATE_TRUNC('month', MIN(order_date) OVER (PARTITION BY customer_id)) AS FirstTransactionMonth,
    EXTRACT(YEAR FROM AGE(order_date, MIN(order_date) OVER (PARTITION BY customer_id))) * 12 +
    EXTRACT(MONTH FROM AGE(order_date, MIN(order_date) OVER (PARTITION BY customer_id))) AS MonthsSinceFirstTransaction
  FROM orders
)
```

---

### **Section 3: Count Monthly Active Customers per Cohort (Retention)**

**Target**  
Count how many customers from each cohort returned in Month 1, 2, ..., up to Month 15.

**Importance**  
This shows retention behavior — how well we’re keeping customers month after month. The Month 0 count is the size of the original cohort.

**Implementation**  
I used `COUNT` with `CASE` statements for each month since the first transaction, grouping by cohort start month. This creates a wide format table of retention counts.

```sql
cohort_counts AS (
  SELECT FirstTransactionMonth,
    COUNT(CASE WHEN MonthsSinceFirstTransaction = 0 THEN customer_id ELSE NULL END) AS Month_0,
    ...
    COUNT(CASE WHEN MonthsSinceFirstTransaction = 15 THEN customer_id ELSE NULL END) AS Month_15
  FROM cohort_analysis
  GROUP BY FirstTransactionMonth
)
```

---

### **Section 4: Calculate Monthly Churn Rate per Cohort**

**Target**  
Determine how many customers dropped off month by month for each cohort.

**Importance**  
Churn rate helps us identify how fast we’re losing customers — which is critical for improving customer retention strategies.

**Implementation**  
I calculated churn by comparing each month’s customer count to the Month 0 count using the formula `1 - (Month_N / Month_0)` and handled division by zero using `NULLIF()`.

```sql
SELECT
  TO_CHAR(FirstTransactionMonth, 'YYYY-Mon') AS COHORT_MONTH,
  Month_0,
  ROUND(1 - (Month_1::DECIMAL / NULLIF(Month_0, 0)), 2) AS Churn_1,
  ...
  ROUND(1 - (Month_15::DECIMAL / NULLIF(Month_0, 0)), 2) AS Churn_15
FROM cohort_counts
```

---

### **Section 5: Calculate CLV per Cohort**

**Target**  
Calculate how much revenue each cohort generates per month (Month 0 to 15).

**Importance**  
This helps us understand how customer spending behavior changes over time, which is vital for revenue forecasting and marketing ROI.

**Implementation**  
I joined `orders` with the `grand_total` view and then grouped orders by customer and month. I used `SUM(CASE WHEN ...)` for each month to aggregate revenue per cohort.

```sql
WITH customer_orders AS (...),
first_transactions AS (...),
cohort_analysis AS (...),
customer_lifetime_value AS (
  SELECT
    first_transaction_month,
    SUM(CASE WHEN months_since_first = 0 THEN grand_total ELSE 0 END) AS Month_0,
    ...
    SUM(CASE WHEN months_since_first = 15 THEN grand_total ELSE 0 END) AS Month_15
  FROM cohort_analysis
  GROUP BY first_transaction_month
)
```

---

### **Section 6: Display CLV Report**

**Target**  
Display monthly CLV amounts for each cohort.

**Importance**  
This helps in visually analyzing which cohort performed better in terms of revenue.

**Implementation**  
I selected cohort month and revenue values from Month 0 to Month 15 from the `customer_lifetime_value` CTE and displayed them in a readable format.

```sql
SELECT TO_CHAR(first_transaction_month, 'YYYY-Mon') AS cohort_month,
       Month_0, Month_1, ..., Month_15
FROM customer_lifetime_value;
```

---

### **Section 7: Calculate Total CLV**

**Target**  
Get a single value representing total customer lifetime value across all cohorts and months.

**Importance**  
This gives us an overview of total revenue generated over time from all customers — essential for financial analysis.

**Implementation**  
I added all month columns together and summed them across rows to get total CLV.

```sql
SELECT 
  SUM(
    Month_0 + Month_1 + Month_2 + ... + Month_15
  ) AS total_clv
FROM customer_lifetime_value;
-- Total CLV = 103045109.14
```

---

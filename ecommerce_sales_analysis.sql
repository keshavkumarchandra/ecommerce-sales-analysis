-- ================================================
-- Project: E-Commerce Sales Analysis
-- Author: Keshav Chandra Kumar
-- Tools: SQL, Python, Pandas, Excel, Power BI
-- ================================================

-- 1. Total orders aur total revenue
SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(AVG(sales), 2) AS avg_order_value
FROM ecommerce_sales;

-- 2. Top 10 best selling products
SELECT 
    product_name,
    SUM(quantity) AS total_quantity_sold,
    ROUND(SUM(sales), 2) AS total_revenue
FROM ecommerce_sales
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- 3. Category wise sales aur profit
SELECT 
    category,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) * 100.0 / SUM(sales), 2) AS profit_margin_pct
FROM ecommerce_sales
GROUP BY category
ORDER BY total_sales DESC;

-- 4. Monthly sales trend
SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    MONTHNAME(order_date) AS month_name,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS monthly_revenue
FROM ecommerce_sales
GROUP BY year, month, month_name
ORDER BY year, month;

-- 5. Peak sales months (top 3)
SELECT 
    MONTHNAME(order_date) AS month_name,
    ROUND(SUM(sales), 2) AS total_sales
FROM ecommerce_sales
GROUP BY month_name
ORDER BY total_sales DESC
LIMIT 3;

-- 6. Region wise sales performance
SELECT 
    region,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_sales
GROUP BY region
ORDER BY total_sales DESC;

-- 7. Customer segment analysis
SELECT 
    segment,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(AVG(sales), 2) AS avg_order_value
FROM ecommerce_sales
GROUP BY segment
ORDER BY total_revenue DESC;

-- 8. Shipping mode analysis
SELECT 
    ship_mode,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(DATEDIFF(ship_date, order_date)), 1) AS avg_shipping_days,
    ROUND(SUM(sales), 2) AS total_sales
FROM ecommerce_sales
GROUP BY ship_mode
ORDER BY total_orders DESC;

-- 9. Products with highest profit margin
SELECT 
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) * 100.0 / SUM(sales), 2) AS profit_margin_pct
FROM ecommerce_sales
GROUP BY product_name
HAVING total_sales > 1000
ORDER BY profit_margin_pct DESC
LIMIT 10;

-- 10. Year over year revenue growth
SELECT 
    YEAR(order_date) AS year,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    LAG(ROUND(SUM(sales), 2)) OVER (ORDER BY YEAR(order_date)) AS prev_year_revenue,
    ROUND((SUM(sales) - LAG(SUM(sales)) OVER (ORDER BY YEAR(order_date))) 
          * 100.0 / LAG(SUM(sales)) OVER (ORDER BY YEAR(order_date)), 2) AS growth_pct
FROM ecommerce_sales
GROUP BY year
ORDER BY year;

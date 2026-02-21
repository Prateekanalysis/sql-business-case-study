-- Revenue, profit proxy, orders, customers (SQLite)
-- Profit proxy = (unit_price - unit_cost) * qty after discount

WITH line AS (
  SELECT
    o.order_id,
    o.order_date,
    o.customer_id,
    o.country,
    o.channel,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    oi.discount,
    p.unit_cost,
    (oi.quantity * oi.unit_price) * (1 - oi.discount) AS revenue,
    (oi.quantity * (oi.unit_price - p.unit_cost)) * (1 - oi.discount) AS profit
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN products p ON oi.product_id = p.product_id
)
SELECT
  ROUND(SUM(revenue),2) AS total_revenue,
  ROUND(SUM(profit),2) AS total_profit,
  ROUND(SUM(profit)/SUM(revenue),4) AS profit_margin,
  COUNT(DISTINCT order_id) AS orders,
  COUNT(DISTINCT customer_id) AS customers
FROM line;

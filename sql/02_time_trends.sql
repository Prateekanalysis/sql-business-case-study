-- Monthly revenue & customers + MoM growth
WITH line AS (
  SELECT
    DATE(substr(o.order_date,1,7) || '-01') AS month,
    o.customer_id,
    (oi.quantity * oi.unit_price) * (1 - oi.discount) AS revenue
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
),
m AS (
  SELECT month,
         ROUND(SUM(revenue),2) AS revenue,
         COUNT(DISTINCT customer_id) AS customers
  FROM line
  GROUP BY month
)
SELECT
  month,
  revenue,
  customers,
  ROUND( (revenue - LAG(revenue) OVER (ORDER BY month)) / NULLIF(LAG(revenue) OVER (ORDER BY month),0), 4) AS revenue_mom
FROM m
ORDER BY month;

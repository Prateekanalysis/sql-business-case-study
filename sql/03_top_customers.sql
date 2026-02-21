-- Top customers by revenue (window function)
WITH line AS (
  SELECT
    o.customer_id,
    (oi.quantity * oi.unit_price) * (1 - oi.discount) AS revenue
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
),
c AS (
  SELECT customer_id, ROUND(SUM(revenue),2) AS revenue
  FROM line
  GROUP BY customer_id
)
SELECT customer_id, revenue,
       RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM c
ORDER BY revenue DESC
LIMIT 20;

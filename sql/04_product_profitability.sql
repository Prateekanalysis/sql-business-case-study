-- Product profitability (profit proxy)
WITH line AS (
  SELECT
    oi.product_id,
    p.category,
    p.sub_category,
    (oi.quantity * oi.unit_price) * (1 - oi.discount) AS revenue,
    (oi.quantity * (oi.unit_price - p.unit_cost)) * (1 - oi.discount) AS profit
  FROM order_items oi
  JOIN products p ON oi.product_id = p.product_id
)
SELECT
  category,
  sub_category,
  ROUND(SUM(revenue),2) AS revenue,
  ROUND(SUM(profit),2) AS profit,
  ROUND(SUM(profit)/SUM(revenue),4) AS margin
FROM line
GROUP BY category, sub_category
ORDER BY profit DESC;

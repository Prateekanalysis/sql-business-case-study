-- Simple monthly cohort retention: first purchase month vs active month
WITH first_order AS (
  SELECT customer_id, MIN(DATE(substr(order_date,1,7) || '-01')) AS cohort_month
  FROM orders
  GROUP BY customer_id
),
activity AS (
  SELECT o.customer_id,
         DATE(substr(o.order_date,1,7) || '-01') AS active_month
  FROM orders o
  GROUP BY o.customer_id, active_month
),
cohort AS (
  SELECT f.cohort_month, a.active_month, COUNT(*) AS active_customers
  FROM first_order f
  JOIN activity a ON f.customer_id = a.customer_id
  GROUP BY f.cohort_month, a.active_month
),
base AS (
  SELECT cohort_month, active_month, active_customers,
         (CAST(strftime('%Y', active_month) AS INT) - CAST(strftime('%Y', cohort_month) AS INT)) * 12 +
         (CAST(strftime('%m', active_month) AS INT) - CAST(strftime('%m', cohort_month) AS INT)) AS months_since
  FROM cohort
)
SELECT cohort_month, months_since, active_customers
FROM base
WHERE months_since BETWEEN 0 AND 12
ORDER BY cohort_month, months_since;

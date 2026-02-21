-- Data quality checks
SELECT COUNT(*) AS null_customers FROM orders WHERE customer_id IS NULL;
SELECT COUNT(*) AS neg_qty FROM order_items WHERE quantity <= 0;
SELECT COUNT(*) AS bad_discount FROM order_items WHERE discount < 0 OR discount > 0.9;
SELECT COUNT(*) AS missing_products
FROM order_items oi LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

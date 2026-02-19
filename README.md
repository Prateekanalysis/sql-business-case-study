# Advanced SQL Business Case Study (SQLite + 40+ queries)

A Germany-interview-ready SQL portfolio project. It generates a realistic e-commerce SQLite database and includes 40+ business queries (CTEs, window functions, cohort-style retention).

## How to run

1) Generate the SQLite database:
```bash
python src/00_build_sqlite_db.py
```
2) Open the database with any SQLite tool (DB Browser, DBeaver, VS Code extension).
3) Run queries from the `sql/` folder.


## Database schema

- `customers(customer_id, country, signup_date)`
- `products(product_id, category, sub_category, unit_cost)`
- `orders(order_id, order_date, customer_id, country, channel)`
- `order_items(order_id, product_id, quantity, unit_price, discount)`


## Skills demonstrated

- Joins, aggregations
- CTEs
- Window functions
- Retention/cohort logic
- Data quality checks


## Resume bullets (copy/paste)

- Built an interview-ready SQL case study by generating an e-commerce SQLite database and solving 40+ business questions using CTEs and window functions.
- Analyzed revenue trends, top customers, product profitability and retention cohorts to provide stakeholder-ready insights.


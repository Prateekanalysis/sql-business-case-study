import sqlite3
import numpy as np
import pandas as pd
from pathlib import Path

np.random.seed(11)

def main(n_customers=8000, n_products=250, n_orders=45000):
    out_dir = Path("data")
    out_dir.mkdir(parents=True, exist_ok=True)
    db_path = out_dir / "ecommerce.db"
    if db_path.exists():
        db_path.unlink()

    countries = ["Germany","France","Netherlands","Spain","Italy","Belgium","Austria","Sweden","Poland","Denmark"]
    channels = ["Web","Mobile","Marketplace"]

    # Customers
    signup_dates = pd.date_range("2023-01-01", "2025-12-31", freq="D")
    customers = pd.DataFrame({
        "customer_id": np.arange(10000, 10000+n_customers),
        "country": np.random.choice(countries, size=n_customers, p=[0.22,0.15,0.10,0.10,0.10,0.08,0.06,0.06,0.07,0.06]),
        "signup_date": np.random.choice(signup_dates, size=n_customers)
    })

    categories = ["Electronics","Home","Office","Sports","Beauty"]
    subcats = {
        "Electronics":["Phones","Accessories","Computers","Audio"],
        "Home":["Kitchen","Decor","Storage","Appliances"],
        "Office":["Paper","Binders","Chairs","Printers"],
        "Sports":["Fitness","Outdoor","Cycling","Team Sports"],
        "Beauty":["Skincare","Haircare","Makeup","Fragrance"]
    }

    # Products
    prod_rows = []
    for i in range(n_products):
        cat = np.random.choice(categories, p=[0.28,0.22,0.20,0.18,0.12])
        sc = np.random.choice(subcats[cat])
        unit_cost = np.round(np.random.lognormal(mean=3.3, sigma=0.6), 2)  # ~ 20-80 typical
        prod_rows.append((200000+i, cat, sc, unit_cost))
    products = pd.DataFrame(prod_rows, columns=["product_id","category","sub_category","unit_cost"])

    # Orders
    order_dates = pd.date_range("2023-01-01", "2025-12-31", freq="D")
    order_customer = np.random.choice(customers["customer_id"].values, size=n_orders)
    # Order country follows customer country
    cust_country_map = customers.set_index("customer_id")["country"].to_dict()
    order_country = [cust_country_map[c] for c in order_customer]
    orders = pd.DataFrame({
        "order_id": [f"ORD-{i:07d}" for i in range(n_orders)],
        "order_date": np.random.choice(order_dates, size=n_orders),
        "customer_id": order_customer,
        "country": order_country,
        "channel": np.random.choice(channels, size=n_orders, p=[0.55,0.30,0.15])
    })

    # Order items
    # 1-4 items per order
    n_items = np.random.randint(1, 5, size=n_orders)
    rows = []
    for oid, k in zip(orders["order_id"].values, n_items):
        prods = np.random.choice(products["product_id"].values, size=k, replace=False)
        for pid in prods:
            qty = int(np.random.poisson(2) + 1)
            base = float(products.loc[products["product_id"]==pid, "unit_cost"].iloc[0])
            markup = np.random.normal(1.55, 0.25)
            price = max(2.0, base * markup)
            disc = float(np.clip(np.random.beta(2, 10), 0, 0.35))
            rows.append((oid, int(pid), qty, round(price,2), round(disc,4)))
    order_items = pd.DataFrame(rows, columns=["order_id","product_id","quantity","unit_price","discount"])

    con = sqlite3.connect(db_path)
    customers.to_sql("customers", con, index=False)
    products.to_sql("products", con, index=False)
    orders.to_sql("orders", con, index=False)
    order_items.to_sql("order_items", con, index=False)

    # indexes
    con.execute("CREATE INDEX idx_orders_customer ON orders(customer_id);")
    con.execute("CREATE INDEX idx_orders_date ON orders(order_date);")
    con.execute("CREATE INDEX idx_items_order ON order_items(order_id);")
    con.execute("CREATE INDEX idx_items_product ON order_items(product_id);")
    con.commit()
    con.close()

    print("Built SQLite DB:", db_path)

if __name__ == "__main__":
    main()

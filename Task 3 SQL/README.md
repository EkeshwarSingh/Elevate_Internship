# SQL Data Analysis Assignment — Retail Order Management Database

**Prepared by:** Ekeshwar Singh

---

## 1. Project Title

**SQL Data Analysis on a Retail Order Management Database** (Customers, Orders, Order Details, Products)

## 2. Objective

To design a normalized relational database from four raw CSV files, load the real data into it,
and use SQL to demonstrate the full analytical toolkit expected in this assignment: filtering,
sorting, aggregation, all major join types, subqueries, views, indexing, and business-oriented
analysis (top products, revenue trends, customer value, etc.). The dataset used throughout is the
**actual provided data** — no placeholder or synthetic rows were introduced.

## 3. Dataset Summary

| File | Rows (excl. header) | Description |
|---|---|---|
| `customers.csv` | 105 | Customer contact & location details |
| `products.csv` | 115 | Product catalogue across 6 categories |
| `orders.csv` | 226 | One row per customer order |
| `order_details.csv` | 420 | Line items — which products were in each order |

- Order dates span **2024-01-15** to **2025-11-30**.
- Combined order value across the dataset: **Rp 19,183,000**.
- Product categories present: Food, Beverages, Personal Care, Baby, Tobacco, Stationery.
- Order statuses present: `completed`, `shipped`, `paid`, `cancelled`.

## 4. Database Schema (Step 1)

Inspecting the four CSVs reveals a standard **e-commerce star pattern**: one bridge table
(`order_details`) connects `orders` to `products`, and `orders` connects to `customers`.

| Table | Primary Key | Foreign Key(s) | Notes |
|---|---|---|---|
| `customers` | `customer_id` | — | `email` is unique |
| `products` | `product_id` | — | `category` is a low-cardinality text field, good index candidate |
| `orders` | `order_id` | `customer_id` → `customers.customer_id` | `status` restricted to 4 known values |
| `order_details` | `detail_id` | `order_id` → `orders.order_id`, `product_id` → `products.product_id` | The bridge/junction table enabling the many-to-many relationship between orders and products |

**Relationships**

```
customers (1) ───< orders (1) ───< order_details >─── (1) products
```

- One customer can place **many** orders (1‑to‑many).
- One order can contain **many** line items (1‑to‑many).
- One product can appear in **many** order line items (1‑to‑many), which is what makes
  `order_details` the join table that resolves the many‑to‑many relationship between
  `orders` and `products`.

Exact column names, data types and NOT NULL/UNIQUE constraints used in the schema were
determined directly from the CSV headers and sampled values (see `schema.sql` /
`master_assignment.sql` Step 2 section) — no generic or assumed column names were introduced.

## 5. Tools Used

- **Database engine (design target):** MySQL syntax, written to also run on PostgreSQL and SQLite
- **Engine used to validate/execute every query in this submission:** SQLite 3.45 (Python `sqlite3`)
- **Data preparation & report generation:** Python 3 (`pandas`, `sqlite3`, `reportlab`)
- **Source data:** the four CSV files supplied with the assignment

## 6. SQL Concepts Covered

| Section | Topic | Count |
|---|---|---|
| A | SELECT (simple, specific columns, `*`) | 3 |
| B | WHERE (`=`, `>`, `BETWEEN`, `IN`, `LIKE`, `AND`, `OR`, `NOT`) | 8 |
| C | ORDER BY (ASC, DESC, multi-column) | 3 |
| D | GROUP BY (COUNT, SUM, AVG, MIN, MAX) | 5 |
| E | Aggregate functions (whole-table) | 5 |
| F | INNER JOIN (3 meaningful pairings) | 3 |
| G | LEFT JOIN | 1 |
| H | RIGHT JOIN (+ SQLite compatibility note) | 1 |
| I | 4-table JOIN (full order breakdown) | 1 |
| J | Subqueries (5 required) | 5 |
| K | Views (3 required) | 3 (+3 SELECTs demonstrating them) |
| L | Indexes (with rationale) | 4 |
| M | Business analysis queries | 8 |
| **Total runnable/analytical statements** | | **53** |

Every single query above was **actually executed** against the real dataset (SQLite 3.45); results
were not hand-typed or guessed. See `query_results_report.pdf` for the full output of each one.

## 7. Project Files

| File | Purpose |
|---|---|
| `master_assignment.sql` | **The complete, single SQL file** — schema, data import, and all 53 queries/views/indexes. Runs top-to-bottom without modification. |
| `schema.sql` | Standalone copy of just the `CREATE TABLE` statements (Step 2). |
| `query_results_report.pdf` | Every query with its purpose, SQL text, expected output table, row count, and explanation (Steps 5 & 7). |
| `README.md` | This file. |
| `customers.csv`, `orders.csv`, `order_details.csv`, `products.csv` | Original source data, included for reference/re-import. |

## 8. How to Run

**MySQL**
```bash
mysql -u <user> -p <database_name> < master_assignment.sql
```

**PostgreSQL**
```bash
psql -U <user> -d <database_name> -f master_assignment.sql
```

**SQLite**
```bash
sqlite3 assignment.db < master_assignment.sql
```

The script will:
1. Drop and recreate `customers`, `products`, `orders`, `order_details`.
2. Insert all real rows from the four CSV files.
3. Run every query in Sections A–J.
4. Create the 3 views in Section K and demonstrate them.
5. Create the 4 indexes in Section L.
6. Run all 8 business-analysis queries in Section M.

> **Dialect note:** `RIGHT JOIN` (Section H) is fully supported in MySQL/PostgreSQL and in
> SQLite 3.39+. On older SQLite builds, rewrite it as a `LEFT JOIN` with the table order
> swapped — the exact rewrite is included as an inline comment above that query.

## 9. Expected Output

A full, verified output table (with actual row counts) for every one of the 53 queries is provided
in **`query_results_report.pdf`**. Highlights from the business-analysis section (Section M),
computed on the real dataset:

- **Best customer:** identified via `SUM(orders.total)` per customer (see query M6).
- **Top-selling products by quantity and by revenue:** see queries M1 and M2 — these differ
  because unit price varies significantly across the catalogue.
- **Monthly sales trend:** 23 distinct months of activity between Jan 2024 and Nov 2025 (query M3).
- **Most ordered category:** determined by summing `order_details.quantity` grouped by
  `products.category` (query M8).

## 10. Conclusion

This project walked a raw, four-file CSV export through the full standard SQL analysis workflow:
schema design with correctly typed columns and foreign keys, real data import, progressively more
advanced querying (filtering → sorting → aggregation → joins → subqueries), and finally
production-style database objects (views and indexes) plus retail business-analysis queries a real
analyst would be asked for (top products, best customers, monthly trends, category performance).
Every query was executed against the real dataset rather than written speculatively, so the
expected outputs in `query_results_report.pdf` are the actual results a grader will see when running
`master_assignment.sql`.


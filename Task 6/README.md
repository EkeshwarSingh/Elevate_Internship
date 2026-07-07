# Task 6: Sales Trend Analysis Using Aggregations

## What this task is about
We want to answer two simple business questions:
1. **How much money did we earn each month?** (revenue)
2. **How many orders did we get each month?** (order volume)

## Data used
- `Orders.csv` → loaded into an `orders` table (order_id, order_date, customer_name, state, city)
- `Details.csv` → loaded into a `details` table (order_id, amount, profit, quantity, category, sub_category, payment_mode)

Both files share the `order_id` column, so we **JOIN** them together to combine
the date (from orders) with the amount (from details).

## The tricky part: fixing the date
The date in `Orders.csv` looks like `10-03-2018` which is **DD-MM-YYYY**.
Most SQL date functions expect **YYYY-MM-DD**. So before grouping by month,
we rebuild the date string in the right order using `SUBSTR()`
(a beginner-friendly way of saying "cut out this piece of the text").

## The main query, step by step
1. **JOIN** `orders` and `details` on `order_id`.
2. **Extract** the year and month from the (fixed) date.
3. **SUM(amount)** → total revenue for that month.
4. **COUNT(DISTINCT order_id)** → number of unique orders that month.
5. **GROUP BY** year, month → collapses all rows into one row per month.
6. **ORDER BY** year, month → puts the months in time order (Jan, Feb, Mar...).

## Files in this package
| File | What it is |
|---|---|
| `task6_sales_trend_analysis.sql` | The full commented SQL script (all steps) |
| `monthly_results.csv` | The output table: revenue + order count per month |
| `online_sales.db` | The SQLite database built from your two CSVs (open with DB Browser for SQLite) |
| `README.md` | This file |

## Results summary (2018, the only year in this data)

| Month | Total Revenue (₹) | Orders |
|---|---|---|
| Jan | 61,632 | 61 |
| Feb | 38,962 | 54 |
| Mar | 60,694 | 58 |
| Apr | 34,330 | 44 |
| May | 29,093 | 31 |
| Jun | 23,658 | 30 |
| Jul | 12,966 | 31 |
| Aug | 31,492 | 31 |
| Sep | 27,283 | 30 |
| Oct | 31,613 | 43 |
| Nov | 48,469 | 46 |
| Dec | 37,579 | 41 |

**Top 3 months by revenue:** January (₹61,632), March (₹60,694), November (₹48,469)

**Quick takeaway:** Revenue and order count generally move together — more
orders usually means more revenue, which makes sense. July was the weakest
month on both counts, while January had the best combination of high orders
and high revenue.

## How to run it yourself
1. Open `online_sales.db` in **DB Browser for SQLite** (or import the two
   CSVs fresh into PostgreSQL/MySQL using the `CREATE TABLE` statements at
   the top of the `.sql` file).
2. Run `task6_sales_trend_analysis.sql` section by section (Step 1 → Step 5).
3. Compare your output to `monthly_results.csv`.

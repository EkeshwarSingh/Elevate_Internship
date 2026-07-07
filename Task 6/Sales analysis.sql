SELECT
    `Order Date`,
    substr(`Order Date`, 7, 4) || '-' ||
    substr(`Order Date`, 4, 2) || '-' ||
    substr(`Order Date`, 1, 2)          AS fixed_date
FROM orders
LIMIT 5;
SELECT
    YEAR(STR_TO_DATE(o.`Order Date`, '%d-%m-%Y')) AS sales_year,
    MONTH(STR_TO_DATE(o.`Order Date`, '%d-%m-%Y')) AS sales_month,
    SUM(d.`Amount`) AS total_revenue,
    COUNT(DISTINCT o.`Order ID`) AS order_volume
FROM Orders AS o
JOIN Details AS d
ON o.`Order ID` = d.`Order ID`
GROUP BY
    YEAR(STR_TO_DATE(o.`Order Date`, '%d-%m-%Y')),
    MONTH(STR_TO_DATE(o.`Order Date`, '%d-%m-%Y'))
ORDER BY sales_year, sales_month;

SELECT
    YEAR(STR_TO_DATE(o.`Order Date`, '%d-%m-%Y')) AS sales_year,
    MONTH(STR_TO_DATE(o.`Order Date`, '%d-%m-%Y')) AS sales_month,
    SUM(d.`Amount`) AS total_revenue,
    COUNT(DISTINCT o.`Order ID`) AS order_volume
FROM Orders AS o
JOIN Details AS d
ON o.`Order ID` = d.`Order ID`
GROUP BY
    YEAR(STR_TO_DATE(o.`Order Date`, '%d-%m-%Y')),
    MONTH(STR_TO_DATE(o.`Order Date`, '%d-%m-%Y'))
ORDER BY sales_year, sales_month;

SELECT
    YEAR(STR_TO_DATE(o.`Order Date`, '%d-%m-%Y')) AS sales_year,
    MONTH(STR_TO_DATE(o.`Order Date`, '%d-%m-%Y')) AS sales_month,
    SUM(d.`Amount`) AS total_revenue,
    COUNT(DISTINCT o.`Order ID`) AS order_volume
FROM Orders AS o
JOIN Details AS d
    ON o.`Order ID` = d.`Order ID`
GROUP BY
    YEAR(STR_TO_DATE(o.`Order Date`, '%d-%m-%Y')),
    MONTH(STR_TO_DATE(o.`Order Date`, '%d-%m-%Y'))
ORDER BY total_revenue DESC
LIMIT 12;
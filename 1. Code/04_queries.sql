/*__________________________
| Below are some sql queries|
| that are to done on the   |
| views that were created   | 
|__________________________*/

-- 1. Summarise each total expenses by month:
SELECT 
    YEAR(tran_date)         AS tran_year,
    MONTHNAME(tran_date)    AS tran_month,
    SUM(amount) AS total_amount
FROM EXPENSES_DB.PUBLIC.VW_CATEGORISED_EXPENSES
GROUP BY tran_year, tran_month
ORDER BY tran_year, tran_month;

-- 2. Find transactions that didn't match any category:
SELECT *
FROM EXPENSES_DB.PUBLIC.VW_CATEGORISED_EXPENSES ae
WHERE NOT EXISTS (
    SELECT 1
    FROM EXPENSES_DB.PUBLIC.EXPENSES_CATEGORY c
    WHERE UPPER(ae.tran_details) LIKE '%' || UPPER(c.exp_name) || '%'
);

-- 3. Monthly breakdown of expenses by category:
SELECT 
    TO_CHAR(tran_date, 'YYYY-MM') AS month,
    cat_type,
    SUM(amount) AS total_amount
FROM EXPENSES_DB.PUBLIC.VW_CATEGORISED_EXPENSES
GROUP BY TO_CHAR(tran_date, 'YYYY-MM'), cat_type
ORDER BY month, total_amount DESC;

-- 4. Top 10 most frequent transactions:
SELECT 
    tran_details,
    COUNT(*) AS frequency,
    SUM(amount) AS total_spent
FROM EXPENSES_DB.PUBLIC.VW_ALL_EXPENSES
GROUP BY tran_details
ORDER BY frequency DESC
LIMIT 10;

-- 6. Category contribution to total monthly spend:
WITH monthly_totals AS (
    SELECT 
        TO_CHAR(tran_date, 'YYYY-MM') AS month,
        SUM(amount) AS total_monthly_spend
    FROM EXPENSES_DB.PUBLIC.VW_CATEGORISED_EXPENSES
    GROUP BY TO_CHAR(tran_date, 'YYYY-MM')
),
category_monthly AS (
    SELECT 
        TO_CHAR(tran_date, 'YYYY-MM') AS month,
        cat_type,
        SUM(amount) AS category_spend
    FROM EXPENSES_DB.PUBLIC.VW_CATEGORISED_EXPENSES
    GROUP BY TO_CHAR(tran_date, 'YYYY-MM'), cat_type
)
SELECT 
    cm.month,
    cm.cat_type,
    cm.category_spend,
    mt.total_monthly_spend,
    ROUND((cm.category_spend / mt.total_monthly_spend) * 100, 2) AS spend_share_pct -- % spend per categiory
FROM category_monthly cm
INNER JOIN monthly_totals mt ON cm.month = mt.month
ORDER BY cm.month, spend_share_pct DESC;


-- 5. Days where spend was higher than average - up to 2 standard deviations (greater than 95% of the average spend):
WITH daily_spend AS (
    SELECT 
        tran_date,
        SUM(amount) AS total_daily_spend
    FROM EXPENSES_DB.PUBLIC.VW_ALL_EXPENSES
    GROUP BY tran_date
),
stats AS (
    SELECT 
        AVG(total_daily_spend) AS avg_spend,
        STDDEV(total_daily_spend) AS std_dev
    FROM daily_spend
)
SELECT 
    ds.tran_date,
    ds.total_daily_spend,
    s.avg_spend,
    s.std_dev
FROM daily_spend ds, stats s
WHERE ds.total_daily_spend > s.avg_spend + 2 * s.std_dev
ORDER BY ds.total_daily_spend DESC;
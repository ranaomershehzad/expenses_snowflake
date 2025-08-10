/*_________________________
| Here we will create some |
| custom views for quick   |
| analysis on the datasets | 
|_________________________*/

-- View 1: Raw combined expenses (no categorisation)
CREATE OR REPLACE VIEW "EXPENSES_DB"."PUBLIC"."VW_ALL_EXPENSES" AS
SELECT 
    TO_DATE(date, 'DD/MM/YYYY') AS tran_date,
    description AS tran_details,
    amount,
    'Amex' AS payment_method
FROM "EXPENSES_DB"."PUBLIC"."AMEX_EXPENSES"
WHERE amount > 0 -- is not a refund
UNION
SELECT 
    TO_DATE(date, 'DD/MM/YYYY') AS tran_date,
    description AS tran_details,
    ABS(amount) AS amount,
    'CommBank' AS payment_method
FROM "EXPENSES_DB"."PUBLIC"."COMMBANK_EXPENSES"
WHERE amount < 0 -- is an expense, not an income
ORDER BY tran_date;


-- View 2: Categorised expenses with filtering (in order to assign each expense to an expense category will visual purposes and filter out some specific categories)
CREATE OR REPLACE VIEW "EXPENSES_DB"."PUBLIC"."VW_CATEGORISED_EXPENSES" AS
SELECT 
    ae.tran_date,
    ae.tran_details,
    ae.amount,
    ae.payment_method,
    cl.cat_type
FROM "EXPENSES_DB"."PUBLIC"."VW_ALL_EXPENSES" ae
LEFT JOIN "EXPENSES_DB"."PUBLIC"."EXPENSES_CATEGORY" c 
    ON UPPER(ae.tran_details) LIKE '%' || UPPER(c.exp_name) || '%' -- lookup transactions to assign into a category
LEFT JOIN "EXPENSES_DB"."PUBLIC"."CATEGORY_LOOKUP" cl
    ON c.cat_id = cl.cat_id
WHERE cl.cat_filter = FALSE OR cl.cat_filter IS NULL -- filter out some categories
QUALIFY ROW_NUMBER() OVER (PARTITION BY ae.tran_date, ae.tran_details, ae.amount ORDER BY c.cat_id) = 1
ORDER BY ae.tran_date;
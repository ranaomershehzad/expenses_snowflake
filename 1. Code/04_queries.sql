

SELECT  
    tran_date,
    tran_details,
    cat_type,
    amount
FROM EXPENSES_DB.PUBLIC.VW_CATEGORISED_EXPENSES
WHERE monthname(tran_date) = 'Jul' AND cat_type IS NULL;
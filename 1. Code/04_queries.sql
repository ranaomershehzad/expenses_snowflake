
SELECT  
    tran_date,
    tran_details,
    amount
FROM EXPENSES_DB.PUBLIC.VW_CATEGORISED_EXPENSES
WHERE cat_type = 'Grocery' AND monthname(tran_date) = 'Jun'
/*_____________________________
| Update some datasets manually|
| to adjust new transactions   |
|_____________________________*/

-- Reassign some right categories
UPDATE EXPENSES_DB.PUBLIC.EXPENSES_CATEGORY
SET CAT_ID = 15
WHERE EXP_NAME IN ('DISNEY PLUS','KAYO SPORTS','Netflix','Optus Sport');

-- Update some the records with incorrect boolean filter
UPDATE EXPENSES_DB.PUBLIC.CATEGORY_LOOKUP
SET CAT_FILTER = FALSE
WHERE CAT_ID IN (1,12,19);

-- Delete Amazon income from commbank as it is going into wrong category
DELETE FROM EXPENSES_DB.PUBLIC.COMMBANK_EXPENSES
WHERE description LIKE '%AMAZON%';

-- Update/Add Expense Category table;
INSERT INTO EXPENSES_DB.PUBLIC.EXPENSES_CATEGORY (EXP_NAME, CAT_ID) VALUES
('Mandi', 2),
('PERTHAIRPORT', 18),
('CHUNKZ ACAI', 2),
('PHAR ATWELL', 14),
('MEAT AND WINE', 2),
('Membership Rewards Credit', 13),
('HUNTER AND BARREL', 2),
('The Cheesecake Shop', 2),
('Pandora', 14);
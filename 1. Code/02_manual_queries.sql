-- Add new expense types
INSERT INTO EXPENSES_DB.PUBLIC.EXPENSES_CATEGORY (EXP_NAME, CAT_ID) VALUES
('Fast Transfer', 10),
('CULTURE KINGS', 14),
('NANDO', 2),
('HOME AFFAIRS', 19),
('INDITEX', 14),
('HAKATA GENSUKE', 2),
('PayID Payment Received, Thank you', 10),
('Salary Remitter GOPPL', 10),
('BUPA MEDICAL', 19),
('JETSTAR', 18),
('HI THAI', 2),
('Atwell Fish', 2),
('HOTHAM VALLEY', 18),
('Y D', 14),
('DIDI', 10),
('EasyPark', 17),
('LAL QILA', 2),
('ASSURANCE VENTURE', 5),
('ONLINE PAYMENT RECEIVED', 10);

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
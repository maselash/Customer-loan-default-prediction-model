-- Joining tables to create key features to build a training data_set to train loan defualt prediction model

WITH Loan_behaviour AS (
	SELECT 
		row_number() over() 				    AS Row_num,
		l.loan_id,
		COUNT(t.account_id) 					AS Total_num_trans,
		SUM(t.balance)						 	AS Total_balance,
		AVG(t.balance)							AS Avg_balance
	FROM trans t
	LEFT JOIN loan l
		on t.account_id = l.account_id
	WHERE STR_TO_DATE(CONCAT('19', t.date), '%Y%m%d') < STR_TO_DATE(CONCAT('19', l.date), '%Y%m%d')
	GROUP BY l.loan_id, t.account_id
    )
SELECT 
	l.loan_id,
    a.district_id										AS District_account_opened,
    
    -- client info
    CASE WHEN c.gender 
    iN ('FEMALE') THEN 1 ELSE 0 END                      AS Gender,
   TIMESTAMPDIFF(YEAR, c.Birth_date,
        STR_TO_DATE(CONCAT('19', l.date), '%Y%m%d'))    AS Age_at_loan,
   
   -- Loan info
    TIMESTAMPDIFF(MONTH,
        STR_TO_DATE(CONCAT('19', a.date), '%Y%m%d'),
        STR_TO_DATE(CONCAT('19', l.date), '%Y%m%d'))    AS Months_open_before_loan,
    l.amount											AS Amount,
    l.duration											AS Duration,
    l.payments											AS Monthly_payments,
    
    -- ML target variable
    CASE WHEN l.status 
    IN ('B','D') THEN 1 ELSE 0 END                      AS Default_flag,
   
   -- Transaction info
   lb.Total_num_trans,
   lb.total_balance,
   lb.avg_balance,
   
   -- Credict card users with loans
    CASE WHEN cd.card_id
    IS NULL THEN 0 ELSE 1 END                           AS Credit_card_issued,
    CASE WHEN cd.type IS NULL THEN 1 ELSE 0 END         AS No_credict_card,
    CASE WHEN cd.type = 'junior' THEN 1 ELSE 0 END      AS Junior_Credit_card,
    CASE WHEN cd.type = 'classic' THEN 1 ELSE 0 END     AS Classic_Credit_card,
    CASE WHEN cd.type = 'gold' THEN 1 ELSE 0 END        AS Gold_Credit_card,

   -- District info
    di.A11												AS Distict_Avg_Salary,
    di.A12												AS Unemploymenr_rate_1995,
    di.A13 												As Unemploymenr_rate_1996
FROM loan l
JOIN account a
	ON l.account_id = a.account_id 
JOIN disp d
	ON l.account_id = d.account_id
JOIN client2 c
	ON d.client_id = c.client_id
LEFT JOIN demograph di
	ON di.A1 = c.district_id
LEFT JOIN card cd
	ON cd.disp_id = d.disp_id
JOIN Loan_behaviour lb
	ON l.loan_id = lb.loan_id
WHERE d.type = 'OWNER'
;
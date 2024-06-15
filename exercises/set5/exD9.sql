CUSTOMER(-CustomerID-, Name)
ACCOUNT(-AccountID-, Balance, Branch, Country)
CUSTOMER_ACCOUNT(-CustomerID-, -AccountID-)

a) Find all branches that have at least one client who are the only holder (without 
co-holders) of a single current account (that is, customers to whom no other 
current account is in the name).

SELECT DISTINCT A.Branch
FROM ACCOUNT A
WHERE A.AccountID IN (SELECT CA.AccountID
		      FROM CUSTOMER_ACCOUNT CA
		      GROUP BY CA.AccountID
		      HAVING COUNT(*) = 1)
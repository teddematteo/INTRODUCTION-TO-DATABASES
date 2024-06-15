ACCOMMODATION(-CodeA-, Address, City, Area) 
LEASE(-CodC-, StartDate, EndDate*, PersonName, CodeA, MonthlyRent)

a) Find the name of people who have never rented accommodation with an area of more 
than 80 square meters.

SELECT DISTINCT PersonName
FROM LEASE L
WHERE CodeC NOT IN (SELECT CodeC
		    FROM ACCOMODATION A, LEASE L1
		    WHERE A.CodeA = L1.CodeA AND Area>80)


SELECT DISTINCT PersonName
FROM LEASE L
WHERE PersonName NOT IN (SELECT PersonName
		         FROM ACCOMODATION A, LEASE L1
		         WHERE A.CodeA = L1.CodeA AND Area>80)

b) Find the code and address of the apartments in Turin where the monthly fee has 
always been higher than 500 euros and for which at most 5 rental contracts have 
been stipulated.

SELECT CodeA, Address
FROM ACCOMODATION A
WHERE City = 'Turin'
      AND NOT EXISTS (SELECT CodeA
		      FROM ACCOMODATION A1, LEASE L
		      WHERE A1.CodeA = L.CodeA AND A1.CodeA = A.CodeA AND MonthlyRent<=500)
      AND CodeA IN (SELECT Code
		    FROM ACCOMODATION A1, LEASE L
		    WHERE A1.CodeA = L.CodeA
		    GROUP BY A1.CodeA
		    HAVING A1.CodeA = A.CodeA AND COUNT(*)<6)


SELECT CodeA, Address
FROM ACCOMODATION A
WHERE City = 'Turin'
      AND NOT EXISTS (SELECT *
		      FROM LEASE L
		      WHERE L.CodeA = A.CodeA AND MonthlyRent<=500)
      AND CodeA IN (SELECT CodeA
		    FROM LEASE L
		    GROUP BY CodeA
		    HAVING COUNT(*)<6)
		    
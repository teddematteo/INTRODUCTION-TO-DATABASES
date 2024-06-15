ACCOMMODATION(-CodeA-, Address, City, Area)
LEASE(-CodC-, StartDate, EndDate*, PersonName, CodeA, MonthlyRent)

a) Find the code, address and city of the accommodations that have an area greater than 
the average area of the accommodations of the cities in which they are located.

SELECT A.CodeA, A.Address, A.City
FROM ACCOMODATION A
WHERE A.Area > (SELECT AVG(A1.Area)
		FROM ACCOMODATION A1
		WHERE A1.City = A.City)


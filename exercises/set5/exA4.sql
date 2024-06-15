ACCOMMODATION(-CodeA-, Address, City, Area)
LEASE(-CodC-, StartDate, EndDate*, PersonName, CodeA, MonthlyRent)

a) Find the name of people who have entered into more than two rental contracts for 
the same apartment (at different times).

SELECT PersonName
FROM LEASE L
GROUP BY PersonName, CodeA
HAVING COUNT(DISTINCT StartDate)>2

b) Find, for cities where at least 100 contracts have been signed, the city, the maximum 
monthly cost of rents, the average monthly cost of rents, the maximum duration of 
contracts, the average duration of contracts and the total number of contracts 
concluded.

SELECT City, MAX(MonthlyRent), AVG(MonthlyRent), MAX(EndDate-StartDate), AVG(EndDate-StartDate), COUNT(*)
FROM ACCOMODATION A, LEASE L
WHERE A.CodA = L.CodA [AND EndDate IS NOT NULL]
GROUP BY City
HAVING COUNT(*)>=100
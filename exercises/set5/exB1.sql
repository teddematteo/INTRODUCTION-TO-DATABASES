ORCHESTRA(-CodeO-, NameO, DirectorName, NoElements) 
CONCERT(-CodeC-, Date, CodeO, CodeH, TicketPrice) 
HALL(-CodeH-, Name, City, Capacity)

a) Find the code and name of the orchestras with more than 30 elements that have given 
concerts both in Turin and in Milan and have never held concerts in Bologna.

SELECT CodeO, NameO
FROM ORCHESTRA O
WHERE NoElements>30 AND 
	CodeO IN (SELECT CodeO
	FROM CONCERT C, HALL H
	WHERE C.CodeH = H.CodeH AND City = Turin)
                    AND
	CodeO IN (SELECT CodeO
	FROM CONCERT C, HALL H
	WHERE C.CodeH = H.CodeH AND City = Milan)
	            AND
	CodeO NOT IN (SELECT CodeO
	FROM CONCERT C, HALL H
	WHERE C.CodeH = H.CodeH AND City = Bologna)
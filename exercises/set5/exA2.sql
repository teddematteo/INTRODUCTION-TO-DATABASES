PERSON(-TaxID-, Name, BirthDate)
PRIVATE_LESSON(-TaxID-, -Date-, -Hour-, InstID) 
INSTRUCTOR(-InstID-, NameI)

a) For each person view the tax code and the number of lessons attended

SELECT TaxID, COUNT(*)
FROM PRIVATE_LESSON
GROUP BY TaxID

b) For each person view the tax code, the name and the number of lessons attended

SELECT P.TaxID, P.Name, COUNT(*)
FROM PRIVATE_LESSON PL, PERSON P
WHERE PL.TaxID = P.TaxID
GROUP BY P.TaxID, P.Name

c) For each person view the tax code, the name, the number of lessons attended and the 
number of (different) instructors with whom he or she has done lessons

SELECT P.TaxID, P.Name, COUNT(*), COUNT(DISTINCT InstID)
FROM PRIVATE_LESSON PL, PERSON P
WHERE PL.TaxID = P.TaxID
GROUP BY P.TaxID, P.Name

d) For each person born after 1970 who has attended at least 5 lessons, view the tax 
code, the name, the number of lessons attended and the number of (different) 
instructors with whom he has taken lessons

SELECT P.TaxID, P.Name, COUNT(DISTINCT InstID)
FROM PERSON P, PRIVTE_LESSON PL
WHERE P.TaxID = PL.TaxID AND BirthDate>31/12/1969
GROUP BY P.TaxID, P.Name
HAVING COUNT(*)>4
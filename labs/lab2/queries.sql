#ex1
SELECT * FROM DELIVERERS

#ex2
SELECT DISTINCT COMPANYID FROM COMPANYDEL

#ex3
SELECT NAME, DELIVERERID
FROM DELIVERERS
WHERE NAME LIKE 'B%'

#ex4
SELECT NAME, SEX, DELIVERERID
FROM DELIVERERS
WHERE PHONENO <> '8467' OR PHONENO IS NULL

#ex5
SELECT DISTINCT D.DELIVERERID, NAME, TOWN
FROM PENALTIES P, DELIVERERS D
WHERE P.DELIVERERID = D.DELIVERERID

#ex6
SELECT DISTINCT D.DELIVERERID, D.NAME, D.INITIALS
FROM COMPANIES C, PENALTIES P, DELIVERERS D
WHERE D.DELIVERERID = P.DELIVERERID AND D.DELIVERERID = C.DELIVERERID AND P.DATA > '12/31/2000'
ORDER BY NAME

#ex7
SELECT CD.DELIVERERID, CD.COMPANYID
FROM COMPANYDEL CD, DELIVERERS D
WHERE CD.DELIVERERID = D.DELIVERERID 
      AND D.TOWN = 'Stratford' AND CD.NUMDELIVERIES >=1 AND CD.NUMCOLLECTIONS >= 2

#ex8
SELECT DISTINCT D.DELIVERERID
FROM DELIVERERS D, COMPANYDEL CD
WHERE D.DELIVERERID = CD.DELIVERERID AND D.YEAR_OF_BIRTH > 1982
      AND CD.COMPANYID IN (SELECT C.COMPANYID
                           FROM COMPANIES C
                           WHERE C.MANDATE = 'first')
ORDER BY D.DELIVERERID DESC

#ex9
SELECT D.NAME
FROM DELIVERERS D, COMPANYDEL CD
WHERE D.DELIVERERID = CD.DELIVERERID AND (D.TOWN = 'Inglewood' OR D.TOWN = 'Stratford')
GROUP BY D.DELIVERERID, D.NAME
HAVING COUNT(DISTINCT CD.COMPANYID) >= 2

#ex10
SELECT D.DELIVERERID, SUM(P.AMOUNT)
FROM DELIVERERS D, PENALTIES P
WHERE D.DELIVERERID = P.DELIVERERID AND D.TOWN = 'Inglewood'
GROUP BY D.DELIVERERID
HAVING COUNT(*) >= 2

#ex11
SELECT D.NAME, MIN(P.AMOUNT)
FROM DELIVERERS D, PENALTIES P
WHERE D.DELIVERERID = P.DELIVERERID
GROUP BY D.DELIVERERID, D.NAME
HAVING COUNT(*) >= 2 AND COUNT(*) <= 4

#ex12
SELECT SUM(CD.NUMDELIVERIES), SUM(CD.NUMCOLLECTIONS)
FROM DELIVERERS D, COMPANYDEL CD
WHERE D.DELIVERERID = CD.DELIVERERID AND  D.TOWN <> 'Stratford' AND D.NAME LIKE 'B%'

#ex13
SELECT D.DELIVERERID, D.NAME, D.INITIALS
FROM DELIVERERS D
WHERE D.DELIVERERID NOT IN (SELECT P.DELIVERERID
                            FROM PENALTIES P)

#ex14
SELECT D.DELIVERERID
FROM DELIVERERS D
WHERE D.DELIVERERID IN (SELECT P1.DELIVERERID
                        FROM PENALTIES P1
                        WHERE P1.AMOUNT = 25)
      AND D.DELIVERERID IN (SELECT P2.DELIVERERID
                            FROM PENALTIES P2
                            WHERE P2.AMOUNT = 30)

#ex15
SELECT DISTINCT D.DELIVERERID, D.NAME
FROM DELIVERERS D, PENALTIES P
WHERE D.DELIVERERID = P.DELIVERERID
GROUP BY D.DELIVERERID, D.NAME, P.DATA
HAVING COUNT(*) > 1

#ex16
SELECT CD.DELIVERERID
FROM COMPANYDEL CD
GROUP BY CD.DELIVERERID
HAVING COUNT(DISTINCT CD.COMPANYID) = (SELECT COUNT(*)
                                       FROM COMPANIES)

#ex17
SELECT DISTINCT CD.DELIVERERID
FROM COMPANYDEL CD
WHERE CD.COMPANYID IN (SELECT CD2.COMPANYID
                       FROM COMPANYDEL CD2
                       WHERE CD2.DELIVERERID = 57)
      AND CD.DELIVERERID <> 57

#ex18
SELECT P.DELIVERERID, MIN(P.DATA) AS FIRSTFINE, MAX(P.DATA) AS LASTFINE
FROM PENALTIES P
GROUP BY P.DELIVERERID
HAVING COUNT(*) >= 2
ATHLETE(-ACode-, AName, ASurname, Nationality, BirthDate) 
ATTENDANCE(-CCode-, -ACode-, Position, Time) 
COMPETITION(-CCode-, Place, Date, CType)

a) Show the code and the name of the athletes who never attended any Super G competitions 
(CType = 'Super G’).

SELECT A.Acode, A.AName
FROM ATHLETE A
WHERE A.ACode NOT IN (SELECT AT.Acode
		      FROM ATTENDANCE AT, COMPETITION C
		      WHERE AT.CCode = C.CCode AND C.CType = 'Super G')

b) Find the countries for which at least 5 athletes born before 1980 compete, each of whom 
has participated in at least 10 cross-country skiing competitions.

SELECT A2.Nationality
FROM ATHLETE A2
WHERE A2.BirthDate < '1-1-1980' 
      AND A2.Acode IN (SELECT AT1.ACode
                       FROM ATTENDANCE AT1, COMPETITION C
                       WHERE AT1.CCode = C.CCode AND CType = 'Cross-country-skiing')
                       GROUP BY AT1.ACode
                       HAVING COUNT(*) >= 10)
GROUP BY A2.Nationality
HAVING COUNT(DISTINCT A2.ACode) >= 5
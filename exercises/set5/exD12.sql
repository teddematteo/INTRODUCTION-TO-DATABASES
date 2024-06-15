FILM(-CodF-, Title, ReleaseDate, Genre, DurationMinutes)
CINEMA(-CodC-, Name, Address, City)
HALL(-CodC-, -HallNumber-, Capacity)
SCREENING(-CodC-, -HallNumber-, -Date-, -StartTime-, EndTime, CodF)

a) ...

WITH NOSCREENING AS (SELECT S.CodF, COUNT(*)
		     FROM SCREENING S
		     GROUP BY S.CodF)
SELECT F.Title
FROM FILM F, SCREENING S
WHERE F.CodF = S.CodF
      AND F.DurationMinutes < (SELECT AVG(F1.DurationMinutes)
			       FROM FILM F1
			       WHERE F.Genre = F1.Genre)
GROU BY F.CodF
HAVING COUNT(*) > (SELECT AVG(*)
		   FROM NOSCREENING NS, FILM F2
		   WHERE NS.CodF = F2.CodF AND F2.Genre = F.Genre))
		     

TO SEE
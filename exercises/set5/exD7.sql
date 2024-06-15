GUIDE(-GCode-, Name, Surname, Nationality)
TOUR_TYPE(-TourTypeCode-, Monument, Duration, City)
GROUP(-GRCode-, NumberParticipants, Language)
GUIDED_TOUR(-GRCode-, -Date-, -StartTime-, TourTypeCode, GCode)

a) Among the monuments for which at least 10 guided tours have been made, view 
the monument that has been visited by the largest number of people overall.

WITH MON_VISITS AS (SELECT Monument, SUM(GR.NumberParticipants) AS Num
		    FROM GUIDED_TOUR GT, TOUR_TYPE TT, GROUP GR
		    WHERE GT.TourTypeCode = TT.TourTypeCode AND GT.GRCode = GR.GRCode
		    GROUP BY Monument
		    HAVING COUNT(*) >= 10)
SELECT TT1.Monument
FROM GUIDED_TOUR GT1, TOUR_TYPE TT1, GROUP GR1
WHERE GT1.TourTypeCode = TT1.TourTypeCode AND GT1.GRCode = GR1.GRCode
GROUP BY TT1.Monument
HAVING COUNT(*) >= 10 AND SUM(GR1.NumberParticipants) = (SELECT MAX(Num)
		   		    			 FROM MON_VISITS)

b) For each tour guide who has never guided a type of tour for French-speaking 
groups, show name and surname and, for each date, the total number of type of 
tours guided and their total duration.

SELECT G.Name, G.Surname, GT.Date, COUNT(DISTINCT GT.TourTypeCode), SUM(TT.Duration)
FROM GUIDE G, GUIDED_TOUR GT, TOUR_TYPE TT, GROUP GR
WHERE G.GCode = GT.GCode AND TT.TourTypeCode = GT.TourTypeCode AND GR.GRCode = GT.GRCode
      AND G.GCode IN (SELECT GT1.GCode
		      FROM GUIDED_TOUR GT1
		      WHERE GT1.TourTypeCode NOT IN (SELECT GT2.TourTypeCode
					             FROM GUIDED_TOUR GT2, GROUP G2
						     WHERE GT2.GCode = G2.GCode
							   AND G2.Language = 'French'))
GROUP BY G.GCode, G.Name, G.Surname, GT.Date

#1 The subsubquery selects all the tour types that have done at least one French tour
#2 The subquery selects all the guides that have guided a type of tour which is not in the previous subsubquery
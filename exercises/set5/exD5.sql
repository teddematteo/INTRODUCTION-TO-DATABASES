MECHANIC(-ID-, Name) 
CAN-REPAIR(-ID-, -FaultType-) 
HAS-DONE-REPAIR(-RCode-, ID, LicensePlate, Date, Duration, FaultType)

a) Find the name of the mechanics who have carried out at least one repair of a fault 
that they did not know how to repair.

SELECT DISTINCT M.Name
FROM MECHANIC M, HAS-DONE-REPAIR HDR
WHERE M.ID = HDR.ID AND HDR.FaultType NOT IN (SELECT CR.FaultType
					      FROM CAN-REPAIR CR
					      WHERE CR.ID = HDR.ID)

b) For cars that required repairs carried out by at least 3 different mechanics on the 
same day, display the car's license plate, the date of repairs and the types of faults 
that occurred, sorting the result in ascending order of license plate and descending 
order of date.

#1 table of reparations of a car in each day
#2 we join with initial to obtain all the faults

SELECT HDR1.LicensePlate, HDR1.Date, R.FaultType
FROM HAS-DONE-REPAIR HDR1, (SELECT HDR.LicensePlate, HDR.Date
			    FROM HAS-DONE-REPAIR HDR
			    GROUP BY HDR.LicensePlate, HDR.Date
			    HAVING COUNT(DISTINCT HDR.ID) >= 3) AS R
WHERE HDR1.LicensePlate = R.LicensePlate AND HDR1.Date = R.Date
ORDER BY HDR1.LicensePlate ASC, HDR1.Date DESC


AIRCRAFT(-SerialNumber-, Model, Capacity)
SCHEDULE(-Code-, Departure, Destination, DepartureTime, ArrivalTime)
FLIGHTS(Code, -SerialNumber-, -Date-, NoReservations)

a) Find the routes (city of departure, city of arrival) that have never been made with a Boing
747 aircraft.

SELECT (S.Departure, S1.Destination)
FROM SCHEDULE S
WHERE NOT EXISTS (SELECT *
		  FROM SCHEDULE S1, FLIGHTS F, AIRCRAFT A
		  WHERE S1.Code = F.Code AND F.SerialNumber = A.SerialNumber AND A.Model = 'Boing-747'
                        AND S.Departure = S1.Departure AND S.Destination = S1.Destination)

#we are not sure that the flight has been made (?)

SELECT (S.Departure, S.Destination)
FROM SCHEDULE S, FLIGHTS F
WHERE S.Code = F.Code AND NOT EXISTS (SELECT *
		                      FROM SCHEDULE S1, FLIGHTS F1, AIRCRAFT A
		                      WHERE S1.Code = F1.Code AND F1.SerialNumber = A.SerialNumber 
                                      AND A.Model = 'Boing-747'
                                      AND S.Departure = S1.Departure AND S.Destination = S1.Destination)

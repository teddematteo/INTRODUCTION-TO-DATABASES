AIRCRAFT(-SerialNumber-, Model, Capacity)
SCHEDULE(-Code-, Departure, Destination, DepartureTime, ArrivalTime)
FLIGHTS(Code, -SerialNumber-, -Date-, NoReservations)

a) Find out the code and departure time of flights departing from Milan to Naples 
on 1 October 1993, which still have free seats and whose duration (difference 
between the time of arrival and the time of departure) is less than the average 
duration of flights from Milan to Naples.

SELECT S.Code, S.Departure
FROM SCHEDULE S, FLIGHTS F, AIRCRAFT A
WHERE S.Code = F.Code AND A.SerialNumber = F.SerialNumber
      AND S.Departure = 'Milan' AND S.Destination = 'Naples' AND F.Date = '1/10/1993'
      AND F.NoReservations < A.Capacity
      AND S.ArrivalTime - S.DepartureTime < (SELECT AVG(S1.ArrivalTime - S1.DepartureTime)
					     FROM SCHEDULE S1
					     WHERE S1.Departure = 'Milan' AND S1.Destination = 'Naples')

# again, we are not user that the flight has departed

SELECT S.Code, S.Departure
FROM SCHEDULE S, FLIGHTS F, AIRCRAFT A
WHERE S.Code = F.Code AND A.SerialNumber = F.SerialNumber
      AND S.Departure = 'Milan' AND S.Destination = 'Naples' AND F.Date = '1/10/1993'
      AND F.NoReservations < A.Capacity
      AND S.ArrivalTime - S.DepartureTime < (SELECT AVG(S1.ArrivalTime - S1.DepartureTime)
					     FROM SCHEDULE S1, FLIGHTS F1
					     WHERE S1.Code = F1.Code AND S1.Departure = 'Milan'
						   AND S1.Destination = 'Naples')
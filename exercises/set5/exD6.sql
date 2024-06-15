MEETING_ROOM(-RCode-, NumberSeats, Projector)
BOOKING(-RCode-, -Date-, -StartTime-, EndTime, ECode)
EMPLOYEE(-ECode-, Name, Surname, BirthDate, City)

a) View the code and maximum number of seats in projector-equipped rooms that 
have been booked at least 15 times for meetings starting before 3:00 p.m., but 
have never been booked for meetings starting after 8:00 p.m.

SELECT MR.RCode, MR.NumberSeats
FROM BOOKING B, MEETING_ROOM MR
WHERE B.RCode = MR.RCode
      AND MR.Projector = True 
      AND MR.RCode IN (SELECT B2.RCode
		       FROM BOOKING B2
		       WHERE B2.StartTime < '15:00'
		       GROUP BY B2.RCode
		       HAVING COUNT(*) >= 15)
      AND MR.RCode NOT IN (SELECT DISTINCT B3.RCode
			   FROM BOOKING B3
			   WHERE B3.StartTime > '20:00')

b) View for each room the room code, the maximum number of seats and the 
number of reservations considering only the last date on which the room was 
booked

SELECT MR.RCode, MR.NumberSeats, COUNT(*)
FROM BOOKING B, MEETING_ROOM MR
WHERE B.RCode = MR.RCode
      AND B.Date = (SELECT MAX(B2.Date)
		    FROM BOOKING B2
		    WHERE B2.RCode = B.RCode)
GROUP BY MR.RCode, MR.NumberSeats	   
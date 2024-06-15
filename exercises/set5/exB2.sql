COURSE(-CourseID-, CourseName, Year, Semester) 
COURSE_SCHEDULE(-CourseID-, -WeekDay-, -StartTime-, EndTime, Room)

a) Find classrooms where first-year classes were never held.

SELECT DISTINCT Room
FROM COURSE_SCHEDULE CS
WHERE Room NOT IN (SELECT Room
	 	   FROM COURSE_SCHEDULE CS1, COURSE C
	 	   WHERE CS1.CourseID = C.CourseID AND Year = 1)

SELECT DISTINCT Room
FROM COURSE_SCHEDULE CS
WHERE NOT EXISTS (SELECT *
		  FROM COURSE_SCHEDULE CS1, COURSE C
		  WHERE CS1.CourseID = C.CourseID AND Year = 1 AND CS.Room = CS1.Room)
	
COURSE (-CourseID-, CourseName, Year, Semester) 
COURSE_SCHEDULE (-CourseID-, -WeekDay-, -StartTime-, EndTime, Room)

a) Find course code, course name and total number of lessons per week for third-year 
courses for which the total number of lessons per week is greater than 10 and lessons 
are on more than three different days of the week.

SELECT C.CourseID, CourseName, COUNT(*)
FROM COURSE C, COURSE_SCHEDULE CS
WHERE C.CourseID = CS.CourseID AND C.Year = 3
GROUP BY C.CourseID, CourseName
HAVING COUNT(DISTINCT WeekDay)>2 AND COUNT(*)>10
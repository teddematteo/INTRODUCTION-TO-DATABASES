STUDENT(-StudID-, SName, City)
COURSE(-CourseID-, CName, TeacherID)
TEACHER(-TeacherID-, TName)
EXAM(-CourseID-, -StudID-, Date, Grade)

a) Find the student ID and the maximum, minimum and average exam grade for each 
student

SELECT StudID, MAX(Grade), Min(Grade), AVG(Grade)
FROM EXAM E
GROUP BY StudID

b) Find the student ID, the name, and the maximum, minimum and average exam grade 
for each student

SELECT S.StudID, SName, MAX(Grade), Min(Grade), AVG(Grade)
FROM STUDENT S, EXAM E
WHERE S.StudID = E.StudID
GROUP BY S.StudID, S.SName

c) For each student with an average grade higher than 28, find the studentID, name, and 
the maximum, minimum and average exam grade for each student

SELECT S.StudID, SName, MAX(Grade), Min(Grade), AVG(Grade)
FROM STUDENT S, EXAM E
WHERE S.StudID = E.StudID
GROUP BY S.StudID, SName
HAVING AVG(Grade)>28

d) For each student with an average grade higher than 28 and who has had exams in at 
least 10 different dates, find the student ID, the name and the maximum, minimum 
and average exam grade for each student

SELECT S.StudID, SName, MAX(Grade), Min(Grade), AVG(Grade)
FROM STUDENT S, EXAM E
WHERE S.StudID = E.StudID
GROUP BY S.StudID, SName
HAVING AVG(Grade)>28 AND COUNT(DISTINCT Date)>=10


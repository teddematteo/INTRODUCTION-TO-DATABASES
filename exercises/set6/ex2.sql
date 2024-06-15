/*COURSE(-CourseCode-, CourseName, Credits)
STUDENT(-RegNum-, StudentName, YearFirstEnrollment)
EXAM(-CourseCode-, -RegNum-, -Date-, Score)
GRANT_APPLICATION(-RegNum-, RequestDate)
STUDENT_RANKING(-RegNum-, TotalPoints)
GRANT_AVAILABILITY(-Grant#-, CourseCode, TeachingHours)
GRANT_ASSIGNMENT(-Grant#-, RegNum, TeachingHours)
NOTIFICATION(-Not#-, Grant#, RegNum*, Message)*/

/*The trigger application deals with the assignment of student grants for supporting teaching activities.
Students applying for a student grant are inserted into a ranking (table STUDENT_RANKING). When a
new grant becomes available (table GRANT_AVAILABILITY), the student recipient of the grant is
selected from the ranking. The same student may be the recipient of more than one grant, provided that
she/he does not exceed 150 hours of teaching activities. Write the triggers managing the following tasks
for the automatic assignment of student grants.*/

/*a) Grant application. A student applies for the assignment of a student grant (insertion into table
GRANT_APPLICATION). The application is accepted if (i) the student has acquired at least 120
credits on passed exams (i.e., on exams with score above 17) and (ii) the student is not yet in the
ranking (i.e., in table STUDENT_RANKING). If any of the two requirements is not satisfied, the
application is rejected. If the application is accepted, the student is inserted in the ranking. The total
points (attribute TotalPoints) of the student are given by the average score computed only on passed
exams divided by the years elapsed from the student first enrollment (the current year is given by the
variable YEAR(SYSDATE)).*/

CREATE TRIGGER GrantApplication
AFTER INSERT INTO GRANT_APPLICATION
FOR EACH ROW
-- WHEN
DECLARE
    CREDITS NUMBER;
    AVERAGE NUMBER;
    PRESENT NUMBER;
    FIRSTYEAR NUMBER;
    TOTPOINTS NUMBER;
BEGIN
    SELECT SUM(C.Credits), AVG(E.Score) INTO CREDITS, AVERAGE
    FROM COURSE C, EXAM E
    WHERE E.RegNum = :NEW.RegNum AND C.CourseCode = E.CourseCode AND E.Score > 17;

    SELECT COUNT(*) INTO PRESENT -- 1 present / 0 not present
    FROM STUDENT_RANKING
    WHERE RegNum = :NEW.RegNum;

    IF (CREDITS >= 120 AND PRESENT = 0) THEN -- accepted
        SELECT YearFirstEnrollment INTO FIRSTYEAR
        FROM STUDENT
        WHERE RegNum = :NEW.RegNum;

        TOTPOINTS := AVERAGE/(YEAR(SYSDATE)-FIRSTYEAR);

        INSERT INTO STUDENT_RANKING (RegNum, TotalPoints)
        VALUES (:NEW.RegNum, TOTPOINTS);
    ELSE
        RAISE_APPLICATION_ERROR(XXX,'Not enough credits or student has already applied')
    END IF;
END;

/*b) Grant assignment. When a new grant becomes available (insertion into table 
GRANT_AVAILABILITY),  the  recipient  student  is  selected  from  the  ranking.  The  recipient  is  the 
student  with  the  highest  ranking  that  satisfies  the  following  requirements:  (i)  she/he  has  passed  the 
exam  for  the  course  on  which  the  grant  is  available,  and  (ii)  she/he  does  not  exceed  150  teaching 
hours  overall  (including  also  the  new  grant).  Suppose  that  at  most  one  student  satisfies  the  above 
requirements.  If  the  grant  is  assigned,  table  GRANT_ASSIGNMENT  should  be  appropriately 
modified. The result of the assignment process must be notified both in the positive case (the grant is 
assigned)  and  in  the  negative  case  (no  appropriate  student  is  available,  in  this  case  the  RegNum 
attribute takes the NULL value). The Not# attribute is a counter, which is incremented for each new 
notification.*/

CREATE TRIGGER GrantAssignment
AFTER INSERT INTO GRANT_AVAILABILITY
FOR EACH ROW
-- WHEN
DECLARE
    WINNER VARCHAR(10);
    NOTNUM NUMBER;
    MESSAGE VARCHAR(255);
BEGIN
    WITH VALIDSTUDENTS AS (SELECT SR.RegNum, SR.TotalPoints -- CT of students with prerequisites
                           FROM STUDENT_RANKING SR
                           WHERE SR.RegNum IN (SELECT E.RegNum
                                               FROM EXAM E
                                               WHERE E.CourseCode = :NEW.CourseCode AND E.Score > 17)
                                 AND 150 - :NEW.TeachingHours >= (SELECT SUM(GA.TeachingHours)
                                                                  FROM GRANT_ASSIGNMENT GA
                                                                  WHERE GA.RegNum = SR.RegNum))
    SELECT VS.RegNum INTO WINNER -- select the student with max score
    FROM VALIDSTUDENTS VS
    WHERE VS.TotalPoints = (SELECT MAX(VS2.TotalPoints)
                            FROM VALIDSTUDENTS VS2);

    SELECT MAX(Not#) INTO NOTNUM -- last notification number
    FROM NOTIFICATION;

    IF (NOTNUM IS NULL) THEN
        NOTNUM := 0;
    END IF;

    IF (WINNER IS NULL) THEN 
        MESSAGE := 'Grant not assigned';
    ELSE -- if winner not null we add record to GRANT_ASSIGNMENT
        INSERT INTO GRANT_ASSIGNMENT (Grant#, RegNum, TeachingHours)
        VALUES (:NEW.Grant#, WINNER, :NEW.TeachingHours);

        MESSAGE := 'Grant is assigned';
    END IF;

    -- send notification
    INSERT INTO NOTIFICATION (Not#, Grant#, RegNum*, Message)
    VALUES (NOTNUM+1, :NEW.Grant#, WINNER, MESSAGE);

END;
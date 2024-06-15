/*PERSON(-RegNumber-, Job) 
SHIFT(-RegNumber-, -Date-, TCode) 
SHIFT-TYPE(-TCode-, StartTime, Duration) 
LEAVE-REQUEST(-RCode-, RegNumber, Date) 
NOTIFICATION(-RegNumber-, -Date-, RequestOutcome)*/

/*Write a trigger to manage one-day leave requests by people working in a hospital (insert into the 
LEAVE-REQUEST table).  
 
A leave request is accepted if the person requesting it is not on duty in the requested date (SHIFT table). If instead 
the person is on duty, the request is accepted only if another person is available to fill the requester's shift. 
Otherwise, the request is declined. A person may substitute another person on a shift if they both have the same 
job and the substitute is not on duty in the same date.  
 
The outcome of the request (accepted or declined) must be notified by means of an insert into the 
NOTIFICATION table.*/

CREATE OR REPLACE TRIGGER LeaveRequest
AFTER INSERT ON LEAVE-REQUEST
FOR EACH ROW
-- WHEN
DECLARE
    A NUMBER; -- person in charge that date
    REQ VARCHAR(25) := 'accepted'; -- outcome of the request
    SUB NUMBER; -- # people that can substitute
    JOB VARCHAR(25);
BEGIN
    SELECT Job INTO JOB
    FROM PERSON
    WHERE RegNumber = :NEW.RegNumber;

    SELECT COUNT(*) INTO A -- 0 or 1
    FROM SHIFT
    WHERE RegNumber = :NEW.RegNumber AND Date = :NEW.Date;

    IF (A<>0) THEN -- not free in that date
        SELECT COUNT(*) INTO SUB -- number of possible substitutes
        FROM PERSON P2
        WHERE P2.RegNumber NOT IN (SELECT DISTINCT P.RegNumber -- all people that have a shift in that date
                                   FROM PERSON P, SHIFT S
                                   WHERE P.RegNumber = S.RegNumber AND P.Job = JOB AND Date = :NEW.Date)
              AND P2.RegNumber <> :NEW.RegNumber; -- exclude the current
        
        IF (SUB=0) THEN
            REQ := 'not accepted';
        END IF;
    END IF;

    INSERT INTO NOTIFICATION (RegNumber, Date, RequestOutcome)
    VALUES (:NEW.RegNumber, :NEW.Date, REQ);
END;


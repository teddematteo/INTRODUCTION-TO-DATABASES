/*EVENT(-EvID-, EventName, EventCategory, EventCost, EventDuration)  
CALENDAR(-EvID-, -Date-, StartTime, Location)  
CATEGORY_SUMMARY(-EventCategory-, -Date-, TotalNumberEvents, TotalEventCost)*/

/*You are requested to manage the planning of events in the city of Turin for the anniversary of the 150th 
anniversary of the unification of Italy (Italia 150).  
Events belong to different categories (EventCategory attribute), such as exhibitions, debates, screenings, 
and are characterized by a cost of  realization (EventCost attribute). Each  event can be repeated several 
times  on  different  dates.  The  CALENDAR  table  shows  the  planning  of  events  on  different  days  and 
places in the city. Write triggers to handle the following tasks.*/

/*a) Updating the table CATEGORY_SUMMARY. The table CATEGORY_SUMMARY shows, for each 
category  of  event  and  for  each  date,  the  total  number  of  events  planned  and  the  total  cost  for  their 
realization.  Write the trigger to propagate changes to the CATEGORY_SUMMARY table when a new 
calendar event is inserted (CALENDAR table insertion).*/

CREATE OR REPLACE TRIGGER NewEvent
AFTER INSERT ON CALENDAR
FOR EACH ROW
-- WHEN
DECLARE
    CAT VARCHAR(100); -- category of the added event
    COST NUMBER; -- cost of the event
    EX NUMBER;
BEGIN
    SELECT EventCategory, EventCost INTO CAT, COST -- category of the event added
    FROM EVENT
    WHERE EvID = :NEW.EvID;

    SELECT COUNT(*) INTO N -- 0 category doesn't exist, otherwise it exists
    FROM CATEGORY_SUMMARY
    WHERE EventCategory = CAT AND Date = :NEW.Date;

    IF (N=0) THEN -- category not present
        INSERT INTO CATEGORY_SUMMARY (EventCategory, Date, TotalNumberEvents, TotalEventCost)
        VALUES (CAT, :NEW.Date, 1, COST);
    ELSE -- category already present
        UPDATE CATEGORY_SUMMARY
        SET TotalNumberEvents = TotalNumberEvents + 1,
            TotalEventCost = TotalEventCost + COST
        WHERE EventCategory = CAT AND Date = :NEW.Date;
    END IF;
END;

/*b) Integrity  constraint  on  the  maximum  cost  of  the  event.  The  cost  of  an  event  in  the  film  screening 
category (EventCategory attribute) cannot exceed 1500 euros. If a cost value greater than 1500 is entered 
in  the  EVENT  table,  the  EventCost  attribute  must  be  assigned  a  value  of  1500.  Write  the  trigger  for 
handling the integrity constraint.*/

CREATE OR REPLACE TRIGGER EventConstraint
AFTER INSERT OR UPDATE OF EventCost, EventCategory ON EVENT
FOR EACH ROW
WHEN NEW.EventCost > 1500 AND NEW.EventCategory = 'film screening'
BEGIN
    UPDATE EVENT
    SET EventCost = 1500
    WHERE EvID = :NEW.EvID;
END;

-- BETTER: we modify :NEW before inserting or updating
CREATE OR REPLACE TRIGGER EventConstraint
BEFORE INSERT OR UPDATE OF EventCost, EventCategory ON EVENT
FOR EACH ROW
WHEN NEW.EventCost > 1500 AND NEW.EventCategory = 'film screening'
BEGIN
    :NEW.EventCost := 1500;
END;

/*c) Constraint on the maximum number of events per date. No more than 10 events can be scheduled on 
any given date. Any changes to the table CALENDAR that cause the constraint violation should not be 
performed.*/

-- ask!
CREATE OR REPLACE TRIGGER MaxEvents
BEFORE INSERT OR UPDATE OF CALENDAR
FOR EACH ROW
-- WHEN
DECLARE
    TOT NUMBER;
BEGIN
    SELECT COUNT(*) INTO TOT
    FROM CALENDAR
    WHERE Date = :NEW.Date;
    
    IF (TOT>=10) THEN
        RAISE_APPLICATION_ERROR(X,'Too many events for the same date');
    END IF;
END;


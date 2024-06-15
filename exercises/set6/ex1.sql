/*ATHLETE(-AthleteCode-, TeamName)
ATHLETE_ARRIVAL(-AthleteCode-, Time)
TEAM_ARRIVAL(-TeamName-, NumberArrivedAthletes)
RANKING(-AthleteCode-, Position, Time)*/

/*Write triggers to update TEAM_ARRIVAL and RANKING tables when a new row is inserted in the
ATHLETE_ARRIVAL table.*/

-- a) For the update of the TEAM_ARRIVAL table, consider also the case of a team not yet inserted in the table.

CREATE TRIGGER UpdateTeamArrival
AFTER INSERT ON ATHLETE_ARRIVAL
FOR EACH ROW
-- WHEN
DECLARE
    N NUMBER; -- team present
    T VARCHAR(10); -- team name
BEGIN
    SELECT TeamName INTO T
    FROM ATHLETE
    WHERE AthleteCode = :NEW.AthleteCode;

    SELECT COUNT(*) INTO N -- N is 0 or 1
    FROM TEAM_ARRIVAL
    WHERE TeamName = T;  
    
    IF (N=1) THEN -- team present
        UPDATE TEAM_ARRIVAL
        SET NumberArrivedAthletes = NumberArrivedAthletes + 1
        WHERE TeamName = T;
    ELSE -- team not present
        INSERT INTO TEAM_ARRIVAL (TeamName, NumberArrivedAthletes)
        VALUES(T, 1)
    END IF;
END;

-- b) For the update of RANKING table, consider that the Time field can assume the same value for two different athletes.

CREATE TRIGGER UpdateRanking
AFTER INSERT ON ATHLETE_ARRIVAL
FOR EACH ROW
-- WHEN
DECLARE
    EMPTY NUMBER;
    POS NUMBER;
BEGIN
    SELECT COUNT(*) INTO EMPTY
    FROM RANKING;

    IF (EMPTY>0) THEN -- table not empty
        SELECT Position INTO POS
        FROM RANKING
        WHERE Time = :NEW.Time;

        IF (POS=NULL) THEN -- not draw
            SELECT MIN(Position) INTO POS
            FROM RANKING
            WHERE Time > :NEW.Time;

            IF (POS=NULL) THEN -- when it's the last POS is NULL and we need to recompute
                SELECT MAX(Position) INTO POS
                FROM RANKING
                WHERE Time < :NEW.Time;
            END IF;

            UPDATE RANKING
            SET Position = Position + 1
            WHERE Time > :NEW.Time
        END IF;
    ELSE
        POS:=1;
    END IF;

    INSERT INTO RANKING (AthleteCode, Position, Time)
    VALUES (:NEW.AthleteCode, POS, :NEW.Time);
END;

-- other solution (optimized)

CREATE TRIGGER UpdateTrigger
AFTER INSERT ON ATHLETE_ARRIVAL
FOR EACH ROW
-- WHEN
DECLARE
    POS NUMBER;
    ATIME NUMBER;
    DRAW BOOLEAN := FALSE;
BEGIN
    SELECT MAX(Time), MAX(Position) INTO ATIME, POS
    FROM RANKING
    WHERE Time <= :NEW.Time;

    -- if it's the first or table is empty, POS is NULL
    IF (POS IS NULL) THEN
        POS := 1;
    ELSE
        IF (ATIME <> :NEW.Time) THEN -- without draw the pos is increased
            POS := POS + 1;
        ELSE
            DRAW := TRUE;
        END IF;
    END IF;

    IF (DRAW = FALSE) THEN
        UPDATE RANKING
        SET Position = Position + 1
        WHERE Time > :NEW.Time;
    END IF;

    INSERT INTO RANKING (AthleteCode, Position, Time)
    VALUES (:NEW.AthleteCode, POS, :NEW.Time);
END;

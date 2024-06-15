-- #ex1
SELECT RV.ROOM_UNIQUE_NUMBER, COUNT(*) AS NUMRESERVATIONS
FROM RESERVATION RV
GROUP BY RV.ROOM_UNIQUE_NUMBER

-- #ex2
SELECT R.TYPE, COUNT(*) AS NUM
FROM ROOM R
WHERE R.UNIQUE_NUMBER NOT IN (SELECT RV.ROOM_UNIQUE_NUMBER
                              FROM RESERVATION RV)
GROUP BY R.TYPE

-- #ex3
WITH AVERMONTHLYCOST AS (SELECT ROOM_UNIQUE_NUMBER, EXTRACT(MONTH FROM TO_DATE(START_DATE,'MM/DD/YYYY')) AS MON, AVG(DAILY_PRICE) AS AVER
                         FROM RESERVATION
                         GROUP BY ROOM_UNIQUE_NUMBER, EXTRACT(MONTH FROM TO_DATE(START_DATE,'MM/DD/YYYY'))),
     MAXAVERMONTHLYCOST AS (SELECT MON, MAX(AVER) AS MAXIM
                            FROM AVERMONTHLYCOST
                            GROUP BY MON)
SELECT AMC.MON, R.UNIQUE_NUMBER, R.FLOOR, R.SURFACE_AREA, R.TYPE
FROM AVERMONTHLYCOST AMC, ROOM R
WHERE AMC.ROOM_UNIQUE_NUMBER = R.UNIQUE_NUMBER AND AVER = (SELECT MAMC.MAXIM
                                                           FROM MAXAVERMONTHLYCOST MAMC
                                                           WHERE MAMC.MON = AMC.MON)
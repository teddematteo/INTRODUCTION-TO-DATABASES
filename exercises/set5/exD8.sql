TEENAGER(-TaxID-, Name, Surname, Birthdate, City)
ACTIVITY(-ACode-, ActivityName, Description, Category)
SUMMER_CAMP(-CCode-, CampName, City)
REGISTRATION-FOR-ACTIVITIES-IN-SUMMER-CAMP(-TaxID-, -ACode-, -CCode-, -RegistrationDate-)

a) View the first and last name of the teenagers who participated in the largest 
number of summer camps for the activities in the "Tennis" category.

WITH TENNISNUM AS (SELECT R.TaxID, COUNT(DISTINCT R.CCode) AS Num
		   FROM REGISTRATION-FOR-ACTIVITIES-IN-SUMMER-CAMP R, ACTIVITY A
		   WHERE R.ACode = A.ACode AND A.Category = 'Tennis'
		   GROUP BY R.TaxID)
SELECT T.Name, T.Surname
FROM REGISTRATION-FOR-ACTIVITIES-IN-SUMMER-CAMP R1, ACTIVITY A1, TEENAGER T
WHERE R1.ACode = A1.ACode AND R1.TaxID = T.TaxID AND A1.Category = 'Tennis'
GROUP BY R.TaxID
HAVING COUNT(DISTINCT R1.CCode) = (SELECT MAX(Num)
			 	   FROM TENNISNUM)

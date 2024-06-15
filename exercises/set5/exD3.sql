MC_TEST(-TestID-, Topic, Score)
STUDENT(-StudentID-, Name, Address, CityA)
TEST-RESULT(-StudentID-, -TestID-, isCorrectAnswer)

a) Find the names of students who did not correctly answer any math multiple choice 
test.

SELECT S.Name
FROM STUDENT S, TEST-RESULT TR1, MC_TEST MC1
WHERE NOT EXISTS (SELECT *
		  FROM TEST-RESULT TR, MC_TEST MC
		  WHERE TR.TestID = MC.TestID AND MC.Topic = 'Math'
		        AND isCorrectAnswer = 'True' AND S.StudentID = TR.StudentID)
      AND S.StudentID = TR1.StudentID AND MC1.TestID = TR1.TestID AND Topic = 'Math'

# we need to impose that each student has answered at least one math MC test

b) Find the names of the students in Turin who achieved the maximum possible score 
in the math multiple choice test.

#1 If "max possible score" means max between the students

WITH SR AS (SELECT TR.StudentID, SUM(MC.Score) AS Sum
            FROM TEST-RESULT TR, MC_TEST MC
            WHERE TR.TestID = MC.TestID AND MC.Topic = 'Math'
            GROUP BY TR.StudentID)
SELECT S.Name
FROM STUDENT S, SR
WHERE S.StudentID = SR.StudentID AND S.CityA = 'Turin'
      AND SR.Sum = SELECT(MAX(SR.Sum) FROM SR)

#2 If "max possible score" means all corrects

SELECT S.Name
FROM STUDENT S, TEST-RESULT TR, MC_TEST MC
WHERE TR.StudentID = S.StudentID AND TR.TestID = MC.TestID
      AND MC.Topic = 'Math' AND S.ACity = 'Turin'
GROUP BY S.StudentID, S.Name
HAVING SUM(MC.Score) = (SELECT SUM(MC1.Score)
			FROM MC_TEST MC1
			WHERE MC1.Topic = 'Math')
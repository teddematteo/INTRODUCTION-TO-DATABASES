/*EMPLOYEE(-EmployeeNumber-, Name, Surname, Department)
PROJECT(-ProjectCode-, Title, Description, ExpectedDeadline)
EVALUATION(-EmployeeNumber-, -ProjectCode-, DeliveryDate, AssessmentDate, AssessmentScore) 

Express the following query in SQL language

For each employee, view the employee's first and last name, and the title and description of each project for which the employee received an assessment score higher than the average score received by employees who worked on that project.*/

-- ct with average score for each project
WITH AVERAGE_SCORE AS (SELECT E.ProjectCode, AVG(E.AssessmentScore) AS AvScore
                       FROM EVALUATION E
                       GROUP BY E.ProjectCode)
SELECT E.Name, E.Surname, P.Title, P.Description
FROM EMPLOYEE E, PROJECT P, EVALUATION EV
WHERE EV.EmployeeNumber = E.EmployeeNumber AND EV.ProjectCode = P.ProjectCode -- join condition
      AND EV.AssessmentScore > (SELECT AVS.AvScore -- average for that project
                                FROM AVERAGE_SCORE AVS
                                WHERE AVS.ProjectCode = EV.ProjectCode);
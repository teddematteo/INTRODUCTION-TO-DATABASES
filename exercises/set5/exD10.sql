TAXPAYER(-TaxId-, Name, Street, City) 
TAX_RETURN(-ReturnID-, Type, Income)
PRESENTS(-TaxId-, -ReturnID-, Date)

a) Display the tax ID, name, and average income reported from 1990 onwards by taxpayers whom 
maximum income reported since 1990 is higher than the average income calculated on all tax 
retruns in the database.



SELECT TP.TaxID, TP.Name, AVG(TR.Income)
FROM TAXPAYER TP, TAX_RETURN TR, PRESENTS P
WHERE TP.TaxID = P.TaxID AND TR.ReturnID = P.ReturnID AND P.Date >= '01-01-1990'
GROUP BY TP.TaxID, TP.Name
HAVING MAX(TR.Income) > (SELECT AVG(TR2.Income)
			 FROM TAX_RETURN TR2)


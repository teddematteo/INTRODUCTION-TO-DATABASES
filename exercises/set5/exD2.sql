PUBLISHER(-PCode-, EditorName, Address, City) 
BOOK(-BCode-, Title, AuthorName, PCode)
BOOKSTORE(-BSCode-, BookshopName, Address, City)
SALE(-BCode-, -BSCode-, -Date-, NoCopies)

a) Find the name of the bookstores where no books from publishers based in Turin 
have been sold.

SELECT B.BookshopName
FROM BOOKSTORE B
WHERE B.BSCode NOT IN (SELECT B1.BSCode
                       FROM BOOKSTORE B1, SALE S, BOOK BK, PUBLISHER P
		       WHERE S.BCode = BK.BCode AND S.BSCode = B1.BSCode AND BK.PCode = P.PCode
		       AND P.City = 'Turin')

 #unuseful join

b) Find the name of the publishers for which at least 10 publications were sold in 
2002 in bookstores in Rome in more than 2,000 copies.

#1 The book must be sold in 2002 in Rome bookstores more than 2000 copies
#2 The publisher must have sold at least 10 books with previous conditions

SELECT P.EditorName
FROM BOOK B1, PUBLISHER P1
WHERE B1.PCode = P1.PCode AND B1.BCode IN (SELECT S.BCode
   					   FROM BOOKSTORE B, SALE S
					   WHERE B.BCode = S.BCode AND B.City = 'Rome' AND S.Date = '2002'
					   GROUP BY S.BCode
					   HAVING SUM(NoCopies) > 2000)
GROUP BY P.PCode, P.EditorName
HAVING COUNT(*) >= 10
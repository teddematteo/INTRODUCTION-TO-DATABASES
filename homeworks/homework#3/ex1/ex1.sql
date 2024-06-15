/*BOOK(-BookCode-, Title, Genre)
AUTHOR(-AuthorCode-, Name, Surname, BirthDate)
AUTHORS_BOOK(-BookCode-, -AuthorCode-)
PUBLISHER(-PublisherCode-, Name, City)
PUBLICATION(-BookCode-, -PublisherCode-, PublicationYear, NumberCopies)

Express the following query in SQL language:

For each author who has published at least 3 books in the 'Science Fiction' genre, but who has never published any 'Horror' or 'Mystery' boos, display the author's name and surname and, for each published book, the title , the genre, and the total number of copies published of that book.*/

-- since a book can be published by more publishers, we need a CT which represents each published book
-- PUBLICATION cannot be used because we can have the repetition of the same book in different publications
-- BOOK cannot be used because we don't know if the book has been published
WITH PUBLISHED_BOOK AS (SELECT B.BookCode, B.Title, B.Genre, SUM(P.NumberCopies) AS TotNumberCopies
                        FROM BOOK B, PUBLICATION P
                        WHERE B.BookCode = P.BookCode
                        GROUP BY B.BookCode, B.Title, B.Genre)
SELECT A.Name, A.Surname, PB.Title, PB.Genre, PB.TotNumberCopies
FROM AUTHORS_BOOK AB, AUTHOR A, PUBLISHED_BOOK PB
WHERE AB.AuthorCode = A.AuthorCode AND PB.BookCode = AB.BookCode -- join condition
      AND A.AuthorCode IN (SELECT AB2.AuthorCode -- authors with at least 3 published books in 'Science Fiction'
                           FROM AUTHORS_BOOK AB2, PUBLISHED_BOOK PB2
                           WHERE AB2.BookCode = PB2.BookCode AND PB2.Genre = 'Science Fiction'
                           GROUP BY AB2.AuthorCode
                           HAVING COUNT(*) >= 3)
      AND A.AuthorCode NOT IN (SELECT DISTINCT AB3.AuthorCode -- authors with at least a published book in 'Horror' or 'Mystery'
                               FROM AUTHORS_BOOK AB3, PUBLISHED_BOOK PB3
                               WHERE AB3.BookCode = PB3.BookCode 
                                     AND (PB3.Genre = 'Horror' OR PB3.Genre = 'Mystery'));
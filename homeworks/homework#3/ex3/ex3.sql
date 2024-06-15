/*CUSTOMER(-CustomerID-, FirstName, LastName, City)
STORE(-StoreID-, StoreName, Address, City)
ORDER(-StoreID-, -CustomerID-, -Date-, Amount)

Express the following query in SQL language

For each store that received the highest number of orders among stores in the same city, display the store name, the city of the store, and for each order received, the first name and last name of the customer who placed the order, the order date, and the order amount.*/

-- ask!
WITH TOT_ORDERS_FOR_STORE AS (SELECT StoreID, COUNT(*) AS Tot -- orders for each store
                              FROM ORDER
                              GROUP BY StoreID),
     MAX_ORDERS_FOR_CITY AS (SELECT S.City, MAX(TOFS.Tot) AS Max -- max orders for each city
                             FROM TOT_ORDERS_FOR_STORE TOFS, STORE S
                             WHERE TOFS.StoreID = S.StoreID
                             GROUP BY S.City),
     STORE_HIGHEST_FOR_CITY AS (SELECT S.StoreID -- list of stores with requested conditions
                                FROM TOT_ORDERS_FOR_STORE TOFS, MAX_ORDERS_FOR_CITY MOFC, STORE S
                                WHERE S.StoreID = TOFS.StoreID AND S.City = MOFC.City AND TOFS.Tot = MOFC.Max)
SELECT S.StoreName, S.City, C.FirstName, C.LastName, O.Date, O.Amount
FROM STORE_HIGHEST_FOR_CITY SHFC, STORE S, ORDER O, CUSTOMER C
WHERE SHFC.StoreID = S.StoreID AND S.StoreID = O.StoreID AND O.CustomerID = C.CustomerID
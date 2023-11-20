/*
The WHERE clause specifies which record(s) that should be updated. 
If you omit the WHERE clause, all records in the table will be updated!
*/

UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;


# DELETE
DELETE FROM table_name WHERE condition;

# DELETE ALL ROWS IN A TABLE WITHOUT DELETING THE TABLE 
DELETE FROM Customers;

# DELETE A TABLE COMPLETELY
DROP TABLE Customers; 

# Select only the first 3 records of the Customers table:
SELECT TOP 3 * FROM Customers;

#MySQL Syntax:

SELECT column_name(s)
FROM table_name
WHERE condition
LIMIT number;

/*
Add the ORDER BY keyword when you want to sort the result, 
and return the first 3 records of the sorted result.
*/

SELECT * FROM Customers
ORDER BY CustomerName DESC
LIMIT 3;

SELECT MIN(Price) AS SmallestPrice
FROM Products;

/*
The LIKE operator is used in a WHERE clause to search for a specified pattern in a column.
The percent sign % represents zero, one, or multiple characters
 The underscore sign _ represents one, single character
*/

SELECT * FROM Customers
WHERE CustomerName LIKE 'a%';


/*
Return all customers from a city that starts with 'L' followed by one wildcard character, then 'nd' and then two wildcard characters:
*/
SELECT * FROM Customers
WHERE city LIKE 'L_nd__';


# Return all customers from a city that contains the letter 'L'
SELECT * FROM Customers
WHERE city LIKE '%L%';


# Return all customers that starts with 'La':
SELECT * FROM Customers
WHERE CustomerName LIKE 'La%';


# Return all customers that starts with 'a' or starts with 'b':
SELECT * FROM Customers
WHERE CustomerName LIKE 'a%' OR CustomerName LIKE 'b%';


# Return all customers that ends with 'a':
SELECT * FROM Customers
WHERE CustomerName LIKE '%a';


#Return all customers that starts with "b" and ends with "s":
SELECT * FROM Customers
WHERE CustomerName LIKE 'b%s';

#Return all customers that contains the phrase 'or'
SELECT * FROM Customers
WHERE CustomerName LIKE '%or%';

#Return all customers that starts with "a" and are at least 3 characters in length:
SELECT * FROM Customers 
WHERE CustomerName LIKE "a___%";

#Return all customers that have "r" in the second position:
SELECT * FROM Customers 
WHERE CustomerName LIKE "_r%";

#If no wildcard is specified, the phrase has to have an exact match to return a result.
# Return all customers from Spain 
SELECT * FROM Customers 
WHERE Country LIKE "Spain";

# Select all records where the value of the City column does NOT start with the letter "a".
SELECT * FROM Customers 
WHERE City NOT LIKE "a%";

/*
popular wildcard chars 
%	Represents zero or more characters
_	Represents a single character
[]	Represents any single character within the brackets *
^	Represents any character not in the brackets *
-	Represents any single character within the specified range *
{}	Represents any escaped character **

*/

#The [] wildcard returns a result if any of the characters inside gets a match.
# Return all customers starting with either "b", "s", or "p":
SELECT * FROM Customers 
WHERE CustomerName LIKE "[bsp]%";

#The - wildcard allows you to specify a range of characters inside the [] wildcard.
#Return all customers starting with "a", "b", "c", "d", "e" or "f"
SELECT * FROM Customers 
WHERE CustomerName LIKE "[a-f]%";

#Return all customers that starts with "a" and are at least 3 characters in length:
SELECT * FROM Customers 
WHERE CustomerName LIKE "a___%"; 

#Return all customers that have "r" in the second position:
SELECT * FROM Customers 
WHERE CustomerName LIKE "_r%";

#Select all records where the first letter of the City is NOT an "a" or a "c" or an "f".
SELECT * FROM Customers 
WHERE City LIKE "[^acf]%";

#Return all customers from 'Germany', 'France', or 'UK'
SELECT * FROM Customers
WHERE Country IN ('Germany', 'France', 'UK');

/*
You can also use IN with a subquery in the WHERE clause.

With a subquery you can return all records from the main query that are present in the result of the subquery.
*/

#Return all customers that have an order in the Orders table:
SELECT * FROM Customers 
WHERE CustomerID IN (
SELECT CustomerID FROM Orders
);

#To display the products outside the range of the previous example, use NOT BETWEEN:
SELECT * FROM Products
WHERE Price NOT BETWEEN 10 AND 20;

#The following SQL statement selects all products with a price between 10 and 20. In addition, the CategoryID must be either 1,2, or 3:
SELECT * FROM Products 
WHERE Price BETWEEN 10 AND 20 
AND CategoryID IN (1,2,3);

#The following SQL statement selects all products with a ProductName alphabetically between Carnarvon Tigers and Mozzarella di Giovanni:
SELECT * FROM Products 
WHERE ProductName BETWEEN "Carnarvon Tigers" AND "Mozzarella di Giovanni"
ORDER BY ProductName;

#selects all orders with an OrderDate between '01-July-1996' and '31-July-1996':
SELECT * FROM Order 
WHERE OrderDate BETWEEN "1996-07-01" AND "1996-07-31";

#An alias is created with the AS keyword.
SELECT column_name AS alias_name
FROM table_name;

SELECT column_name(s)
FROM table_name AS alias_name;

#Using [square brackets] for aliases with space characters:
SELECT ProductName AS [My Great Products]
FROM Products;

#Using "double quotes" for aliases with space characters:
SELECT ProductName AS "My Great Products"
FROM Products;

# inner join 
SELECT Orders.OrderID, Customers.CustomerName, Orders.OrderDate
FROM Orders
INNER JOIN Customers ON Orders.CustomerID=Customers.CustomerID;


# select all the records from the Customers table plus all the matches in the Orders table.
SELECT *  FROM ORDERS 
RIGHT JOIN Customers
ON Orders.CustomerID = Customers.CustomerID; 


# Join three tables 
SELECT Orders.OrderID, Customers.CustomerName, Shippers.ShipperName 
FROM (
(Orders INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID)
INNER JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID);

#select all customers, and any orders they might have
# The LEFT JOIN keyword returns all records from the left table (Customers), even if there are no matches in the right table (Orders).
SELECT Customers.CustomerName, Orders.OrderID 
FROM Customers 
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID 
ORDER BY Customers.CustomerName; 


#return all employees, and any orders they might have placed:
#The RIGHT JOIN keyword returns all records from the right table (Employees), even if there are no matches in the left table (Orders).
SELECT Orders.OrderID, Employees.LastName, Employees.FirstName
FROM Orders
RIGHT JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID 
ORDER BY Orders.OrderID; 


#selects all customers, and all orders:
#returns all matching records from both tables whether the other table matches or not. So, if there are rows in "Customers" that do not have matches in "Orders", or if there are rows in "Orders" that do not have matches in "Customers", those rows will be listed as well.
SELECT Customers.CustomerName, Orders.OrderID 
FROM Customers 
FULL OUTER JOIN Orders ON Customers.CustomerID = Orders.CustomerID 
ORDER BY Customers.CustomerName; 


# SELF JOIN
# Matches customers that are from the same city 
SELECT
    A.CustomerName AS CustomerName1,
    B.CustomerName AS CustomerName2,
    A.City
FROM
    Customers A, Customers B
WHERE
    A.CustomerID <> B.CustomerID 
    AND A.City = B.City
ORDER BY 
    A.City;

# UNION
# Returns the German cities (distinct values) from both the "Customers" and the "Suppliers" table
SELECT
    City
FROM
    Customers
WHERE
    Country = 'Germany'
UNION
SELECT
    City
FROM
    Suppliers 
WHERE
    Country = 'Germany'
ORDER BY 
    City;

# UNION ALL returns duplicate values also 


# UNION with Aliases, create a new temp column named "Type" that list whether the contact person is a "Customer" or "Supplier"
SELECT
    'Customer' AS Type, ContactName, City, Country   
FROM
    Customers 
UNION 
SELECT 
    'Supplier', ContactName, City, Country
FROM 
    Suppliers;

# GROUP BY 
# groups rows that have the same values into summary rows, like "find the number of customers in each country".
SELECT
    COUNT(CustomerID),
    Country
FROM
    Customers
GROUP BY 
    Country
ORDER BY 
    COUNT(CustomerID) DESC;

# JOIN Orders and Shippers table
# Then find the number of orders sent by each shipper
SELECT 
    Shippers.ShipperName, 
    COUNT(Orders.OrderID) AS NumberOfOrders
FROM 
    Orders  
LEFT JOIN  
    Shippers 
        ON Orders.ShipperID = Shippers.ShipperID
GROUP BY 
    ShipperName;



/*
HAVING
because WHERE cannot be used with aggregate function
*/
SELECT
    COUNT(CustomerID),
    Country
FROM 
    Customers
GROUP BY 
    Country
HAVING 
    COUNT(CustomerID)>5
ORDER BY 
    COUNT(CustomerID) DESC;

#ists the employees that have registered more than 10 orders:
SELECT
    Employees.LastName,
    COUNT(Orders.OrderID) AS NumberOfOrders
FROM (
    Orders 
    INNER JOIN 
        Employees
        ON Orders.EmployeeID = Employees.EmployeeID
)
GROUP BY 
    LastName
HAVING
    COUNT(Orders.OrderID)>10; 


#lists if the employees "Davolio" or "Fuller" have registered more than 25 orders:
SELECT 
    Employees.LastName,
    COUNT(Orders.OrderID) AS NumberOfOrders
FROM 
    Orders 
    INNER JOIN 
        Employees  
        ON Orders.EmployeeID = Employees.EmployeeID
WHERE LastName = 'Davolio' OR LastName = 'Fuller'
GROUP BY 
    LastName 
HAVING 
    COUNT(Orders.OrderID) > 25;



# CASE 
# The following SQL goes through conditions and returns a value when the first condition is met:
SELECT 
    OrderId, 
    Quantity,
CASE 
    WHEN Quantity > 30 THEN 'The quantity is greater than 30',
    WHEN Quantity = 30 THEN 'The quantity is 30'
    ELSE 'The quantity is under 30'
END AS 
    QuantityText

FROM 
    OrderDetails;


# The following SQL will order the customers by City. However, if City is NULL, then order by Country:
SELECT
    CustomerName, City, Country
FROM 
    Customers
ORDER BY 
    (
        CASE
            WHEN City is NULL THEN Country 
            ELSE City  
        END
        );


# ANY 
# lists the ProductName if it finds ANY records in the OrderDetails table 
# has Quantity equal to 10 (this will return TRUE because the Quantity column has some values of 10):
SELECT 
    ProductName
FROM 
    Products 
WHERE ProductID = ANY 
    (
        SELECT
            ProductID 
        FROM
            OrderDetails
        WHERE  
            Quantity = 10
        );


# ALL
# lists the ProductName if ALL the records in the OrderDetails table has Quantity equal to 10. 
SELECT 
    ProductName
FROM 
    Products
WHERE 
    ProductID = ALL 
    (
        SELECT 
            ProductID
        FROM 
            OrderDetails
        WHERE
            Quantity = 10 
        );

# SELECT INTO 
# Creates a backup copy of Customers
SELECT *
INTO
    CustomersBackup2017 
FROM 
    Customers; 

# uses the IN clause to copy the table into a new table in another database:
SELECT 
    *
INTO 
    CustomersBackup2017
IN
    'Backup.mdb' 
FROM 
    Customers;


# Copies a few columns into a new table 
SELECT 
    CustomerName, ContactName
INTO 
    CustomersBackup2017
FROM 
    Customers;

# Copy only the German customers into a new table 
SELECT 
    *
INTO 
    CustomersGermany
FROM 
    Customers
WHERE 
    Country = 'Germany';

# Copy data from more than one table into a new table
SELECT 
    Customers.CustomerName, Orders.OrderID
INTO CustomersBackup2017
FROM 
    Customers
LEFT JOIN 
    Orders ON Customers.CustomerID = Orders.CustomerID;


# Tip: SELECT INTO can also be used to create a new, empty table using the schema of another. Just add a WHERE clause that causes the query to return no data:
SELECT 
    *
INTO newtable 
FROM 
    oldtable 
WHERE
    1 = 0;
    





